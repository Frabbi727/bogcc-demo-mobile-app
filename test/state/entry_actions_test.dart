import 'dart:io';

import 'package:bogcc_demo_mobile_app/app/bootstrap.dart';
import 'package:bogcc_demo_mobile_app/catalogue/registers/registers.dart';
import 'package:bogcc_demo_mobile_app/data/seed/seed_data.dart';
import 'package:bogcc_demo_mobile_app/domain/enums.dart';
import 'package:bogcc_demo_mobile_app/state/actions/entry_actions.dart';
import 'package:bogcc_demo_mobile_app/state/demo_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

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

/// Drives the notifier without a widget tree, which is all these actions need.
class _Harness extends DemoStore {
  _Harness(super.repos, super.sequences, super.initial);
  late DemoState _state = super.build();
  @override
  DemoState get state => _state;
  @override
  set state(DemoState value) => _state = value;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tmp;
  late AppServices services;
  late _Harness store;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('bogcc_actions');
    PathProviderPlatform.instance = _FakePathProvider(tmp.path);
    services = await bootstrap();
    store = _Harness(
      services.repositories,
      services.sequences,
      services.initialState,
    );
  });

  tearDown(() async {
    await Hive.close();
    if (tmp.existsSync()) await tmp.delete(recursive: true);
  });

  final config = getRegister('streetlight')!;
  const data = <String, dynamic>{
    'ward': 5,
    'road': 'সাতমাথা, সদর',
    'faultType': 'বাতি নষ্ট',
    'complainant': 'রহিমা খাতুন',
    'complainantMobile': demoCitizenMobile,
    'description': 'রাতে পুরো এলাকা অন্ধকার থাকে।',
  };

  Future<void> file() => createCitizenEntry(
        store: store,
        config: config,
        data: Map<String, dynamic>.from(data),
        applicantMobile: demoCitizenMobile,
      );

  test('filing an application creates a complete register line', () async {
    final before = store.state.entries.length;
    await file();

    expect(store.state.entries, hasLength(before + 1));
    final entry = store.state.entries.last;

    expect(entry.registerKey, 'streetlight');
    expect(entry.status, 'received', reason: 'starts at the first step');
    expect(entry.channel, Channel.online);
    expect(entry.applicantName, 'রহিমা খাতুন');
    expect(entry.applicantMobile, demoCitizenMobile);
    expect(entry.ward, 5);
    expect(entry.trackingNo, startsWith('BOGCC-'));
    expect(entry.serialNo, startsWith('SL/'));
    expect(entry.history, hasLength(1));
    expect(entry.history.single.publicNote, isTrue);
  });

  test('the serial continues the book rather than colliding with the seed',
      () async {
    // A new line reusing a seeded serial would be two records on one line.
    final existing = store.state.entries
        .where((e) => e.registerKey == 'streetlight')
        .map((e) => e.serialNo)
        .toSet();
    await file();
    final entry = store.state.entries.last;
    expect(existing, isNot(contains(entry.serialNo)));
    expect(entry.serial, greaterThan(0));
  });

  test('two applications get consecutive serials and distinct numbers',
      () async {
    await file();
    final first = store.state.entries.last;
    await file();
    final second = store.state.entries.last;

    expect(second.serial, first.serial! + 1);
    expect(second.trackingNo, isNot(first.trackingNo));
    expect(second.id, isNot(first.id));
  });

  test('the deadline comes from the charter, in working days', () async {
    await file();
    final entry = store.state.entries.last;
    // Streetlight promises three working days.
    expect(entry.dueAt.isAfter(entry.createdAt), isTrue);
    expect(entry.dueAt.difference(entry.createdAt).inDays,
        inInclusiveRange(2, 6));
  });

  test('it appends exactly one audit line and one message', () async {
    final auditBefore = store.state.audit.length;
    final smsBefore = store.state.notifications.length;
    await file();

    expect(store.state.audit, hasLength(auditBefore + 1));
    expect(store.state.notifications, hasLength(smsBefore + 1));

    final entry = store.state.entries.last;
    final sms = store.state.notifications.last;
    expect(sms.mobile, demoCitizenMobile);
    expect(sms.trackingNo, entry.trackingNo);
    expect(sms.read, isFalse);
    expect(sms.text, contains('অভিযোগ গৃহীত'));
  });

  test('it survives a restart, including the serial counter', () async {
    await file();
    final entry = store.state.entries.last;
    await Hive.close();

    final again = await bootstrap();
    final read = again.initialState.entry(entry.id);
    expect(read, isNotNull);
    expect(read!.serialNo, entry.serialNo);
    expect(read.applicantName, 'রহিমা খাতুন');

    // The counter moved with it, so the next line does not reuse the serial.
    expect(
      again.sequences.peek('SL-${entry.fiscalYear}'),
      greaterThanOrEqualTo(entry.serial!),
    );
  });

  test('nextActorTitle names the desk that acts next', () async {
    // What the citizen is told happens now: an operator assigns the technician.
    expect(nextActorTitle(config, 'received'), 'ডাটা এন্ট্রি অপারেটর');
    expect(nextActorTitle(config, 'assigned'), 'ইলেকট্রিশিয়ান');
    // Nothing follows the last step.
    expect(nextActorTitle(config, 'repaired'), isNull);
  });
}
