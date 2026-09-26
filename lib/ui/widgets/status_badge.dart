import 'package:flutter/material.dart';

import '../../domain/enums.dart';
import '../../domain/rules/sla.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

/// A small coloured label. One widget for statuses, channels and SLA, so the
/// same meaning always reads the same colour across the app.
class ToneBadge extends StatelessWidget {
  const ToneBadge({required this.label, required this.tone, this.icon, super.key});

  final String label;
  final Tone tone;
  final IconData? icon;

  static const _colors = <Tone, Color>{
    Tone.neutral: AppColors.muted,
    Tone.info: AppColors.sky,
    Tone.pending: AppColors.amber,
    Tone.success: AppColors.forest700,
    Tone.danger: AppColors.stamp,
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[tone]!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.sm,
        vertical: Insets.xs - 1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Radii.sm),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: Insets.xs),
          ],
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

/// How a record stands against its charter deadline.
class SlaBadge extends StatelessWidget {
  const SlaBadge({required this.status, super.key});

  final SlaStatus status;

  @override
  Widget build(BuildContext context) {
    // On-time is the normal case and needs no decoration — badging everything
    // makes a list unreadable.
    if (status == SlaStatus.onTime) return const SizedBox.shrink();

    return ToneBadge(
      label: slaLabel[status]!,
      tone: status == SlaStatus.overdue ? Tone.danger : Tone.pending,
      icon: status == SlaStatus.overdue
          ? Icons.error_outline
          : Icons.schedule_outlined,
    );
  }
}
