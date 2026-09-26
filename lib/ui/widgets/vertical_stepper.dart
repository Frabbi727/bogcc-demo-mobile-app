import 'package:flutter/material.dart';

import '../../core/bn/bn.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

class StepEntry {
  const StepEntry({
    required this.label,
    this.at,
    this.note,
    this.byName,
    this.done = false,
    this.cancelled = false,
  });

  final String label;
  final DateTime? at;
  final String? note;
  final String? byName;
  final bool done;
  final bool cancelled;
}

/// The progress of one application, read top to bottom.
///
/// Shows every step the service promises, not only the ones that have happened,
/// so a citizen can see what is still to come rather than only where they are.
class VerticalStepper extends StatelessWidget {
  const VerticalStepper({required this.steps, super.key});

  final List<StepEntry> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < steps.length; i++)
          _Step(entry: steps[i], isLast: i == steps.length - 1),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.entry, required this.isLast});

  final StepEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final color = entry.cancelled
        ? AppColors.stamp
        : entry.done
            ? AppColors.forest700
            : AppColors.rule;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Icon(
                entry.cancelled
                    ? Icons.cancel
                    : entry.done
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                size: 20,
                color: color,
              ),
              if (!isLast)
                Expanded(
                  child: VerticalDivider(
                    width: 1,
                    color: entry.done ? AppColors.forest700 : AppColors.rule,
                  ),
                ),
            ],
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : Insets.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.label,
                    style: text.titleSmall?.copyWith(
                      color: entry.done || entry.cancelled
                          ? AppColors.ink
                          : AppColors.muted,
                    ),
                  ),
                  if (entry.at != null) ...[
                    const SizedBox(height: 2),
                    Text(formatDateTimeBn(entry.at!), style: text.labelSmall),
                  ],
                  if (entry.byName != null) ...[
                    const SizedBox(height: 2),
                    Text(entry.byName!, style: text.labelSmall),
                  ],
                  if (entry.note != null) ...[
                    const SizedBox(height: Insets.xs),
                    Container(
                      padding: const EdgeInsets.all(Insets.sm),
                      decoration: BoxDecoration(
                        color: entry.cancelled
                            ? AppColors.stamp.withValues(alpha: 0.07)
                            : AppColors.paper,
                        borderRadius: BorderRadius.circular(Radii.sm),
                      ),
                      child: Text(entry.note!, style: text.bodySmall),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
