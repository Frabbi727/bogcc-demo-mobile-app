import 'dart:io';

import 'package:bogcc_demo_mobile_app/app/bootstrap.dart';
import 'package:bogcc_demo_mobile_app/data/seed/seed_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// path_provider has no implementation under `flutter test`, so bootstrap's
/// call for the documents directory has to be answered here.
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tmp;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('bogcc_boot');
    PathProviderPlatform.instance = _FakePathProvider(tmp.path);
  });

  tearDown(() async {
    await Hive.close();
    if (tmp.existsSync()) await tmp.delete(recursive: true);
  });

  test('a fresh install seeds once and loads the data', () async {
    final services = await bootstrap();

    expect(services.seeded, isTrue);
    expect(services.meta.seedVersion, kSeedVersion);
    expect(services.meta.seedDate, isNotNull);
    expect(services.initialState.licences, hasLength(45));
    expect(services.initialState.entries, hasLength(233));
    expect(services.initialState.holdings, hasLength(60));
    expect(services.initialState.notices, hasLength(10));
    expect(services.initialState.audit, isNotEmpty);

    // Counters continue from the seed rather than colliding with it.
    expect(services.sequences.peek('SL-${_fyOfNow()}'), greaterThan(0));
  });

  test('a second launch reuses the data instead of reseeding', () async {
    final first = await bootstrap();
    final firstDate = first.meta.seedDate;
    final firstTracking = first.initialState.entries.first.trackingNo;
    await Hive.close();

    final second = await bootstrap();

    expect(second.seeded, isFalse,
        reason: 'reseeding every launch would lose whatever the user did');
    expect(second.meta.seedDate, firstDate);
    expect(second.initialState.entries.first.trackingNo, firstTracking);
    expect(second.initialState.entries, hasLength(233));
  });

  test('a user-created record survives a relaunch', () async {
    final services = await bootstrap();
    final entry = services.initialState.entries.first
        .copyWith(status: 'assigned', applicantName: 'পরিবর্তিত নাম');
    await services.repositories.entries.write(entry);
    await Hive.close();

    final again = await bootstrap();
    final read = again.initialState.entry(entry.id)!;
    expect(read.applicantName, 'পরিবর্তিত নাম');
    expect(read.status, 'assigned');
  });

  test('a seed version bump wipes and rebuilds', () async {
    final first = await bootstrap();
    await first.repositories.entries.write(
      first.initialState.entries.first.copyWith(applicantName: 'পুরোনো'),
    );
    // Simulate the next release changing the data shape.
    await first.meta.setSeedVersion(kSeedVersion - 1);
    await Hive.close();

    final second = await bootstrap();
    expect(second.seeded, isTrue);
    expect(second.meta.seedVersion, kSeedVersion);
    expect(
      second.initialState.entries.any((e) => e.applicantName == 'পুরোনো'),
      isFalse,
    );
  });

  test('ডেমো রিসেট rebuilds the data and signs everyone out', () async {
    final services = await bootstrap();
    await services.repositories.entries.write(
      services.initialState.entries.first.copyWith(applicantName: 'মুছে যাবে'),
    );

    final state = await resetDemo(services);

    expect(state.entries, hasLength(233));
    expect(state.entries.any((e) => e.applicantName == 'মুছে যাবে'), isFalse);
    expect(services.meta.citizenSession, isNull);
    expect(services.meta.officeSession, isNull);
    expect(services.meta.seedVersion, kSeedVersion);
  });

  test('the store can find a record by the number a citizen was given', () async {
    final services = await bootstrap();
    final state = services.initialState;
    final tracking = state.entries.first.trackingNo;

    expect(state.byTrackingNo(tracking), isNotNull);
    // Citizens paste it in lower case or with stray spaces.
    expect(state.byTrackingNo('  ${tracking.toLowerCase()}  '), isNotNull);
    expect(state.byTrackingNo('BOGCC-2026-999999'), isNull);
  });
}

String _fyOfNow() {
  final now = DateTime.now();
  final start = now.month >= 7 ? now.year : now.year - 1;
  return '$start-${((start + 1) % 100).toString().padLeft(2, '0')}';
}
