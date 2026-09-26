import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../catalogue/registers/registers.dart';
import '../../../catalogue/services.dart';
import '../../../core/bn/bn.dart';
import '../../../shell/demo_banner.dart';
import '../../../ui/theme/colors.dart';
import '../../../ui/theme/spacing.dart';

/// One service's charter entry: what it costs, how long it takes, what to bring
/// and which steps it goes through.
class ServiceCharterScreen extends ConsumerWidget {
  const ServiceCharterScreen({required this.serviceKey, super.key});

  final String serviceKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = serviceOf(serviceKey);
    final text = Theme.of(context).textTheme;

    if (service == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('সেবা')),
        body: const Center(child: Text('সেবাটি পাওয়া যায়নি।')),
      );
    }

    final register = registerForService(service.key);

    return Scaffold(
      appBar: AppBar(title: Text(service.name)),
      body: Column(
        children: [
          const DemoBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(Insets.lg),
              children: [
                Text(service.description, style: text.bodyMedium),
                const SizedBox(height: Insets.lg),

                Card(
                  child: Column(
                    children: [
                      _Row(
                        icon: Icons.schedule_outlined,
                        label: 'নির্ধারিত সময়',
                        value: service.charterDays == 0
                            ? 'একই দিনে'
                            : '${toBnDigits(service.charterDays)} কার্যদিবস',
                      ),
                      const Divider(height: 1),
                      _Row(
                        icon: Icons.payments_outlined,
                        label: 'ফি',
                        value: service.fee.label,
                      ),
                      const Divider(height: 1),
                      _Row(
                        icon: Icons.apartment_outlined,
                        label: 'দায়িত্বপ্রাপ্ত শাখা',
                        value: service.section,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Insets.lg),

                Text('প্রয়োজনীয় কাগজপত্র', style: text.titleMedium),
                const SizedBox(height: Insets.sm),
                for (final doc in service.requiredDocs)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Insets.xs),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Icon(Icons.check_circle_outline,
                              size: 15, color: AppColors.forest700),
                        ),
                        const SizedBox(width: Insets.sm),
                        Expanded(child: Text(doc, style: text.bodySmall)),
                      ],
                    ),
                  ),

                if (register != null) ...[
                  const SizedBox(height: Insets.lg),
                  Text('আবেদনের ধাপ', style: text.titleMedium),
                  const SizedBox(height: Insets.sm),
                  for (var i = 0; i < register.steps.length; i++)
                    _Step(
                      number: i + 1,
                      label: register.steps[i].citizenLabel,
                      isLast: i == register.steps.length - 1,
                    ),
                ],

                const SizedBox(height: Insets.xl),
                if (service.infoOnly)
                  _ExternalNotice(service: service)
                else if (service.citizenFacing && register != null)
                  FilledButton.icon(
                    onPressed: () =>
                        context.push(Routes.applyFor(service.key)),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('আবেদন করুন'),
                  )
                else
                  _CounterOnlyNotice(section: service.section),
                const SizedBox(height: Insets.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A service the corporation does not deliver itself.
class _ExternalNotice extends StatelessWidget {
  const _ExternalNotice({required this.service});

  final ServiceDef service;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.sky.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: AppColors.sky.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.open_in_new, size: 16, color: AppColors.sky),
              const SizedBox(width: Insets.sm),
              Text('এই সেবাটি অন্যত্র', style: text.titleSmall),
            ],
          ),
          const SizedBox(height: Insets.sm),
          Text(
            'জন্ম ও মৃত্যু নিবন্ধন হয় সরকারের জাতীয় BDRIS পোর্টালে।',
            style: text.bodySmall,
          ),
          const SizedBox(height: Insets.sm),
          // Shown as text, not a link: the app cannot open a browser without
          // network permission, and a dead button is worse than an address.
          SelectableText(
            service.externalUrl ?? '',
            style: text.bodyMedium?.copyWith(color: AppColors.sky),
          ),
        ],
      ),
    );
  }
}

class _CounterOnlyNotice extends StatelessWidget {
  const _CounterOnlyNotice({required this.section});

  final String section;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.forest50,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.storefront_outlined,
              size: 18, color: AppColors.forest700),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: Text(
              'এই সেবার আবেদন $section-এ সরাসরি জমা দিতে হয়।',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(Insets.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: AppColors.muted),
          const SizedBox(width: Insets.md),
          Expanded(child: Text(label, style: text.bodySmall)),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: text.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.number,
    required this.label,
    required this.isLast,
  });

  final int number;
  final String label;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.forest50,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  toBnDigits(number),
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.forest700),
                ),
              ),
              if (!isLast)
                const Expanded(child: VerticalDivider(width: 1)),
            ],
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : Insets.md),
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}
