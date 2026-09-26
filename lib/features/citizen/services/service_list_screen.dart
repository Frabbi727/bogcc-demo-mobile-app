import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../catalogue/services.dart';
import '../../../core/bn/bn.dart';
import '../../../domain/enums.dart';
import '../../../ui/theme/colors.dart';
import '../../../ui/theme/spacing.dart';

/// The citizen charter: every service, what it costs and how long it takes.
class ServiceListScreen extends ConsumerWidget {
  const ServiceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(Insets.lg),
      children: [
        Text('নাগরিক সনদ', style: text.headlineSmall),
        const SizedBox(height: Insets.xs),
        Text(
          'প্রতিটি সেবার নির্ধারিত সময় ও ফি নিচে দেওয়া আছে। সব হার ডেমো।',
          style: text.bodySmall,
        ),
        const SizedBox(height: Insets.lg),
        for (final service in services)
          Padding(
            padding: const EdgeInsets.only(bottom: Insets.md),
            child: _ServiceCard(service: service),
          ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});

  final ServiceDef service;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: () => context.push(Routes.serviceDetailFor(service.key)),
        borderRadius: BorderRadius.circular(Radii.md),
        child: Padding(
          padding: const EdgeInsets.all(Insets.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(service.name, style: text.titleSmall),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.muted),
                ],
              ),
              const SizedBox(height: Insets.xs),
              Text(
                service.description,
                style: text.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Insets.sm),
              Wrap(
                spacing: Insets.sm,
                runSpacing: Insets.xs,
                children: [
                  _Chip(
                    icon: Icons.schedule_outlined,
                    label: service.charterDays == 0
                        ? 'তাৎক্ষণিক'
                        : '${toBnDigits(service.charterDays)} কার্যদিবস',
                  ),
                  _Chip(
                    icon: service.fee.kind == FeeKind.free
                        ? Icons.check_circle_outline
                        : Icons.payments_outlined,
                    label: service.fee.label,
                  ),
                  _Chip(
                    icon: Icons.apartment_outlined,
                    label: service.section,
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

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.muted),
        const SizedBox(width: Insets.xs),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
