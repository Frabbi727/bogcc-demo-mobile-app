import 'package:bogcc_demo_mobile_app/app/routes.dart';
import 'package:bogcc_demo_mobile_app/catalogue/registers/registers.dart';
import 'package:bogcc_demo_mobile_app/domain/enums.dart';
import 'package:bogcc_demo_mobile_app/shell/role_config.dart';
import 'package:bogcc_demo_mobile_app/shell/role_configs.dart';
import 'package:flutter_test/flutter_test.dart';

/// The shell is built entirely from these, so a gap here is a role that lands
/// in a broken app rather than a compile error.
void main() {
  group('coverage', () {
    test('every role has a config, citizen included', () {
      for (final role in AppRole.values) {
        expect(kShellConfigs[role], isNotNull, reason: '$role has no shell');
        expect(shellConfigFor(role).title, isNotEmpty);
      }
    });

    test('every config has tabs and a home among them', () {
      for (final role in AppRole.values) {
        final config = shellConfigFor(role);
        expect(config.destinations, isNotEmpty, reason: '$role');
        expect(
          config.destinations.map((d) => d.route),
          contains(config.homeRoute),
          reason: '$role home is not one of its tabs',
        );
      }
    });

    test('tab keys are unique within a config', () {
      for (final role in AppRole.values) {
        final keys = shellConfigFor(role).destinations.map((d) => d.key).toList();
        expect(keys.toSet(), hasLength(keys.length), reason: '$role');
      }
    });

    test('a tab count fits a phone bottom bar', () {
      // More than five destinations do not fit at 400px and Material will not
      // render them sensibly.
      for (final role in AppRole.values) {
        expect(
          shellConfigFor(role).destinations.length,
          inInclusiveRange(3, 5),
          reason: '$role',
        );
      }
    });
  });

  group('routing agreement', () {
    // Every path lib/app/router.dart registers. A tile pointing outside this
    // set is an error page at runtime rather than a compile failure, which is
    // exactly the bug this guards.
    const known = {
      Routes.citizenHome,
      Routes.services,
      Routes.track,
      Routes.messages,
      Routes.profile,
      Routes.holding,
      Routes.verify,
      Routes.notices,
      Routes.officeHome,
      Routes.officeWork,
      Routes.officeRegisters,
      Routes.officeSearch,
      Routes.officeProfile,
    };

    test('every destination points at a declared route', () {
      for (final role in AppRole.values) {
        for (final d in shellConfigFor(role).destinations) {
          expect(known, contains(d.route), reason: '${role.name}/${d.key}');
        }
      }
    });

    test('every home tile points at a declared route', () {
      for (final role in AppRole.values) {
        for (final tile in shellConfigFor(role).tiles) {
          expect(known, contains(tile.route), reason: '${role.name}/${tile.label}');
        }
      }
    });

    test('a citizen never lands in the office side, or the reverse', () {
      // The prefixes are what the router's redirect keys off, so crossing them
      // would drop someone into a shell built for a different role.
      final citizen = shellConfigFor(AppRole.citizen);
      for (final d in citizen.destinations) {
        expect(d.route, startsWith('/nagorik'));
      }
      for (final role in AppRole.values.where((r) => r.isOffice)) {
        for (final d in shellConfigFor(role).destinations) {
          expect(d.route, startsWith('/office'), reason: role.name);
        }
      }
    });

    test('indexOfRoute maps a location back to its tab', () {
      final citizen = shellConfigFor(AppRole.citizen);
      expect(citizen.indexOfRoute(Routes.citizenHome), 0);
      expect(citizen.indexOfRoute(Routes.messages), 3);
      // A leaf under a tab selects that tab.
      expect(citizen.indexOfRoute('/nagorik/track/abc123'), 2);
      // Something unrecognised falls back to home rather than crashing.
      expect(citizen.indexOfRoute('/elsewhere'), 0);
    });
  });

  group('the citizen shell', () {
    final citizen = shellConfigFor(AppRole.citizen);

    test('has the five tabs Phase 1 builds', () {
      expect(
        citizen.destinations.map((d) => d.key),
        ['home', 'services', 'track', 'messages', 'me'],
      );
    });

    test('badges its inbox and nothing else', () {
      final badged = citizen.destinations.where((d) => d.badge != null);
      expect(badged.map((d) => d.key), ['messages']);
      expect(badged.single.badge, BadgeSource.unreadSms);
    });

    test('offers tiles for every citizen-facing thing to do', () {
      expect(citizen.tiles, hasLength(6));
      expect(citizen.tiles.first.tone, TileTone.primary,
          reason: 'applying is the point of the screen');
      expect(
        citizen.tiles.map((t) => t.route),
        containsAll([Routes.services, Routes.track, Routes.holding, Routes.verify]),
      );
    });

    test('has no work queues — a citizen has no desk', () {
      expect(citizen.queues, isEmpty);
      expect(citizen.wardScoped, isFalse);
    });
  });

  group('the office shells', () {
    test('every desk has at least one queue, so no tab is empty', () {
      for (final role in AppRole.values.where((r) => r.isOffice)) {
        expect(shellConfigFor(role).queues, isNotEmpty, reason: role.name);
      }
    });

    test('every queue names a real register, or trade licence', () {
      // Trade licence is the one bespoke module, so it is not in the registry.
      for (final role in AppRole.values.where((r) => r.isOffice)) {
        for (final queue in shellConfigFor(role).queues) {
          for (final key in queue.registerKeys) {
            if (key == 'trade-licence') continue;
            expect(getRegister(key), isNotNull,
                reason: '${role.name}: unknown register "$key"');
          }
        }
      }
    });

    test('every queue status is one that register actually has', () {
      for (final role in AppRole.values.where((r) => r.isOffice)) {
        for (final queue in shellConfigFor(role).queues) {
          for (final key in queue.registerKeys) {
            final config = getRegister(key);
            if (config == null) continue;
            for (final status in queue.statuses) {
              expect(config.statusKeys, contains(status),
                  reason: '${role.name}: $key has no status "$status"');
            }
          }
        }
      }
    });

    test('a desk only queues work it is actually allowed to do', () {
      // A queue that shows a record the role cannot action is a dead end: the
      // detail screen would offer no button.
      for (final role in AppRole.values.where((r) => r.isOffice)) {
        for (final queue in shellConfigFor(role).queues) {
          for (final key in queue.registerKeys) {
            final config = getRegister(key);
            if (config == null) continue;
            for (final status in queue.statuses) {
              expect(
                config.canAdvance(status, role),
                isTrue,
                reason: '${role.name} cannot act on $key/$status',
              );
            }
          }
        }
      }
    });

    test('the councillor is the only ward-scoped desk', () {
      final scoped = AppRole.values
          .where((r) => r.isOffice && shellConfigFor(r).wardScoped);
      expect(scoped, [AppRole.councillor]);
      expect(
        shellConfigFor(AppRole.councillor).queues.every((q) => q.wardScoped),
        isTrue,
      );
    });
  });
}
