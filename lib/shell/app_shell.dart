/// The one shell both faces of the app use.
///
/// Nothing here mentions the citizen or any particular desk: the tabs, the
/// title and the badges all come from the signed-in role's [ShellConfig].
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/bn/bn.dart';
import '../state/selectors/citizen_selectors.dart';
import '../state/session_controller.dart';
import '../ui/theme/colors.dart';
import 'demo_banner.dart';
import 'role_config.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(shellConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(config.title),
            if (config.subtitle.isNotEmpty)
              Text(
                config.subtitle,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Colors.white70),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          const DemoBanner(),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          // Tapping the tab you are already on returns to its root, which is
          // what every phone app does and what a lost user expects.
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          for (final destination in config.destinations)
            NavigationDestination(
              icon: _Badged(
                source: destination.badge,
                child: Icon(destination.icon),
              ),
              selectedIcon: _Badged(
                source: destination.badge,
                child: Icon(destination.selectedIcon),
              ),
              label: destination.label,
            ),
        ],
      ),
    );
  }
}

/// Wraps an icon with its unread count, when the destination declares one.
class _Badged extends ConsumerWidget {
  const _Badged({required this.source, required this.child});

  final BadgeSource? source;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (source == null) return child;

    final count = switch (source!) {
      BadgeSource.unreadSms => ref.watch(unreadMessageCountProvider),
      // Phase 2 desks; no queue is computed yet, so nothing is claimed.
      BadgeSource.myPendingWork => 0,
      BadgeSource.overdue => 0,
    };
    if (count == 0) return child;

    return Badge(
      backgroundColor: AppColors.stamp,
      label: Text(toBnDigits(count)),
      child: child,
    );
  }
}
