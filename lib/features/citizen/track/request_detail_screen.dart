import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../catalogue/registers/registers.dart';
import '../../../catalogue/services.dart';
import '../../../core/bn/bn.dart';
import '../../../domain/enums.dart';
import '../../../domain/models/base_record.dart';
import '../../../domain/models/register_entry.dart';
import '../../../domain/rules/sla.dart';
import '../../../shell/demo_banner.dart';
import '../../../state/actions/payment_actions.dart';
import '../../../state/providers.dart';
import '../../../ui/theme/colors.dart';
import '../../../ui/theme/spacing.dart';
import '../../../ui/widgets/status_badge.dart';
import '../../../ui/widgets/vertical_stepper.dart';

/// One application, as the citizen sees it.
///
/// This is the citizen half of what will become a shared detail screen: it uses
/// the register's `citizenLabel` for each step, shows only notes staff marked
/// public, and hides staff-only fields entirely.
class RequestDetailScreen extends ConsumerWidget {
  const RequestDetailScreen({required this.recordId, super.key});

  final String recordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(demoStoreProvider);
    final BaseRecord? record = state.entry(recordId) ?? state.licence(recordId);

    if (record == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('আবেদন')),
        body: const Center(child: Text('আবেদনটি পাওয়া যায়নি।')),
      );
    }

    final service = serviceOf(record.serviceKey);
    final register = registerForService(record.serviceKey);
    final text = Theme.of(context).textTheme;
    final cancelled = record.cancelled != null;

    return Scaffold(
      appBar: AppBar(title: Text(service?.name ?? 'আবেদন')),
      body: Column(
        children: [
          const DemoBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(Insets.lg),
              children: [
                _Header(record: record, cancelled: cancelled),
                const SizedBox(height: Insets.lg),

                if (cancelled) ...[
                  _CancelledNotice(reason: record.cancelled!.reason),
                  const SizedBox(height: Insets.lg),
                ],

                Text('অগ্রগতি', style: text.titleMedium),
                const SizedBox(height: Insets.md),
                VerticalStepper(
                  steps: _stepsFor(record, register?.statusKeys, cancelled),
                ),
                const SizedBox(height: Insets.xl),

                if (!cancelled && record is RegisterEntry && register != null)
                  _PayAction(entry: record, register: register),

                if (record is RegisterEntry && register != null) ...[
                  Text('আবেদনের তথ্য', style: text.titleMedium),
                  const SizedBox(height: Insets.sm),
                  Card(
                    child: Column(
                      children: [
                        for (final field in register.fields.where(
                          // Staff-only columns are the office's working notes;
                          // they are not part of what the citizen submitted.
                          (f) => !f.staffOnly && record.data[f.key] != null,
                        ))
                          _DataRow(
                            label: field.label,
                            value: _display(record, field.key, field.type),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: Insets.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Every step the service promises, with the ones that happened filled in.
  List<StepEntry> _stepsFor(
    BaseRecord record,
    List<String>? statusKeys,
    bool cancelled,
  ) {
    final register = registerForService(record.serviceKey);
    final service = serviceOf(record.serviceKey);
    final keys = statusKeys ?? service?.statuses ?? const <String>[];

    // Only public notes reach the citizen, but every status change is shown:
    // they should know a step happened even when the remark on it was internal.
    final history = {
      for (final step in record.history) step.status: step,
    };
    final reached = record.history.map((h) => h.status).toSet();

    final steps = <StepEntry>[
      for (final key in keys)
        StepEntry(
          label: register?.stepOf(key)?.citizenLabel ??
              citizenLabel(record.serviceKey, key),
          at: history[key]?.at,
          note: history[key]?.publicNote ?? false ? history[key]?.note : null,
          done: reached.contains(key),
        ),
    ];

    if (cancelled) {
      steps.add(
        StepEntry(
          label: 'বাতিল',
          at: record.cancelled!.at,
          note: record.cancelled!.reason,
          byName: record.cancelled!.by,
          cancelled: true,
          done: true,
        ),
      );
    }
    return steps;
  }

  String _display(RegisterEntry entry, String key, FieldType type) {
    final Object? value = entry.data[key];
    if (value == null) return '—';
    return switch (type) {
      FieldType.heirs =>
        '${toBnDigits(entry.heirs(key).length)} জন ওয়ারিশ',
      FieldType.ward => 'ওয়ার্ড ${toBnDigits(value)}',
      FieldType.number || FieldType.phone || FieldType.nid =>
        toBnDigits(value),
      FieldType.date => toBnDigits(value),
      _ => value.toString(),
    };
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.record, required this.cancelled});

  final BaseRecord record;
  final bool cancelled;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Insets.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ট্র্যাকিং নম্বর', style: text.labelSmall),
            const SizedBox(height: 2),
            SelectableText(
              toBnDigits(record.trackingNo),
              style: text.titleMedium,
            ),
            const SizedBox(height: Insets.sm),
            Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.xs,
              children: [
                ToneBadge(
                  label: cancelled
                      ? 'বাতিল'
                      : citizenLabel(record.serviceKey, record.status),
                  tone: cancelled ? Tone.danger : Tone.info,
                ),
                if (!cancelled) SlaBadge(status: slaStatus(record)),
                if (record.channel == Channel.online)
                  const ToneBadge(
                    label: 'অনলাইনে জমা',
                    tone: Tone.info,
                    icon: Icons.language,
                  ),
              ],
            ),
            const SizedBox(height: Insets.md),
            _Line(label: 'আবেদনের তারিখ', value: formatDateBn(record.createdAt)),
            if (!cancelled && record.closedAt == null)
              _Line(
                label: 'প্রত্যাশিত তারিখ',
                value: formatDateBn(record.dueAt),
              ),
            if (record.closedAt != null && !cancelled)
              _Line(
                label: 'সম্পন্ন হয়েছে',
                value: formatDateBn(record.closedAt!),
              ),
            if (record.registerNo != null)
              _Line(label: 'রেজিস্টার নং', value: toBnDigits(record.registerNo!)),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: text.bodySmall),
          Text(value, style: text.bodyMedium),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.md,
        vertical: Insets.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: text.bodySmall)),
          Expanded(
            flex: 2,
            child: Text(value, style: text.bodyMedium, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}

/// Nothing is deleted — a cancelled application keeps its reason on the page.
class _CancelledNotice extends StatelessWidget {
  const _CancelledNotice({required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.stamp.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: AppColors.stamp.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.cancel_outlined, size: 18, color: AppColors.stamp),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'আবেদনটি বাতিল করা হয়েছে',
                  style: text.titleSmall?.copyWith(color: AppColors.stamp),
                ),
                const SizedBox(height: 2),
                Text(reason, style: text.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The "pay the fee" call to action.
///
/// Offered only while the fee is genuinely outstanding: the register declares
/// which of its steps is reached by paying, so this asks the config rather
/// than assuming the payment step is second. Once that step is reached — by
/// the gateway or by the counter — there is nothing left to pay and the button
/// disappears rather than charging twice.
class _PayAction extends ConsumerStatefulWidget {
  const _PayAction({required this.entry, required this.register});

  final RegisterEntry entry;
  final RegisterConfig register;

  @override
  ConsumerState<_PayAction> createState() => _PayActionState();
}

class _PayActionState extends ConsumerState<_PayAction> {
  bool _starting = false;

  Future<void> _start() async {
    setState(() => _starting = true);
    final payment = await payForEntry(
      store: ref.read(demoStoreProvider.notifier),
      entryId: widget.entry.id,
    );
    if (!mounted) return;
    setState(() => _starting = false);
    if (payment != null) unawaited(context.push(Routes.payFor(payment.id)));
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final feeLines = entry.feeLines;
    final payStep = widget.register.steps.where((s) => s.payment).firstOrNull;

    final owed = feeLines != null &&
        feeLines.isNotEmpty &&
        payStep != null &&
        entry.receiptId == null &&
        !entry.history.any((h) => h.status == payStep.key);
    if (!owed) return const SizedBox.shrink();

    final text = Theme.of(context).textTheme;
    final total = feeLines.fold(0, (sum, l) => sum + l.amount);

    return Card(
      color: AppColors.forest50,
      child: Padding(
        padding: const EdgeInsets.all(Insets.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ফি বাকি আছে', style: text.titleSmall),
            const SizedBox(height: Insets.xs),
            Text(
              'ফি পরিশোধের পর আবেদনটি পরবর্তী ধাপে যাবে।',
              style: text.bodySmall?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: Insets.md),
            for (final line in feeLines)
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(line.label, style: text.bodyMedium)),
                    Text(formatTaka(line.amount), style: text.bodyMedium),
                  ],
                ),
              ),
            const SizedBox(height: Insets.sm),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _starting ? null : _start,
                child: Text('${formatTaka(total)} অনলাইনে পরিশোধ করুন'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
