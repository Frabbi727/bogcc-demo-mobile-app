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

  // MaterialIcons is in the same boat as the Bangla faces: `flutter test` does
  // not load it, so every Icon in a golden records as an empty box and no icon
  // regression can ever be caught. It lives in the SDK, which we locate from
  // the running Dart executable rather than hardcoding a path.
  final iconFont = _materialIconsFile();
  if (iconFont != null) {
    final loader = FontLoader('MaterialIcons')
      ..addFont(
        Future<ByteData>.value(
          ByteData.sublistView(await iconFont.readAsBytes()),
        ),
      );
    await loader.load();
  }

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

/// `Platform.resolvedExecutable` is `<sdk>/bin/cache/dart-sdk/bin/dart`, so the
/// material fonts sit four levels up. Returns null rather than throwing: a
/// missing icon font should not fail a test suite that does not render icons.
File? _materialIconsFile() {
  var dir = File(Platform.resolvedExecutable).parent;
  for (var i = 0; i < 8; i++) {
    final candidate = File(
      '${dir.path}/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    );
    if (candidate.existsSync()) return candidate;
    if (dir.parent.path == dir.path) break;
    dir = dir.parent;
  }
  return null;
}
