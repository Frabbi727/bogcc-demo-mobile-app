import 'dart:io';

import 'package:bogcc_demo_mobile_app/app/routes.dart';
import 'package:bogcc_demo_mobile_app/domain/enums.dart';
import 'package:bogcc_demo_mobile_app/shell/role_configs.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every destination and tile in the shell must have a route the router serves.
///
/// This reads the router's source rather than building it, which is unusual but
/// buys the right thing cheaply: a tile pointing at an unregistered path is not
/// a compile error, it is an error page the first time someone taps it — and
/// four of them shipped that way before this test existed. Building the real
/// GoRouter would need the whole provider graph and a temp Hive directory to
/// check something that is, in the end, a spelling question.
void main() {
  final source = File('lib/app/router.dart').readAsStringSync();

  /// Paths the router registers, both the explicit ones and the office branch
  /// list, which is generated from a loop.
  final registered = <String>{
    ...RegExp(r'path: Routes\.(\w+)')
        .allMatches(source)
        .map((m) => m.group(1)!),
    ...RegExp(r'\(Routes\.(\w+),')
        .allMatches(source)
        .map((m) => m.group(1)!),
  };

  /// Maps a literal path back to the Routes member that names it.
  const names = <String, String>{
    Routes.citizenHome: 'citizenHome',
    Routes.services: 'services',
    Routes.track: 'track',
    Routes.messages: 'messages',
    Routes.profile: 'profile',
    Routes.holding: 'holding',
    Routes.verify: 'verify',
    Routes.notices: 'notices',
    Routes.about: 'about',
    Routes.officeHome: 'officeHome',
    Routes.officeWork: 'officeWork',
    Routes.officeRegisters: 'officeRegisters',
    Routes.officeSearch: 'officeSearch',
    Routes.officeProfile: 'officeProfile',
  };

  test('the router registers a route for every tab in every shell', () {
    for (final role in AppRole.values) {
      for (final destination in shellConfigFor(role).destinations) {
        final name = names[destination.route];
        expect(name, isNotNull,
            reason: '${destination.route} is not in the names map above');
        expect(
          registered,
          contains(name),
          reason: '${role.name}/${destination.key} points at '
              '${destination.route}, which the router does not serve',
        );
      }
    }
  });

  test('the router registers a route for every home tile', () {
    for (final role in AppRole.values) {
      for (final tile in shellConfigFor(role).tiles) {
        final name = names[tile.route];
        expect(name, isNotNull, reason: '${tile.route} is not in the names map');
        expect(
          registered,
          contains(name),
          reason: '${role.name} tile "${tile.label}" points at ${tile.route}, '
              'which the router does not serve',
        );
      }
    }
  });

  test('the profile screen only links somewhere the router serves', () {
    final profile =
        File('lib/features/citizen/profile/profile_screen.dart')
            .readAsStringSync();
    final pushed = RegExp(r'context\.(?:push|go)\(Routes\.(\w+)\)')
        .allMatches(profile)
        .map((m) => m.group(1)!);
    expect(pushed, isNotEmpty);
    for (final name in pushed) {
      expect(registered, contains(name), reason: 'profile links to $name');
    }
  });
}
