import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/load_app_fonts.dart';

/// Proves the bundled Bangla faces actually shape text, rather than falling back
/// to a Latin face that renders conjuncts as tofu.
///
/// The sample is chosen to exercise the two things a Latin-only font gets wrong:
///   - conjuncts:      ক্ত  স্থ  র্ম   (two consonants fused into one glyph)
///   - vowel reorder:  কি  কে        (the vowel is typed after, drawn before)
/// Plus Bangla numerals and the taka sign, which every screen renders.
const kBanglaSample = 'ক্ত স্থ র্ম কি কে ৳১,২৫,০০০';

Widget _sample(String family) => MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Text(
        kBanglaSample,
        style: TextStyle(fontFamily: family, fontSize: 28, color: Colors.black),
      ),
    ),
  ),
);

void main() {
  setUpAll(loadAppFonts);

  testWidgets('HindSiliguri shapes conjuncts, reordered vowels and Bangla digits',
      (tester) async {
    await tester.pumpWidget(_sample('HindSiliguri'));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/hind_siliguri_sample.png'),
    );
  });

  testWidgets('TiroBangla shapes conjuncts, reordered vowels and Bangla digits',
      (tester) async {
    await tester.pumpWidget(_sample('TiroBangla'));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/tiro_bangla_sample.png'),
    );
  });

  testWidgets('the two faces render differently, so the family is really applied',
      (tester) async {
    // A font name that does not exist falls back to the default face. If the
    // bundled families were not loading, all three renders would be identical
    // and this guard would fail.
    await tester.pumpWidget(_sample('HindSiliguri'));
    final hind = tester.renderObject(find.byType(RichText)).paintBounds;
    await tester.pumpWidget(_sample('TiroBangla'));
    final tiro = tester.renderObject(find.byType(RichText)).paintBounds;
    expect(hind, isNot(equals(tiro)));
  });
}
