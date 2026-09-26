import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/bn/bn.dart';
import '../../core/random/seeded_rng.dart';
import '../../shell/demo_banner.dart';
import '../../state/session_controller.dart';
import '../../ui/theme/colors.dart';
import '../../ui/theme/spacing.dart';

/// Simulated OTP.
///
/// The app has no INTERNET permission and no SMS gateway, so the code is shown
/// on screen rather than pretending to send one. That is the honest thing to do
/// in a demo: a presenter can complete the flow in front of an audience, and
/// nobody is left waiting for a message that was never going to arrive.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({required this.mobile, super.key});

  final String mobile;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  late final String _expected = _codeFor(widget.mobile);
  final _entered = TextEditingController();
  String? _error;

  /// Derived from the number so it is stable across a rebuild, rather than
  /// regenerating every time the widget reloads mid-demo.
  static String _codeFor(String mobile) {
    final rng = SeededRng('otp-$mobile');
    return rng.int_(100000, 999999).toString();
  }

  @override
  void dispose() {
    _entered.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (bnToEnDigits(_entered.text).trim() != _expected) {
      setState(() => _error = 'ওটিপি মেলেনি। আবার চেষ্টা করুন।');
      return;
    }
    await ref.read(sessionProvider.notifier).signInAsCitizen(widget.mobile);
    if (mounted) context.go(Routes.citizenHome);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('ওটিপি যাচাই')),
      body: SafeArea(
        child: Column(
          children: [
            const DemoBanner(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(Insets.lg),
                children: [
                  Text(
                    '${toBnDigits(widget.mobile)} নম্বরে ওটিপি পাঠানো হয়েছে',
                    style: text.titleMedium,
                  ),
                  const SizedBox(height: Insets.lg),

                  Container(
                    padding: const EdgeInsets.all(Insets.lg),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(Radii.md),
                      border: Border.all(
                        color: AppColors.amber.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'ডেমো ওটিপি',
                          style: text.labelMedium
                              ?.copyWith(color: AppColors.amber),
                        ),
                        const SizedBox(height: Insets.xs),
                        Text(
                          toBnDigits(_expected),
                          style: text.displaySmall?.copyWith(
                            letterSpacing: 8,
                            color: AppColors.amber,
                          ),
                        ),
                        const SizedBox(height: Insets.xs),
                        Text(
                          'কোনো এসএমএস পাঠানো হয়নি — এটি ডেমো',
                          style: text.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Insets.xl),

                  TextField(
                    controller: _entered,
                    keyboardType: TextInputType.number,
                    inputFormatters: const [DigitsOnlyInputFormatter()],
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: text.headlineSmall?.copyWith(letterSpacing: 6),
                    decoration: InputDecoration(
                      labelText: 'ওটিপি লিখুন',
                      errorText: _error,
                      counterText: '',
                    ),
                    onSubmitted: (_) => _verify(),
                  ),
                  const SizedBox(height: Insets.md),
                  FilledButton(
                    onPressed: _verify,
                    child: const Text('প্রবেশ করুন'),
                  ),
                  const SizedBox(height: Insets.sm),
                  TextButton(
                    onPressed: () => _entered.text = _expected,
                    child: const Text('ওটিপি বসিয়ে দিন (ডেমো)'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
