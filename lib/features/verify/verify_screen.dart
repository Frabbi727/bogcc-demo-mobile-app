/// Public licence and certificate check.
///
/// Ported from the web's `src/pages/Verify.tsx`. Three ways in: type the number
/// off the paper, scan the QR with the camera, or open the link a QR carries
/// from outside the app. All three end up at the same verdict logic in
/// `domain/rules/verification.dart` — this screen only collects the input and
/// draws the answer.
///
/// Reachable with no session, because the person checking a certificate is
/// usually not the person it belongs to.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/bn/bn.dart';
import '../../domain/rules/verification.dart';
import '../../shell/demo_banner.dart';
import '../../state/providers.dart';
import '../../ui/theme/colors.dart';
import '../../ui/theme/spacing.dart';

class VerifyScreen extends ConsumerStatefulWidget {
  const VerifyScreen({this.scanned, super.key});

  /// The URL a scanned QR carried, when the screen was opened that way.
  final Uri? scanned;

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  final _controller = TextEditingController();

  /// Read once, so a rebuild cannot flip the verdict while it is on screen.
  final _checkedAt = DateTime.now();

  /// The number last submitted by hand, if any.
  String? _lookedUp;

  /// The verify URL currently in play, whether it arrived as the route's own
  /// query string or off the camera. Held in state rather than read from the
  /// widget so a scan mid-session replaces an earlier one.
  Uri? _qr;

  @override
  void initState() {
    super.initState();
    _qr = widget.scanned;
    final fromQr = _qr?.queryParameters['ln'];
    if (fromQr != null) _controller.text = fromQr;
  }

  /// Takes what the camera read. What it means is decided by
  /// [readScannedCode], not here.
  void _accept(String raw) {
    final code = readScannedCode(raw);
    if (code == null) return;

    setState(() {
      _qr = code.verifyUrl;
      // One of ours can fall back on its own query string; anything else is
      // only a number, so it goes down the typed path.
      _lookedUp = code.isOurs ? null : code.number;
      _controller.text = code.number;
    });
  }

  Future<void> _scan() async {
    final raw = await context.push<String>(Routes.scan);
    if (raw != null && raw.isNotEmpty && mounted) _accept(raw);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(demoStoreProvider);
    final text = Theme.of(context).textTheme;

    final wanted = _lookedUp ?? _qr?.queryParameters['ln'];

    VerificationSubject? subject;
    if (wanted != null && wanted.trim().isNotEmpty) {
      final record = findVerifiable(
        licences: state.licences,
        entries: state.entries,
        wanted: wanted,
      );
      // The record wins: only it knows about a cancellation that happened
      // after the paper was printed.
      final qr = _qr;
      subject = subjectFromRecord(record) ??
          (_lookedUp == null && qr != null ? subjectFromQr(qr) : null);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('লাইসেন্স ও সনদ যাচাই')),
      backgroundColor: AppColors.paper,
      body: Column(
        children: [
          const DemoBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(Insets.lg),
              children: [
                Text(
                  'বগুড়া সিটি কর্পোরেশন',
                  style: text.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Insets.lg),

                TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (v) => setState(() {
                    _lookedUp = v;
                    _qr = null;
                  }),
                  decoration: const InputDecoration(
                    labelText: 'লাইসেন্স বা সনদ নম্বর',
                    hintText: 'যেমন CC/2026-27/007',
                    helperText: 'কাগজের উপরে লেখা নম্বরটি লিখুন।',
                  ),
                ),
                const SizedBox(height: Insets.md),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => setState(() {
                          _lookedUp = _controller.text;
                          // A typed number outranks whatever was scanned
                          // before it, record or not.
                          _qr = null;
                        }),
                        icon: const Icon(Icons.search, size: 18),
                        label: const Text('যাচাই করুন'),
                      ),
                    ),
                    const SizedBox(width: Insets.sm),
                    OutlinedButton.icon(
                      onPressed: () => unawaited(_scan()),
                      icon: const Icon(Icons.qr_code_scanner, size: 18),
                      label: const Text('স্ক্যান'),
                    ),
                  ],
                ),

                const SizedBox(height: Insets.xl),
                if (wanted != null && wanted.trim().isNotEmpty)
                  subject == null
                      ? _NotFound(wanted: wanted)
                      : _Result(subject: subject, checkedAt: _checkedAt),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.wanted});

  final String wanted;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          children: [
            const Icon(Icons.help_outline, size: 28, color: AppColors.muted),
            const SizedBox(height: Insets.sm),
            Text('এই নম্বরে কোনো রেকর্ড পাওয়া যায়নি', style: text.titleSmall),
            const SizedBox(height: Insets.xs),
            Text(
              'নম্বরটি আবার দেখে নিন। খুঁজেছি: ${toBnDigits(wanted.trim())}',
              style: text.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({required this.subject, required this.checkedAt});

  final VerificationSubject subject;
  final DateTime checkedAt;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final verdict = subject.verdictAt(checkedAt);

    final (color, icon) = switch (verdict) {
      Verdict.valid => (AppColors.forest700, Icons.verified_outlined),
      Verdict.expired => (AppColors.amber, Icons.error_outline),
      Verdict.cancelled => (AppColors.stamp, Icons.block),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            border: Border.all(color: color.withValues(alpha: 0.35)),
            borderRadius: BorderRadius.circular(Radii.md),
          ),
          child: Column(
            children: [
              Icon(icon, size: 34, color: color),
              const SizedBox(height: Insets.sm),
              Text(
                verdictLabel(verdict, subject.kind),
                style: text.titleMedium?.copyWith(color: color),
              ),
              if (_detail != null) ...[
                const SizedBox(height: Insets.xs),
                Text(
                  _detail!,
                  style: text.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: Insets.lg),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(Insets.md),
            child: Column(
              children: [
                _Row(label: 'নম্বর', value: toBnDigits(subject.no)),
                _Row(label: 'বিষয়', value: subject.title),
                if (subject.ownerName != null)
                  _Row(label: 'নামে ইস্যুকৃত', value: subject.ownerName!),
                if (subject.ward != null)
                  _Row(label: 'ওয়ার্ড', value: toBnDigits(subject.ward!)),
              ],
            ),
          ),
        ),

        if (subject.cancellation != null) ...[
          const SizedBox(height: Insets.md),
          Card(
            color: AppColors.stamp.withValues(alpha: 0.06),
            child: Padding(
              padding: const EdgeInsets.all(Insets.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('বাতিলের কারণ', style: text.labelSmall),
                  const SizedBox(height: 2),
                  Text(subject.cancellation!.reason, style: text.bodyMedium),
                ],
              ),
            ),
          ),
        ],

        if (!subject.fromRecord) ...[
          const SizedBox(height: Insets.md),
          Text(
            'এই তথ্য কিউআর কোড থেকে পড়া হয়েছে; এই ডিভাইসে রেকর্ডটি নেই। '
            'ইস্যুর পরে বাতিল হয়ে থাকলে তা এখানে দেখা যাবে না।',
            style: text.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  String? get _detail {
    if (subject.cancellation != null) {
      return '${formatDateBn(subject.cancellation!.at)} তারিখে বাতিল';
    }
    if (subject.kind == DocumentKind.certificate) {
      return subject.issuedOn == null
          ? null
          : 'ইস্যুর তারিখ ${formatDateBn(subject.issuedOn!)}';
    }
    return subject.validUntil == null
        ? null
        : 'মেয়াদ ${formatDateBn(subject.validUntil!)} পর্যন্ত';
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: text.labelSmall),
          ),
          Expanded(child: Text(value, style: text.bodyMedium)),
        ],
      ),
    );
  }
}
