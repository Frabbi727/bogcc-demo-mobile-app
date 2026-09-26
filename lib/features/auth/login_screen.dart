import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../catalogue/users.dart';
import '../../core/bn/bn.dart';
import '../../domain/enums.dart';
import '../../shell/demo_banner.dart';
import '../../state/session_controller.dart';
import '../../ui/theme/colors.dart';
import '../../ui/theme/spacing.dart';

/// The front door. Choose নাগরিক or অফিস, and the whole app reshapes itself.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _mobile = TextEditingController();
  bool _office = false;
  String? _error;

  @override
  void dispose() {
    _mobile.dispose();
    super.dispose();
  }

  void _continueAsCitizen() {
    final mobile = bnToEnDigits(_mobile.text).trim();
    // Bangladeshi mobile numbers are eleven digits starting 01.
    if (!RegExp(r'^01\d{9}$').hasMatch(mobile)) {
      setState(() => _error = 'এগারো সংখ্যার মোবাইল নম্বর দিন, যেমন ০১৭০০০০০০০০');
      return;
    }
    setState(() => _error = null);
    context.push('${Routes.otp}?mobile=$mobile');
  }

  Future<void> _signInAsOffice(AppRole role) async {
    await ref.read(sessionProvider.notifier).signInAsOffice(role);
    if (mounted) context.go(Routes.officeHome);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const DemoBanner(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(Insets.lg),
                children: [
                  const SizedBox(height: Insets.lg),
                  Text('বগুড়া সিটি কর্পোরেশন', style: text.headlineMedium),
                  const SizedBox(height: Insets.xs),
                  Text('ডিজিটাল সেবা ব্যবস্থা', style: text.bodySmall),
                  const SizedBox(height: Insets.xl),

                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(
                        value: false,
                        label: Text('নাগরিক'),
                        icon: Icon(Icons.person_outline),
                      ),
                      ButtonSegment(
                        value: true,
                        label: Text('অফিস'),
                        icon: Icon(Icons.badge_outlined),
                      ),
                    ],
                    selected: {_office},
                    onSelectionChanged: (s) =>
                        setState(() => _office = s.first),
                  ),
                  const SizedBox(height: Insets.xl),

                  if (_office) ..._officeSection(text) else ..._citizenSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _citizenSection() => [
        TextField(
          controller: _mobile,
          keyboardType: TextInputType.phone,
          inputFormatters: const [DigitsOnlyInputFormatter()],
          maxLength: 11,
          decoration: InputDecoration(
            labelText: 'মোবাইল নম্বর',
            hintText: '01XXXXXXXXX',
            prefixIcon: const Icon(Icons.phone_outlined),
            errorText: _error,
            counterText: '',
          ),
          onSubmitted: (_) => _continueAsCitizen(),
        ),
        const SizedBox(height: Insets.md),
        FilledButton(
          onPressed: _continueAsCitizen,
          child: const Text('ওটিপি পাঠান'),
        ),
        const SizedBox(height: Insets.lg),
        const _Hint(
          'ডেমোতে কোনো সত্যিকারের এসএমএস যায় না। পরের পাতায় ওটিপি দেখানো হবে।\n'
          'দেখার জন্য ব্যবহার করুন: ০১৭০০০০০০০০',
        ),
      ];

  List<Widget> _officeSection(TextTheme text) => [
        Text('আপনার দপ্তর বেছে নিন', style: text.titleMedium),
        const SizedBox(height: Insets.sm),
        const _Hint('ডেমোতে কোনো পাসওয়ার্ড নেই। প্রতিটি দপ্তর নিজের কাজটুকুই দেখতে পায়।'),
        const SizedBox(height: Insets.md),
        for (final role in officeRoleOrder)
          Padding(
            padding: const EdgeInsets.only(bottom: Insets.sm),
            child: _RoleCard(
              user: userFor(role),
              onTap: () => _signInAsOffice(role),
            ),
          ),
      ];
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.user, required this.onTap});

  final AppUser user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.md),
        child: Padding(
          padding: const EdgeInsets.all(Insets.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.title, style: text.titleSmall),
                    Text(
                      '${user.name} · ${user.designation}',
                      style: text.bodySmall,
                    ),
                    const SizedBox(height: Insets.xs),
                    Text(user.hint, style: text.labelSmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.forest50,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: AppColors.forest700),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.forest800),
            ),
          ),
        ],
      ),
    );
  }
}
