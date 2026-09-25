import 'dart:io';

import 'package:bogcc_demo_mobile_app/data/local/hive_boxes.dart';
import 'package:bogcc_demo_mobile_app/data/local/json_box_store.dart';
import 'package:bogcc_demo_mobile_app/data/local/meta_store.dart';
import 'package:bogcc_demo_mobile_app/data/repositories/repositories.dart';
import 'package:bogcc_demo_mobile_app/data/repositories/sequence_service.dart';
import 'package:bogcc_demo_mobile_app/domain/enums.dart';
import 'package:bogcc_demo_mobile_app/domain/models/audit_entry.dart';
import 'package:bogcc_demo_mobile_app/domain/models/holding.dart';
import 'package:bogcc_demo_mobile_app/domain/models/messaging.dart';
import 'package:bogcc_demo_mobile_app/domain/models/money.dart';
import 'package:bogcc_demo_mobile_app/domain/models/session.dart';
import 'package:bogcc_demo_mobile_app/domain/models/shared.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() {
  late Directory tmp;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('bogcc_test');
    Hive.init(tmp.path);
    await openBoxes();
  });

  tearDown(() async {
    await Hive.close();
    if (tmp.existsSync()) await tmp.delete(recursive: true);
  });

  group('JsonBoxStore', () {
    test('a written record reads back equal after the box is reopened', () async {
      final repos = Repositories();
      final holding = Holding(
        holdingNo: 'W05-0123',
        ward: 5,
        ownerName: 'করিম',
        ownerMobile: '01700000000',
        address: 'সাতমাথা',
        area: 'সদর',
        propertyType: PropertyType.mixed,
        floors: 3,
        annualValuation: 250000,
        bills: [
          HoldingBill(
            fiscalYear: '2026-27',
            lines: const [FeeLine(label: 'কর', amount: 17500)],
            total: 17500,
            instalments: [
              const HoldingInstalment(no: 1, amount: 4375),
              HoldingInstalment(
                no: 2,
                amount: 4375,
                paidAt: DateTime(2026, 9, 1, 10),
                receiptId: 'r9',
              ),
            ],
            arrears: 2000,
            surcharge: 200,
          ),
        ],
      );
      await repos.holdings.write(holding);

      // Reopening is the real test: in memory a model compares equal to itself
      // whatever Hive did with it.
      await Hive.close();
      Hive.init(tmp.path);
      await openBoxes();

      final read = Repositories().holdings.read('W05-0123');
      expect(read, holding);
      expect(read!.bills.single.instalments[1].paidAt, DateTime(2026, 9, 1, 10));
      expect(read.bills.single.due, 17500 - 4375 + 2000 + 200);
    });

    test('readAll returns everything written', () async {
      final repos = Repositories();
      await repos.notifications.writeAll([
        for (var i = 0; i < 5; i++)
          AppNotificationFixture.make(i),
      ]);
      expect(repos.notifications.readAll(), hasLength(5));
      expect(repos.notifications.length, 5);
    });

    test('reading a missing id yields null rather than throwing', () {
      expect(Repositories().holdings.read('nope'), isNull);
    });
  });

  group('AuditRepository', () {
    test('appends and reads, and offers no way to remove a line', () async {
      final audit = Repositories().audit;
      await audit.append(
        AuditEntry(
          id: 'a1',
          at: DateTime(2026, 9, 26, 11),
          userName: 'অফিসার',
          role: AppRole.licenceOfficer,
          action: 'অনুমোদন',
          recordType: AuditRecordType.tradeLicence,
          recordKey: 'tl-new',
          recordId: 'l1',
          recordLabel: 'BOGCC/TL/2026-27/00013',
        ),
      );
      expect(audit.readAll(), hasLength(1));

      // The guarantee is structural: `delete` and `update` are not members of
      // the type, so "nothing is ever deleted" cannot be violated by accident.
      expect(audit, isNot(isA<JsonBoxStore<AuditEntry>>()));
    });
  });

  group('SequenceService', () {
    test('hands out gapless numbers', () {
      final seq = SequenceService(MetaStore(boxOf(Boxes.meta)));
      final seen = [for (var i = 0; i < 1000; i++) seq.next('SL-2026-27')];
      expect(seen.first, 1);
      expect(seen.last, 1000);
      // No gaps and no repeats: a missing register serial is the first thing an
      // auditor asks about.
      expect(seen, List.generate(1000, (i) => i + 1));
      expect(seen.toSet(), hasLength(1000));
    });

    test('counts each key independently', () {
      final seq = SequenceService(MetaStore(boxOf(Boxes.meta)));
      expect(seq.next('SL-2026-27'), 1);
      expect(seq.next('GC-2026-27'), 1);
      expect(seq.next('SL-2026-27'), 2);
      expect(seq.peek('GC-2026-27'), 1);
      // A new fiscal year restarts at 1.
      expect(seq.next('SL-2027-28'), 1);
    });

    test('persists only on flush, so no write is left in flight', () async {
      final meta = MetaStore(boxOf(Boxes.meta));
      final seq = SequenceService(meta);
      seq.next('SL-2026-27');
      expect(meta.sequences, isEmpty);
      await seq.flush();
      expect(meta.sequences['SL-2026-27'], 1);
    });

    test('resumes from what was persisted, so serials survive a restart', () async {
      final meta = MetaStore(boxOf(Boxes.meta));
      final first = SequenceService(meta);
      for (var i = 0; i < 7; i++) {
        first.next('CC-2026-27');
      }
      await first.flush();

      final second = SequenceService(meta);
      expect(second.peek('CC-2026-27'), 7);
      expect(second.next('CC-2026-27'), 8);
    });

    test('reset clears every counter', () async {
      final seq = SequenceService(MetaStore(boxOf(Boxes.meta)));
      seq.next('SL-2026-27');
      await seq.reset();
      expect(seq.peek('SL-2026-27'), 0);
    });
  });

  group('MetaStore', () {
    test('round-trips the seed marker and both sessions', () async {
      final meta = MetaStore(boxOf(Boxes.meta));
      expect(meta.seedVersion, isNull);
      expect(meta.seedDate, isNull);

      await meta.setSeedVersion(3);
      await meta.setSeedDate(DateTime(2026, 9, 26));
      expect(meta.seedVersion, 3);
      expect(meta.seedDate, DateTime(2026, 9, 26));

      await meta.setCitizenSession(
        CitizenSession(mobile: '01700000000', since: DateTime(2026, 9, 26, 9)),
      );
      expect(meta.citizenSession!.mobile, '01700000000');

      await meta.setOfficeSession(
        OfficeSession(
          role: AppRole.accounts,
          name: 'সুমন কুমার দাস',
          since: DateTime(2026, 9, 26, 9),
        ),
      );
      expect(meta.officeSession!.role, AppRole.accounts);

      await meta.clearSessions();
      expect(meta.citizenSession, isNull);
      expect(meta.officeSession, isNull);
      // Clearing sessions must not disturb the seed marker, or the next launch
      // would wipe and reseed just because someone logged out.
      expect(meta.seedVersion, 3);
    });
  });

  group('clearDataBoxes', () {
    test('empties the data but keeps meta, so the reseed can be recorded', () async {
      final meta = MetaStore(boxOf(Boxes.meta));
      await meta.setSeedVersion(3);
      await Repositories().notifications.write(AppNotificationFixture.make(1));

      await clearDataBoxes();

      expect(Repositories().notifications.readAll(), isEmpty);
      expect(meta.seedVersion, 3);
    });
  });
}

/// Small helper so the tests above stay about persistence rather than fixtures.
abstract final class AppNotificationFixture {
  static AppNotification make(int i) => AppNotification(
        id: 'n$i',
        mobile: '01700000000',
        text: 'আপনার আবেদন গৃহীত হয়েছে',
        at: DateTime(2026, 9, 26, 10, i),
      );
}
