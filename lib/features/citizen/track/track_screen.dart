import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../catalogue/services.dart';
import '../../../core/bn/bn.dart';
import '../../../domain/enums.dart';
import '../../../domain/models/base_record.dart';
import '../../../domain/rules/sla.dart';
import '../../../state/selectors/citizen_selectors.dart';
import '../../../ui/theme/colors.dart';
import '../../../ui/theme/spacing.dart';
import '../../../ui/widgets/empty_state.dart';
import '../../../ui/widgets/status_badge.dart';

/// Everything this citizen has applied for, plus a lookup by tracking number.
class TrackScreen extends ConsumerWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(myRequestsProvider);
    final text = Theme.of(context).textTheme;

    if (requests.isEmpty) {
      return EmptyState(
        icon: Icons.timeline,
        title: 'কোনো আবেদন নেই',
        detail: 'আপনার মোবাইল নম্বরে করা আবেদনগুলো এখানে দেখা যাবে।',
        action: FilledButton(
          onPressed: () => context.go(Routes.services),
          child: const Text('সেবা দেখুন'),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(Insets.lg),
      children: [
        Text('আমার আবেদন', style: text.headlineSmall),
        const SizedBox(height: Insets.xs),
        Text(
          '${toBnDigits(requests.length)}টি আবেদন পাওয়া গেছে',
          style: text.bodySmall,
        ),
        const SizedBox(height: Insets.lg),
        for (final record in requests)
          Padding(
            padding: const EdgeInsets.only(bottom: Insets.md),
            child: RequestCard(record: record),
          ),
      ],
    );
  }
}

/// One application, as the citizen sees it.
class RequestCard extends StatelessWidget {
  const RequestCard({required this.record, super.key});

  final BaseRecord record;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final service = serviceOf(record.serviceKey);
    final cancelled = record.cancelled != null;
    final label = cancelled
        ? 'বাতিল'
        : citizenLabel(record.serviceKey, record.status);

    return Card(
      child: InkWell(
        onTap: () => context.push(Routes.requestDetailFor(record.id)),
        borderRadius: BorderRadius.circular(Radii.md),
        child: Padding(
          padding: const EdgeInsets.all(Insets.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      service?.name ?? record.serviceKey,
                      style: text.titleSmall?.copyWith(
                        // A cancelled record stays visible and struck through,
                        // the way a ruled line stays in a paper book.
                        decoration:
                            cancelled ? TextDecoration.lineThrough : null,
                        color: cancelled ? AppColors.muted : null,
                      ),
                    ),
                  ),
                  if (record.channel == Channel.online)
                    const ToneBadge(
                      label: 'অনলাইন',
                      tone: Tone.info,
                      icon: Icons.language,
                    ),
                ],
              ),
              const SizedBox(height: Insets.xs),
              Text(toBnDigits(record.trackingNo), style: text.labelSmall),
              const SizedBox(height: Insets.sm),
              // Wrap rather than Row: a long status label next to an overdue
              // badge and a timestamp overflows at phone width, and clipping
              // the date is worse than letting the line wrap.
              Wrap(
                spacing: Insets.sm,
                runSpacing: Insets.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ToneBadge(
                    label: label,
                    tone: cancelled ? Tone.danger : Tone.info,
                  ),
                  SlaBadge(status: slaStatus(record)),
                  Text(timeAgoBn(record.createdAt), style: text.labelSmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
