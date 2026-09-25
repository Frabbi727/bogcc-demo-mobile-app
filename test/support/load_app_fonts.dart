import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Registers the bundled Bangla faces with the test font collection.
///
/// `flutter test` does **not** load fonts declared in pubspec.yaml — it renders
/// every `Text` in a placeholder test font, where Bangla comes out as tofu
/// boxes. Any golden that is meant to prove Bangla shaping must call this first,
/// or it will happily record a rectangle of empty squares as the expected image.
Future<void> loadAppFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  const families = <String, List<String>>{
    'HindSiliguri': [
      'assets/fonts/HindSiliguri-Regular.ttf',
      'assets/fonts/HindSiliguri-Medium.ttf',
      'assets/fonts/HindSiliguri-SemiBold.ttf',
    ],
    'TiroBangla': [
      'assets/fonts/TiroBangla-Regular.ttf',
      'assets/fonts/TiroBangla-Italic.ttf',
    ],
  };

  for (final entry in families.entries) {
    final loader = FontLoader(entry.key);
    for (final path in entry.value) {
      // Read from disk rather than rootBundle: the test asset bundle is not
      // populated unless the test is run through the tool's asset pipeline.
      final bytes = await File(path).readAsBytes();
      loader.addFont(Future<ByteData>.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }
}
