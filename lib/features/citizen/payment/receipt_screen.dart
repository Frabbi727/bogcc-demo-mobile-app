/// A money receipt, as one leaf of the counter's receipt book.
///
/// Public, outside both shells: a receipt is a document, and the person
/// holding it is not always the person signed in — the same reason `/verify`
/// and `/document` sit outside.
///
/// The layout deliberately reads as a book leaf rather than an app screen. The
/// book and page numbers are shown because that is what an auditor asks for
/// first, and a receipt number with no leaf behind it is not a receipt.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/bn/bn.dart';
import '../../../domain/enums.dart';
import '../../../domain/models/money.dart';
import '../../../shell/demo_banner.dart';
import '../../../state/providers.dart';
import '../../../ui/theme/colors.dart';
import '../../../ui/theme/spacing.dart';

class ReceiptScreen extends ConsumerWidget {
  const ReceiptScreen({required this.receiptId, super.key});

  final String receiptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipt = ref.watch(demoStoreProvider).receipt(receiptId);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('রসিদ')),
      body: Column(
        children: [
          const DemoBanner(),
          Expanded(
            child: receipt == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(Insets.xl),
                      child: Text(
                        'রসিদটি পাওয়া যায়নি। ডেমো রিসেট করা হলে আগের রসিদের '
                        'লিংক আর কাজ করে না।',
                        style: text.bodyMedium?.copyWith(
                          color: AppColors.muted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(Insets.lg),
                    children: [_Leaf(receipt: receipt)],
                  ),
          ),
        ],
      ),
    );
  }
}

class _Leaf extends StatelessWidget {
  const _Leaf({required this.receipt});

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.page,
        border: Border.all(color: AppColors.rule),
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              children: [
                Text(
                  'বগুড়া সিটি কর্পোরেশন',
                  style: text.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  'অর্থ আদায়ের রসিদ',
                  style: text.bodySmall?.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: Insets.md),
                SelectableText(
                  toBnDigits(receipt.receiptNo),
                  style: text.titleLarge?.copyWith(
                    color: AppColors.forest700,
                  ),
                ),
                const SizedBox(height: Insets.xs),
                Text(
                  'বই নং ${toBnDigits(receipt.bookNo)}, '
                  'পাতা ${toBnDigits(receipt.pageNo)}',
                  style: text.bodySmall?.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(Insets.md),
            child: Column(
              children: [
                _Row(label: 'পরিশোধকারী', value: receipt.payerName),
                _Row(label: 'খাত', value: receipt.head.label),
                _Row(label: 'বিবরণ', value: receipt.purpose),
                _Row(
                  label: 'অর্থবছর',
                  value: toBnDigits(receipt.fiscalYear),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(Insets.md),
            child: Column(
              children: [
                for (final line in receipt.feeLines)
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
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('সর্বমোট', style: text.titleSmall),
                    Text(formatTaka(receipt.total), style: text.titleMedium),
                  ],
                ),
                const SizedBox(height: Insets.xs),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'কথায়: ${amountInWords(receipt.total)}',
                    style: text.bodySmall?.copyWith(color: AppColors.muted),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(Insets.md),
            child: Column(
              children: [
                _Row(
                  label: 'মাধ্যম',
                  value: receipt.channel == Channel.online
                      ? 'অনলাইন — ${receipt.method?.label ?? '—'}'
                      : 'কাউন্টার — ${receipt.mode?.label ?? '—'}',
                ),
                if (receipt.txnRef != null)
                  _Row(
                    label: 'ট্রানজেকশন নং',
                    // Left in Latin digits: this is read back over the phone
                    // and typed into a search box, like a tracking number.
                    value: receipt.txnRef!,
                  ),
                _Row(label: 'আদায়কারী', value: receipt.collectedBy),
                _Row(
                  label: 'সময়',
                  value: formatDateTimeBn(receipt.collectedAt),
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Insets.md),
            decoration: const BoxDecoration(
              color: AppColors.forest50,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(Radii.md),
              ),
            ),
            child: Text(
              'এটি একটি ডেমো রসিদ। কোনো প্রকৃত অর্থ লেনদেন হয়নি।',
              style: text.bodySmall?.copyWith(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
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
            child: Text(
              label,
              style: text.bodySmall?.copyWith(color: AppColors.muted),
            ),
          ),
          Expanded(child: Text(value, style: text.bodyMedium)),
        ],
      ),
    );
  }
}
