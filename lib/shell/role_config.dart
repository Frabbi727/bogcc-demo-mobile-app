/// What a role sees.
///
/// One config per role drives the whole shell — the tabs, the home tiles, the
/// title — so a citizen and each of the ten office desks get their own app
/// without any screen knowing which role it is rendering for. Adding an office
/// role in Phase 2 is an entry in [kShellConfigs], not a new screen.
library;

import 'package:flutter/material.dart';

import '../domain/enums.dart';

/// Where a tab's badge number comes from. Resolved by a provider, so the config
/// stays const and free of any dependency on the store.
enum BadgeSource {
  /// Unread simulated SMS for the signed-in citizen.
  unreadSms,

  /// Records waiting on this desk. Phase 2.
  myPendingWork,

  /// Records past their charter deadline. Phase 2.
  overdue,
}

class NavDestination {
  const NavDestination({
    required this.key,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
    this.badge,
  });

  final String key;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;
  final BadgeSource? badge;
}

enum TileTone { primary, neutral, warn }

class HomeTile {
  const HomeTile({
    required this.label,
    required this.hint,
    required this.icon,
    required this.route,
    this.tone = TileTone.neutral,
  });

  final String label;
  final String hint;
  final IconData icon;
  final String route;
  final TileTone tone;
}

/// A desk's inbox: which registers feed it and which statuses it acts on.
///
/// Declared now but unused in Phase 1. It is what lets the office home screen
/// be the same widget as the citizen one, reading a list instead of tiles.
class WorkQueueSpec {
  const WorkQueueSpec({
    required this.label,
    required this.registerKeys,
    required this.statuses,
    this.wardScoped = false,
  });

  final String label;
  final List<String> registerKeys;
  final List<String> statuses;
  final bool wardScoped;
}

class ShellConfig {
  const ShellConfig({
    required this.role,
    required this.title,
    required this.homeRoute,
    required this.destinations,
    this.subtitle = '',
    this.tiles = const [],
    this.queues = const [],
    this.wardScoped = false,
    this.sections = const {},
  });

  final AppRole role;
  final String title;
  final String subtitle;
  final String homeRoute;
  final List<NavDestination> destinations;
  final List<HomeTile> tiles;
  final List<WorkQueueSpec> queues;

  /// The councillor sees only their own ward.
  final bool wardScoped;

  /// Which office sections this desk's registers belong to.
  final Set<String> sections;

  /// The tab a location belongs to.
  ///
  /// Matches the **longest** destination prefix, not the first: the home route
  /// (`/nagorik`) is a prefix of every sibling (`/nagorik/track`), so a plain
  /// first-match would select home for every screen in the app.
  int indexOfRoute(String route) {
    var best = -1;
    var bestLength = -1;
    for (var i = 0; i < destinations.length; i++) {
      final candidate = destinations[i].route;
      if (route == candidate ||
          route.startsWith('$candidate/') ||
          (candidate == homeRoute && route == candidate)) {
        if (candidate.length > bestLength) {
          best = i;
          bestLength = candidate.length;
        }
      }
    }
    return best < 0 ? 0 : best;
  }
}
