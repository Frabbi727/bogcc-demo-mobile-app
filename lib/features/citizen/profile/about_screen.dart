import 'package:flutter/material.dart';

import '../../../shell/demo_banner.dart';
import '../../../ui/theme/colors.dart';
import '../../../ui/theme/spacing.dart';

/// What this app is, and what it is not.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('অ্যাপ সম্পর্কে')),
      body: Column(
        children: [
          const DemoBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(Insets.lg),
              children: [
                Text('বগুড়া সিটি কর্পোরেশন', style: text.headlineSmall),
                Text('ডিজিটাল সেবা ব্যবস্থা — ডেমো', style: text.bodySmall),
                const SizedBox(height: Insets.lg),

                const _Section(
                  title: 'এটি একটি ডেমো',
                  body: 'এখানে দেখানো প্রতিটি নাম, প্রতিষ্ঠান, জাতীয় পরিচয়পত্র '
                      'নম্বর ও মোবাইল নম্বর কাল্পনিক। শুধু বগুড়ার এলাকার নামগুলো '
                      'বাস্তব। কোনো প্রকৃত অর্থ লেনদেন হয় না এবং কোনো এসএমএস '
                      'পাঠানো হয় না।',
                ),
                const _Section(
                  title: 'তথ্য কোথায় থাকে',
                  body: 'সব তথ্য শুধু এই ফোনেই থাকে। অ্যাপটির ইন্টারনেট '
                      'ব্যবহারের অনুমতি নেই, তাই কোনো তথ্য বাইরে যায় না। '
                      '"ডেমো রিসেট" দিলে সব মুছে গিয়ে নতুন তথ্য তৈরি হয়।',
                ),
                const _Section(
                  title: 'নিয়ম',
                  body: 'কোনো নথি কখনো মুছে ফেলা হয় না — কারণসহ বাতিল করা হয় '
                      'এবং রেজিস্টারে দৃশ্যমান থাকে। প্রতিটি কাজের হিসাব '
                      'অডিট লগে জমা থাকে, আর রেজিস্টারের ক্রমিক নম্বর কখনো '
                      'বাদ পড়ে না।',
                ),
                const _Section(
                  title: 'ফন্ট',
                  body: 'Hind Siliguri ও Tiro Bangla — SIL Open Font License '
                      '১.১ অনুযায়ী ব্যবহৃত। লাইসেন্সের সম্পূর্ণ শর্ত অ্যাপের '
                      'সাথে সংযুক্ত (assets/fonts/OFL.txt)।',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: text.titleSmall?.copyWith(color: AppColors.forest700)),
          const SizedBox(height: Insets.xs),
          Text(body, style: text.bodyMedium),
        ],
      ),
    );
  }
}
