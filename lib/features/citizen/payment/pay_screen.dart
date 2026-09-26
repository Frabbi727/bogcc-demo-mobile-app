/// The mock payment gateway.
///
/// Ported from the web demo's `src/pages/payments/Pay.tsx`. Deliberately looks
/// like a checkout and is deliberately fake: no money moves, and the page says
/// so twice.
///
/// It owns no payment logic of its own. [completePayment] is the single door
/// into the settlement that creates a receipt, which is what keeps the receipt
/// book gapless no matter which channel the money came through.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/bn/bn.dart';
import '../../../domain/enums.dart';
import '../../../domain/models/money.dart';
import '../../../shell/demo_banner.dart';
import '../../../state/actions/payment_actions.dart';
import '../../../state/providers.dart';
import '../../../ui/theme/colors.dart';
import '../../../ui/theme/spacing.dart';

enum _Stage { form, processing, settled, failed }

class PayScreen extends ConsumerStatefulWidget {
  const PayScreen({required this.paymentId, super.key});

  final String paymentId;

  @override
  ConsumerState<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends ConsumerState<PayScreen> {
  final _mobile = TextEditingController();
  final _pin = TextEditingController();

  OnlineMethod _method = OnlineMethod.bkash;
  String? _mobileError;
  String? _pinError;

  /// Lets the presenter show the failure path on purpose.
  bool _forceFail = false;

  _Stage _stage = _Stage.form;
  String? _receiptId;
  bool _prefilled = false;

  @override
  void dispose() {
    _mobile.dispose();
    _pin.dispose();
    super.dispose();
  }

  bool _validate() {
    final mobile = bnToEnDigits(_mobile.text).replaceAll(RegExp(r'\D'), '');
    final pin = bnToEnDigits(_pin.text).replaceAll(RegExp(r'\D'), '');
    setState(() {
      _mobileError = mobile.length == 11 ? null : '১১ সংখ্যার মোবাইল নম্বর দিন।';
      _pinError =
          pin.length >= 4 && pin.length <= 5 ? null : '৪ বা ৫ সংখ্যার পিন দিন।';
    });
    return _mobileError == null && _pinError == null;
  }

  Future<void> _submit(Payment payment) async {
    if (!_validate()) return;
    setState(() => _stage = _Stage.processing);

    // A short pause so the demo reads like a real gateway hand-off.
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final store = ref.read(demoStoreProvider.notifier);

    if (_forceFail) {
      await failPayment(store: store, paymentId: payment.id);
      if (!mounted) return;
      setState(() => _stage = _Stage.failed);
      return;
    }

    final receipt = await completePayment(
      store: store,
      paymentId: payment.id,
      method: _method,
    );
    if (!mounted) return;

    if (receipt == null) {
      setState(() => _stage = _Stage.failed);
      return;
    }
    setState(() {
      _receiptId = receipt.id;
      _stage = _Stage.settled;
    });
  }

  void _retry() {
    _pin.clear();
    setState(() {
      _forceFail = false;
      _pinError = null;
      _stage = _Stage.form;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(demoStoreProvider);
    final payment = state.payment(widget.paymentId);

    if (payment == null) {
      return _Shell(child: _NotFound());
    }

    if (!_prefilled) {
      _mobile.text = toBnDigits(payment.payerMobile);
      _prefilled = true;
    }

    // A payment settled earlier — a reopened link, or a second visit. The
    // receipt id is on the payment itself, because settlement puts it there;
    // there is no second place to look and so no way for the two to disagree.
    final settledReceiptId = payment.status == PaymentStatus.paid
        ? payment.receiptId ?? _receiptId
        : null;

    return _Shell(
      child: switch (settledReceiptId) {
        final String id => _Settled(receiptId: id),
        _ => switch (_stage) {
            _Stage.processing => const _Processing(),
            _Stage.failed => _Failed(onRetry: _retry),
            _ => _Form(
                payment: payment,
                method: _method,
                onMethod: (m) => setState(() => _method = m),
                mobile: _mobile,
                pin: _pin,
                mobileError: _mobileError,
                pinError: _pinError,
                forceFail: _forceFail,
                onForceFail: (v) => setState(() => _forceFail = v),
                onSubmit: () => _submit(payment),
              ),
          },
      },
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('অনলাইন পেমেন্ট')),
      body: Column(
        children: [
          const DemoBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(Insets.lg),
              children: [child],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          children: [
            const Icon(Icons.error_outline,
                size: 28, color: AppColors.muted),
            const SizedBox(height: Insets.sm),
            Text('এই পেমেন্টের তথ্য পাওয়া যায়নি।', style: text.bodyLarge),
            const SizedBox(height: Insets.xs),
            Text(
              'ডেমো রিসেট করা হলে আগের পেমেন্টের লিংক আর কাজ করে না। '
              'আবার আবেদনের পাতা থেকে পরিশোধ শুরু করুন।',
              style: text.bodySmall?.copyWith(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({
    required this.payment,
    required this.method,
    required this.onMethod,
    required this.mobile,
    required this.pin,
    required this.mobileError,
    required this.pinError,
    required this.forceFail,
    required this.onForceFail,
    required this.onSubmit,
  });

  final Payment payment;
  final OnlineMethod method;
  final ValueChanged<OnlineMethod> onMethod;
  final TextEditingController mobile;
  final TextEditingController pin;
  final String? mobileError;
  final String? pinError;
  final bool forceFail;
  final ValueChanged<bool> onForceFail;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(Insets.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('যে কারণে পরিশোধ', style: text.labelSmall),
                    const SizedBox(height: 2),
                    Text(payment.purpose, style: text.bodyLarge),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(Insets.md),
                child: Column(
                  children: [
                    for (final line in payment.feeLines)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Insets.xs),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(line.label, style: text.bodyMedium),
                            ),
                            Text(formatTaka(line.amount),
                                style: text.bodyMedium),
                          ],
                        ),
                      ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('মোট', style: text.titleSmall),
                        Text(formatTaka(payment.total), style: text.titleMedium),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Insets.lg),

        Text('পেমেন্ট মাধ্যম', style: text.titleSmall),
        const SizedBox(height: Insets.sm),
        // Neutral labels only. Using the real wallets' logos or colours is not
        // allowed — this is a demo and must not imply a real integration.
        Wrap(
          spacing: Insets.sm,
          children: [
            for (final m in OnlineMethod.values)
              ChoiceChip(
                label: Text(m.label),
                selected: method == m,
                onSelected: (_) => onMethod(m),
              ),
          ],
        ),
        const SizedBox(height: Insets.lg),

        TextField(
          controller: mobile,
          keyboardType: TextInputType.phone,
          inputFormatters: const [BanglaDigitInputFormatter()],
          decoration: InputDecoration(
            labelText: 'মোবাইল নম্বর',
            errorText: mobileError,
          ),
        ),
        const SizedBox(height: Insets.md),
        TextField(
          controller: pin,
          obscureText: true,
          keyboardType: TextInputType.number,
          inputFormatters: const [BanglaDigitInputFormatter()],
          decoration: InputDecoration(
            labelText: 'পিন',
            helperText: 'যেকোনো ৪-৫ সংখ্যা দিন — এটি ডেমো, কোনো পিন যাচাই হয় না।',
            helperMaxLines: 2,
            errorText: pinError,
          ),
        ),
        const SizedBox(height: Insets.md),

        SwitchListTile(
          value: forceFail,
          onChanged: onForceFail,
          contentPadding: EdgeInsets.zero,
          title: Text('ব্যর্থ পেমেন্ট দেখান', style: text.bodyMedium),
          subtitle: Text(
            'ডেমোতে ব্যর্থ হওয়ার পথটি দেখানোর জন্য।',
            style: text.bodySmall?.copyWith(color: AppColors.muted),
          ),
        ),
        const SizedBox(height: Insets.md),

        FilledButton.icon(
          onPressed: onSubmit,
          icon: const Icon(Icons.lock_outline, size: 18),
          label: Text('${formatTaka(payment.total)} পরিশোধ করুন'),
        ),
        const SizedBox(height: Insets.md),
        Text(
          'এটি একটি ডেমো গেটওয়ে। কোনো প্রকৃত অর্থ লেনদেন হয় না এবং কোনো '
          'ব্যাংক বা মোবাইল ব্যাংকিং সেবার সঙ্গে এর সংযোগ নেই।',
          style: text.bodySmall?.copyWith(color: AppColors.muted),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _Processing extends StatelessWidget {
  const _Processing();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.xxl),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: Insets.lg),
          Text('পেমেন্ট প্রক্রিয়াধীন…', style: text.bodyLarge),
          const SizedBox(height: Insets.xs),
          Text(
            'অনুগ্রহ করে অপেক্ষা করুন, পাতা বন্ধ করবেন না।',
            style: text.bodySmall?.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        const SizedBox(height: Insets.xl),
        const Icon(Icons.cancel_outlined, size: 40, color: AppColors.stamp),
        const SizedBox(height: Insets.md),
        Text('পেমেন্ট ব্যর্থ হয়েছে', style: text.titleMedium),
        const SizedBox(height: Insets.xs),
        Text(
          'আপনার আবেদনের কোনো পরিবর্তন হয়নি। আবার চেষ্টা করতে পারেন।',
          style: text.bodyMedium?.copyWith(color: AppColors.muted),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Insets.xl),
        FilledButton(onPressed: onRetry, child: const Text('আবার চেষ্টা করুন')),
      ],
    );
  }
}

class _Settled extends StatelessWidget {
  const _Settled({required this.receiptId});
  final String receiptId;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        const SizedBox(height: Insets.xl),
        const Icon(Icons.verified_outlined,
            size: 40, color: AppColors.forest700),
        const SizedBox(height: Insets.md),
        Text('পরিশোধ সম্পন্ন', style: text.titleMedium),
        const SizedBox(height: Insets.xs),
        Text(
          'রসিদ তৈরি হয়েছে এবং আপনার মোবাইলে বার্তা পাঠানো হয়েছে।',
          style: text.bodyMedium?.copyWith(color: AppColors.muted),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Insets.xl),
        FilledButton.icon(
          onPressed: () => context.push(Routes.receiptFor(receiptId)),
          icon: const Icon(Icons.receipt_long_outlined, size: 18),
          label: const Text('রসিদ দেখুন'),
        ),
        const SizedBox(height: Insets.sm),
        TextButton(
          onPressed: () => context.go(Routes.track),
          child: const Text('আমার আবেদনে ফিরে যান'),
        ),
      ],
    );
  }
}
