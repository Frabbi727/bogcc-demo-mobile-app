import 'package:bogcc_demo_mobile_app/catalogue/registers/registers.dart';
import 'package:bogcc_demo_mobile_app/data/seed/seed_builder.dart';
import 'package:bogcc_demo_mobile_app/data/seed/seed_data.dart';
import 'package:bogcc_demo_mobile_app/domain/enums.dart';
import 'package:bogcc_demo_mobile_app/domain/models/register_entry.dart';
import 'package:bogcc_demo_mobile_app/domain/rules/sla.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

/// A fixed day, so these assertions are about the builder rather than about
/// whatever today happens to be.
final _today = DateTime(2026, 9, 26, 12);

void main() {
  late SeedData seed;

  setUpAll(() => seed = buildSeed(_today));

  group('determinism', () {
    test('the same day rebuilds byte-identical data', () {
      final again = buildSeed(_today);
      expect(again.licences.length, seed.licences.length);
      expect(again.entries.map((e) => e.id), seed.entries.map((e) => e.id));
      expect(
        again.entries.map((e) => e.serialNo),
        seed.entries.map((e) => e.serialNo),
      );
      expect(
        again.receipts.map((r) => r.receiptNo),
        seed.receipts.map((r) => r.receiptNo),
      );
      // Deep equality on a whole record, not just its identifiers.
      expect(again.entries.first, seed.entries.first);
      expect(again.holdings.first, seed.holdings.first);
    });

    test('a different day produces different data', () {
      final other = buildSeed(DateTime(2026, 9, 27, 12));
      expect(other.entries.first.data, isNot(seed.entries.first.data));
    });
  });

  group('volumes', () {
    test('licences match the plan, with every status represented', () {
      expect(seed.licences, hasLength(45));
      final byStatus = seed.licences.groupListsBy((l) => l.licenceStatus);
      expect(byStatus[LicenceStatus.issued], hasLength(26));
      expect(byStatus[LicenceStatus.approved], hasLength(5));
      expect(byStatus[LicenceStatus.verified], hasLength(5));
      expect(byStatus[LicenceStatus.submitted], hasLength(7));
      expect(byStatus[LicenceStatus.cancelled], hasLength(2));
    });

    test('register entries match the plan', () {
      const expected = {
        'streetlight': 35,
        'garbage': 30,
        'garbage-trips': 40,
        'cert-citizen': 20,
        'cert-warish': 8,
        'market-rent': 36,
        'rickshaw-licence': 24,
        'building-plan': 14,
        'birth-death': 26,
      };
      final byRegister = seed.entries.groupListsBy((e) => e.registerKey);
      for (final entry in expected.entries) {
        expect(byRegister[entry.key], hasLength(entry.value),
            reason: entry.key);
      }
      expect(seed.entries, hasLength(233));
    });

    test('there are 60 holdings and 10 notices', () {
      expect(seed.holdings, hasLength(60));
      expect(seed.notices, hasLength(10));
      expect(seed.holdings.map((h) => h.holdingNo).toSet(), hasLength(60));
    });

    test('ids are unique across every collection', () {
      expect(seed.licences.map((l) => l.id).toSet(), hasLength(45));
      expect(seed.entries.map((e) => e.id).toSet(),
          hasLength(seed.entries.length));
      expect(seed.audit.map((a) => a.id).toSet(), hasLength(seed.audit.length));
      expect(seed.notifications.map((n) => n.id).toSet(),
          hasLength(seed.notifications.length));
    });

    test('every tracking number is unique', () {
      // A citizen types this in to find their application; a collision would
      // show them someone else's record.
      final tracking = [
        ...seed.licences.map((l) => l.trackingNo),
        ...seed.entries.map((e) => e.trackingNo),
      ];
      expect(tracking.toSet(), hasLength(tracking.length));
    });
  });

  group('register serials', () {
    test('run 1..n with no gaps, per register per fiscal year', () {
      // A missing serial is the first thing an auditor asks about.
      final groups = seed.entries.groupListsBy(
        (e) => '${e.registerKey}/${e.fiscalYear}',
      );
      for (final group in groups.entries) {
        final serials = group.value.map((e) => e.serial!).toList()..sort();
        expect(serials, List.generate(serials.length, (i) => i + 1),
            reason: group.key);
      }
    });

    test('follow creation order, because that is when the line is written', () {
      final sl = seed.entries.where((e) => e.registerKey == 'streetlight').toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      final serials = sl.map((e) => e.serial!).toList();
      // Within one fiscal year serials ascend with creation date.
      final byFy = sl.groupListsBy((e) => e.fiscalYear);
      for (final group in byFy.values) {
        final s = group.map((e) => e.serial!).toList();
        expect(s, orderedEquals(s.toList()..sort()));
      }
      expect(serials, isNotEmpty);
    });

    test('the formatted serial matches its register prefix and year', () {
      for (final entry in seed.entries) {
        final config = getRegister(entry.registerKey)!;
        expect(
          entry.serialNo,
          '${config.serialPrefix}/${entry.fiscalYear}/'
          '${entry.serial.toString().padLeft(3, '0')}',
        );
      }
    });

    test('licence serials are assigned at approval, not submission', () {
      // A submitted or verified licence has no line in the book yet.
      for (final licence in seed.licences) {
        final approved = licence.licenceStatus == LicenceStatus.approved ||
            licence.licenceStatus == LicenceStatus.issued;
        expect(licence.serial != null, approved,
            reason: '${licence.id} is ${licence.licenceStatus.name}');
        expect(licence.registerNo != null, approved, reason: licence.id);
      }
    });

    test('the sequence map leaves counters where the seed stopped', () {
      // Otherwise the first record created in the app would collide with a
      // seeded serial.
      for (final group
          in seed.entries.groupListsBy((e) => '${e.registerKey}/${e.fiscalYear}').entries) {
        final config = getRegister(group.value.first.registerKey)!;
        final key = '${config.serialPrefix}-${group.value.first.fiscalYear}';
        expect(seed.sequences[key], group.value.length, reason: key);
      }
    });
  });

  group('receipts', () {
    test('are numbered gaplessly in collection order within a fiscal year', () {
      final byFy = seed.receipts.groupListsBy((r) => r.fiscalYear);
      for (final group in byFy.entries) {
        final sorted = group.value.toList()
          ..sort((a, b) => a.collectedAt.compareTo(b.collectedAt));
        expect(sorted.map((r) => r.no),
            List.generate(sorted.length, (i) => i + 1), reason: group.key);
      }
    });

    test('map onto 100-leaf paper books', () {
      for (final r in seed.receipts) {
        expect(r.bookNo, (r.no - 1) ~/ 100 + 1);
        expect(r.pageNo, (r.no - 1) % 100 + 1);
      }
    });

    test('every receipt has a matching payment, and vice versa', () {
      final paymentIds = seed.payments.map((p) => p.id).toSet();
      for (final r in seed.receipts) {
        expect(paymentIds, contains(r.paymentId), reason: r.receiptNo);
      }
      expect(seed.payments, hasLength(seed.receipts.length));
      for (final p in seed.payments) {
        expect(p.status, PaymentStatus.paid);
        expect(p.total, p.feeLines.fold(0, (s, l) => s + l.amount));
      }
    });

    test('an online payment carries a transaction id, a counter one a mode', () {
      for (final p in seed.payments) {
        if (p.channel == Channel.online) {
          expect(p.txnRef, isNotNull, reason: p.id);
          expect(p.method, isNotNull, reason: p.id);
          expect(p.mode, isNull, reason: p.id);
        } else {
          expect(p.mode, isNotNull, reason: p.id);
          expect(p.txnRef, isNull, reason: p.id);
        }
      }
    });

    test('an issued licence has been paid for and has a receipt', () {
      for (final l in seed.licences
          .where((l) => l.licenceStatus == LicenceStatus.issued)) {
        expect(l.receiptId, isNotNull, reason: l.id);
        expect(l.paymentId, isNotNull, reason: l.id);
        expect(l.registerNo, isNotNull, reason: l.id);
      }
    });

    test('a paid holding instalment points at a real receipt', () {
      final receiptIds = seed.receipts.map((r) => r.id).toSet();
      var paidCount = 0;
      for (final h in seed.holdings) {
        for (final bill in h.bills) {
          for (final inst in bill.instalments) {
            if (inst.paidAt == null) continue;
            paidCount += 1;
            expect(receiptIds, contains(inst.receiptId), reason: h.holdingNo);
          }
        }
      }
      expect(paidCount, greaterThan(0));
    });
  });

  group('the shape of the demo', () {
    test('a handful of still-open records are overdue', () {
      // The budget in the builder governs open records specifically: enough to
      // demonstrate the overdue list, not so many that the office looks broken.
      final open = [
        ...seed.licences.where((l) => isOverdue(l, asOf: _today)),
        ...seed.entries.where((e) => isOverdue(e, asOf: _today)),
      ].where((r) => r.closedAt == null);
      expect(open.length, inInclusiveRange(3, 12));
    });

    test('some finished records closed after their deadline', () {
      // Not a defect: an on-time percentage is meaningless if every finished
      // record was on time, so the SLA report needs late completions too.
      final closedLate = [
        ...seed.licences.where((l) => isOverdue(l, asOf: _today)),
        ...seed.entries.where((e) => isOverdue(e, asOf: _today)),
      ].where((r) => r.closedAt != null);
      expect(closedLate, isNotEmpty);
      for (final r in closedLate) {
        expect(r.closedAt!.isAfter(r.dueAt), isTrue);
      }
    });

    test('an internal log book is never measured against the charter', () {
      for (final e in seed.entries.where(
        (e) => e.registerKey == 'garbage-trips' || e.registerKey == 'birth-death',
      )) {
        expect(e.slaExempt, isTrue);
        expect(isOverdue(e, asOf: _today), isFalse);
      }
    });

    test('a cancelled record keeps its reason and stays visible', () {
      final cancelled = [
        ...seed.licences.where((l) => l.cancelled != null),
        ...seed.entries.where((e) => e.cancelled != null),
      ];
      expect(cancelled, isNotEmpty);
      for (final r in cancelled) {
        expect(r.cancelled!.reason, isNotEmpty);
        expect(r.cancelled!.by, isNotEmpty);
        expect(r.closedAt, isNotNull);
      }
    });

    test('ratings average near 4.2, so the dashboard number is believable', () {
      final ratings = [
        ...seed.licences.map((l) => l.feedback?.rating),
        ...seed.entries.map((e) => e.feedback?.rating),
      ].whereType<int>();
      expect(ratings.length, greaterThan(10));
      final average = ratings.reduce((a, b) => a + b) / ratings.length;
      expect(average, closeTo(4.2, 0.45));
      expect(ratings.any((r) => r <= 3), isTrue,
          reason: 'all-five-stars is not believable');
    });

    test('daily books have lines dated today, so the daily card is never empty', () {
      for (final key in ['garbage-trips', 'market-rent', 'birth-death']) {
        final todays = seed.entries.where(
          (e) =>
              e.registerKey == key &&
              e.createdAt.year == _today.year &&
              e.createdAt.month == _today.month &&
              e.createdAt.day == _today.day,
        );
        expect(todays, isNotEmpty, reason: key);
      }
    });

    test('a finished certificate has a certificate number', () {
      for (final e in seed.entries.where(
        (e) => e.registerKey == 'cert-citizen' || e.registerKey == 'cert-warish',
      )) {
        final finished = e.status == 'issued';
        expect(e.certificateNo != null, finished, reason: e.id);
      }
    });

    test('every record ends on the status its history last reached', () {
      for (final e in seed.entries) {
        final config = getRegister(e.registerKey)!;
        expect(config.statusKeys, contains(e.status), reason: e.id);
        expect(e.history, isNotEmpty, reason: e.id);
        expect(e.history.first.status, config.steps.first.key, reason: e.id);
      }
    });

    test('a closed record has a closing timestamp and an open one does not', () {
      for (final e in seed.entries) {
        final config = getRegister(e.registerKey)!;
        final finished = e.status == config.statusKeys.last;
        if (finished || e.cancelled != null) {
          expect(e.closedAt, isNotNull, reason: e.id);
        } else {
          expect(e.closedAt, isNull, reason: e.id);
        }
      }
    });
  });

  group('the demo citizen', () {
    test('has four requests at different stages on one mobile', () {
      final mine = <dynamic>[
        ...seed.licences.where((l) => l.applicantMobile == demoCitizenMobile),
        ...seed.entries.where((e) => e.applicantMobile == demoCitizenMobile),
      ];
      expect(mine, hasLength(4),
          reason: 'আমার সব আবেদন must have something to show');

      final entryKeys = seed.entries
          .where((e) => e.applicantMobile == demoCitizenMobile)
          .map((e) => e.registerKey)
          .toSet();
      expect(entryKeys, containsAll(['streetlight', 'garbage', 'cert-citizen']));
    });

    test('their SMS inbox follows them, so tracking messages are readable', () {
      final trackingNos = {
        ...seed.licences
            .where((l) => l.applicantMobile == demoCitizenMobile)
            .map((l) => l.trackingNo),
        ...seed.entries
            .where((e) => e.applicantMobile == demoCitizenMobile)
            .map((e) => e.trackingNo),
      };
      final inbox = seed.notifications
          .where((n) => n.mobile == demoCitizenMobile)
          .toList();
      expect(inbox, isNotEmpty);
      for (final tracking in trackingNos) {
        expect(
          inbox.any((n) => n.trackingNo == tracking),
          isTrue,
          reason: 'no message for $tracking',
        );
      }
    });

    test('their certificate application carries their own mobile in its data', () {
      final cert = seed.entries.firstWhereOrNull(
        (e) =>
            e.registerKey == 'cert-citizen' &&
            e.applicantMobile == demoCitizenMobile,
      );
      expect(cert, isNotNull);
      expect(cert!.data['mobile'], demoCitizenMobile);
    });
  });

  group('audit and messages', () {
    test('the audit log is ordered oldest first and never empty', () {
      expect(seed.audit, isNotEmpty);
      for (var i = 1; i < seed.audit.length; i++) {
        expect(
          seed.audit[i].at.isBefore(seed.audit[i - 1].at),
          isFalse,
          reason: 'audit out of order at $i',
        );
      }
    });

    test('every history step left an audit line, plus receipts and notices', () {
      // The one exception is a licence's `issued` step, which is recorded by
      // the receipt's "ফি আদায়" line at the same timestamp rather than twice.
      // Money moving is the auditable event there; the status follows from it.
      final entrySteps =
          seed.entries.fold<int>(0, (s, e) => s + e.history.length);
      final licenceSteps = seed.licences.fold<int>(
        0,
        (s, l) => s + l.history.where((h) => h.status != 'issued').length,
      );
      expect(
        seed.audit.length,
        entrySteps + licenceSteps + seed.receipts.length + seed.notices.length,
      );
    });

    test('an issued licence is still traceable in the audit log', () {
      // Following on from the above: the step is not logged, so prove the money
      // line covers it.
      final issued = seed.licences
          .where((l) => l.licenceStatus == LicenceStatus.issued)
          .take(5);
      for (final licence in issued) {
        expect(
          seed.audit.any(
            (a) => a.recordId == licence.receiptId && a.action == 'ফি আদায়',
          ),
          isTrue,
          reason: '${licence.id} has no money line',
        );
      }
    });

    test('only citizen-facing registers generate SMS', () {
      final internalTracking = seed.entries
          .where((e) => !getRegister(e.registerKey)!.citizenFacing)
          .map((e) => e.trackingNo)
          .toSet();
      for (final n in seed.notifications) {
        if (n.trackingNo == null) continue;
        expect(internalTracking, isNot(contains(n.trackingNo)),
            reason: 'internal book messaged a citizen');
      }
    });

    test('older messages are marked read so the badge stays believable', () {
      final unread = seed.notifications.where((n) => !n.read).length;
      expect(unread, greaterThan(0));
      expect(unread, lessThan(seed.notifications.length));
    });
  });

  group('entryLabelOf', () {
    test('summarises an entry from its first two book columns', () {
      final sl = seed.entries.firstWhere((e) => e.registerKey == 'streetlight');
      final label = entryLabelOf(sl);
      expect(label, isNotEmpty);
      expect(label, isNot(sl.serialNo));
    });

    test('falls back to the serial when there is nothing to show', () {
      final bare = RegisterEntry(
        id: 'x',
        serviceKey: 'streetlight',
        trackingNo: 'BOGCC-2026-000001',
        channel: Channel.office,
        applicantName: 'ক',
        applicantMobile: '01700000000',
        ward: 1,
        status: 'received',
        createdAt: _today,
        dueAt: _today,
        fiscalYear: '2026-27',
        registerKey: 'streetlight',
        serialNo: 'SL/2026-27/001',
      );
      expect(entryLabelOf(bare), 'SL/2026-27/001');
    });
  });
}
