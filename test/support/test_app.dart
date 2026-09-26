import 'dart:io';

import 'package:bogcc_demo_mobile_app/app/app.dart';
import 'package:bogcc_demo_mobile_app/app/bootstrap.dart';
import 'package:bogcc_demo_mobile_app/state/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'load_app_fonts.dart';

class _FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  _FakePathProvider(this.root);
  final String root;

  @override
  Future<String?> getApplicationDocumentsPath() async => root;
  @override
  Future<String?> getApplicationSupportPath() async => root;
  @override
  Future<String?> getTemporaryPath() async => root;
}

/// A booted app against a throwaway data directory.
///
/// Each test gets its own seeded dataset, so one test signing in or creating a
/// record cannot leak into the next.
class TestApp {
  TestApp._(this.services, this._dir);

  final AppServices services;
  final Directory _dir;

  static Future<TestApp> boot() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadAppFonts();
    final dir = await Directory.systemTemp.createTemp('bogcc_widget');
    PathProviderPlatform.instance = _FakePathProvider(dir.path);
    final services = await bootstrap();
    return TestApp._(services, dir);
  }

  Widget get app => AppProviderScope(
        services: services,
        child: const BogccApp(),
      );

  /// Hosts one screen with the app's theme and locale, without the router.
  Widget host(Widget child) => AppProviderScope(
        services: services,
        child: BogccAppHost(home: child),
      );

  Future<void> dispose() async {
    await Hive.close();
    if (_dir.existsSync()) await _dir.delete(recursive: true);
  }
}

/// Sizes the surface to a common phone so layout assertions mean something.
void usePhoneSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(400, 800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}
