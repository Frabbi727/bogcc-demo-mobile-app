import 'package:bogcc_demo_mobile_app/app/app.dart';
import 'package:bogcc_demo_mobile_app/shell/demo_banner.dart';
import 'package:bogcc_demo_mobile_app/ui/theme/app_theme.dart';
import 'package:bogcc_demo_mobile_app/ui/theme/colors.dart';
import 'package:bogcc_demo_mobile_app/ui/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/load_app_fonts.dart';

const _swatches = <String, Color>{
  'forest700': AppColors.forest700,
  'forest800': AppColors.forest800,
  'forest50': AppColors.forest50,
  'paper': AppColors.paper,
  'page': AppColors.page,
  'ink': AppColors.ink,
  'muted': AppColors.muted,
  'rule': AppColors.rule,
  'margin': AppColors.margin,
  'stamp': AppColors.stamp,
  'amber': AppColors.amber,
  'sky': AppColors.sky,
};

void main() {
  setUpAll(loadAppFonts);

  testWidgets('palette, type scale and demo banner', (tester) async {
    tester.view.physicalSize = const Size(400, 760);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BogccApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('বগুড়া সিটি কর্পোরেশন')),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DemoBanner(),
              Padding(
                padding: const EdgeInsets.all(Insets.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) => Text(
                        'ট্রেড লাইসেন্স রেজিস্টার',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: Insets.sm),
                    const Text('মোট আদায় ৳১,২৫,০০০ — ২১টি ওয়ার্ড'),
                    const SizedBox(height: Insets.lg),
                    Wrap(
                      spacing: Insets.sm,
                      runSpacing: Insets.sm,
                      children: [
                        for (final e in _swatches.entries)
                          Column(
                            children: [
                              Container(
                                width: 52,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: e.value,
                                  border: Border.all(color: AppColors.rule),
                                  borderRadius:
                                      BorderRadius.circular(Radii.sm),
                                ),
                              ),
                              Text(e.key,
                                  style: const TextStyle(fontSize: 9)),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: Insets.lg),
                    FilledButton(onPressed: () {}, child: const Text('আবেদন করুন')),
                    const SizedBox(height: Insets.sm),
                    OutlinedButton(onPressed: () {}, child: const Text('বাতিল')),
                    const SizedBox(height: Insets.sm),
                    const TextField(
                      decoration: InputDecoration(labelText: 'মোবাইল নম্বর'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/theme_tokens.png'),
    );
  });

  test('scaffold background is paper, not white', () {
    // The whole visual idea is a register book. A white scaffold reads as a
    // generic app and makes the ruled tables disappear.
    expect(buildAppTheme().scaffoldBackgroundColor, AppColors.paper);
  });
}
