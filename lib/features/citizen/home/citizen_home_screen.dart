import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/bn/bn.dart';
import '../../../shell/role_config.dart';
import '../../../state/selectors/citizen_selectors.dart';
import '../../../state/selectors/stats_selectors.dart';
import '../../../state/session_controller.dart';
import '../../../ui/theme/colors.dart';
import '../../../ui/theme/spacing.dart';

class CitizenHomeScreen extends ConsumerWidget {
  const CitizenHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(shellConfigProvider);
    final stats = ref.watch(publicStatsProvider);
    final notices = ref.watch(noticesProvider).take(3).toList();
    final text = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(Insets.lg),
      children: [
        Text('আপনি কী করতে চান?', style: text.titleMedium),
        const SizedBox(height: Insets.md),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: Insets.md,
          mainAxisSpacing: Insets.md,
          childAspectRatio: 1.15,
          children: [
            for (final tile in config.tiles) _Tile(tile: tile),
          ],
        ),

        const SizedBox(height: Insets.xl),
        Text('এই মাসে আমরা', style: text.titleMedium),
        const SizedBox(height: Insets.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: Row(
              children: [
                _Stat(
                  value: formatNumberBn(stats.applicationsThisMonth),
                  label: 'আবেদন গৃহীত',
                ),
                _Stat(
                  value: formatNumberBn(stats.resolvedThisMonth),
                  label: 'সেবা সম্পন্ন',
                ),
                _Stat(
                  value: stats.hasRatings
                      ? formatDecimalBn(stats.averageRating)
                      : '—',
                  label: 'গড় রেটিং',
                ),
              ],
            ),
          ),
        ),

        if (notices.isNotEmpty) ...[
          const SizedBox(height: Insets.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('সর্বশেষ নোটিশ', style: text.titleMedium),
              TextButton(
                onPressed: () => context.push(Routes.notices),
                child: const Text('সব দেখুন'),
              ),
            ],
          ),
          for (final notice in notices)
            Card(
              margin: const EdgeInsets.only(bottom: Insets.sm),
              child: ListTile(
                title: Text(notice.title, style: text.titleSmall),
                subtitle: Text(
                  formatDateBn(notice.at),
                  style: text.labelSmall,
                ),
                onTap: () => context.push(Routes.notices),
              ),
            ),
        ],
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.tile});

  final HomeTile tile;

  @override
  Widget build(BuildContext context) {
    final primary = tile.tone == TileTone.primary;
    final text = Theme.of(context).textTheme;

    return Card(
      color: primary ? AppColors.forest700 : null,
      child: InkWell(
        onTap: () => context.push(tile.route),
        borderRadius: BorderRadius.circular(Radii.md),
        child: Padding(
          padding: const EdgeInsets.all(Insets.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                tile.icon,
                size: 26,
                color: primary ? Colors.white : AppColors.forest700,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tile.label,
                    style: text.titleSmall?.copyWith(
                      color: primary ? Colors.white : AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: Insets.xs - 2),
                  Text(
                    tile.hint,
                    style: text.labelSmall?.copyWith(
                      color: primary ? Colors.white70 : AppColors.muted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Text(value, style: text.headlineSmall),
          const SizedBox(height: Insets.xs - 2),
          Text(label, style: text.labelSmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
