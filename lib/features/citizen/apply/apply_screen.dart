import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../catalogue/registers/registers.dart';
import '../../../catalogue/services.dart';
import '../../../core/bn/bn.dart';
import '../../../domain/models/register_entry.dart';
import '../../../engine/field_registry.dart';
import '../../../engine/form_state.dart';
import '../../../shell/demo_banner.dart';
import '../../../state/actions/entry_actions.dart';
import '../../../state/providers.dart';
import '../../../state/selectors/citizen_selectors.dart';
import '../../../ui/theme/colors.dart';
import '../../../ui/theme/spacing.dart';

/// The online application form.
///
/// Built entirely from the register's `citizenInput` fields, so a new register
/// becomes an application form with no screen work at all.
class ApplyScreen extends ConsumerStatefulWidget {
  const ApplyScreen({required this.serviceKey, super.key});

  final String serviceKey;

  @override
  ConsumerState<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends ConsumerState<ApplyScreen> {
  RegisterConfig? _config;
  DynamicFormState? _form;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final config = registerForService(widget.serviceKey);
    if (config == null) return;
    _config = config;
    _form = DynamicFormState(
      fields: config.citizenFields,
      // The applicant's own number is already known, so they do not retype it.
      initial: {
        if (config.applicantFields != null)
          config.applicantFields!.mobile:
              ref.read(citizenMobileProvider) ?? '',
      },
    );
  }

  @override
  void dispose() {
    _form?.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _form!;
    if (!form.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('কিছু তথ্য বাকি আছে — লাল লেখাগুলো দেখুন')),
      );
      return;
    }

    setState(() => _submitting = true);
    final entry = await createCitizenEntry(
      store: ref.read(demoStoreProvider.notifier),
      config: _config!,
      data: Map<String, dynamic>.from(form.values),
      applicantMobile: ref.read(citizenMobileProvider) ?? '',
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    await showDialog<void>(
      context: context,
      builder: (context) => _SubmittedDialog(entry: entry, config: _config!),
    );
    if (mounted) context.go(Routes.track);
  }

  @override
  Widget build(BuildContext context) {
    final service = serviceOf(widget.serviceKey);
    final config = _config;
    final form = _form;

    if (service == null || config == null || form == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('আবেদন')),
        body: const Center(child: Text('এই সেবার অনলাইন আবেদন এখন সম্ভব নয়।')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(service.name)),
      body: Column(
        children: [
          const DemoBanner(),
          Expanded(
            child: ListenableBuilder(
              listenable: form,
              builder: (context, _) => ListView(
                padding: const EdgeInsets.all(Insets.lg),
                children: [
                  _CharterReminder(service: service),
                  const SizedBox(height: Insets.lg),
                  for (final field in config.citizenFields)
                    fieldRegistry[field.type]!(
                      FieldContext(field: field, form: form),
                    ),
                  const SizedBox(height: Insets.sm),
                  FilledButton.icon(
                    onPressed: _submitting ? null : _submit,
                    icon: _submitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send_outlined),
                    label: Text(_submitting ? 'জমা হচ্ছে…' : 'আবেদন জমা দিন'),
                  ),
                  const SizedBox(height: Insets.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CharterReminder extends StatelessWidget {
  const _CharterReminder({required this.service});

  final ServiceDef service;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.forest50,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.schedule_outlined,
              size: 18, color: AppColors.forest700),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: Text(
              service.charterDays == 0
                  ? 'এই সেবা একই দিনে সম্পন্ন হয়। ফি: ${service.fee.label}'
                  : 'নির্ধারিত সময় ${toBnDigits(service.charterDays)} কার্যদিবস। '
                      'ফি: ${service.fee.label}',
              style: text.bodySmall?.copyWith(color: AppColors.forest800),
            ),
          ),
        ],
      ),
    );
  }
}

/// Confirms the application and, crucially, hands over the tracking number.
class _SubmittedDialog extends StatelessWidget {
  const _SubmittedDialog({required this.entry, required this.config});

  final RegisterEntry entry;
  final RegisterConfig config;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final nextActor = nextActorTitle(config, entry.status);

    return AlertDialog(
      icon: const Icon(Icons.check_circle_outline,
          color: AppColors.forest700, size: 36),
      title: const Text('আবেদন জমা হয়েছে'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'আপনার ট্র্যাকিং নম্বর',
            style: text.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Insets.xs),
          SelectableText(
            toBnDigits(entry.trackingNo),
            style: text.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Insets.md),
          Text(
            nextActor == null
                ? 'অগ্রগতি ট্র্যাক পাতায় দেখা যাবে।'
                : 'পরবর্তী ধাপ: $nextActor দেখবেন। অগ্রগতি ট্র্যাক পাতায় ও '
                    'বার্তায় জানানো হবে।',
            style: text.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ঠিক আছে'),
        ),
      ],
    );
  }
}
