import 'package:bogcc_demo_mobile_app/domain/enums.dart';
import 'package:bogcc_demo_mobile_app/domain/rules/fiscal.dart';
import 'package:bogcc_demo_mobile_app/domain/rules/ids.dart';
import 'package:bogcc_demo_mobile_app/domain/rules/sla.dart';
import 'package:bogcc_demo_mobile_app/domain/rules/status.dart';
import 'package:flutter_test/flutter_test.dart';

/// A stand-in for any record the SLA helpers measure.
class _Subject implements SlaSubject {
  _Subject(this.dueAt, {this.closedAt, this.cancelledAt, this.slaExempt = false});
  @override
  final DateTime dueAt;
  @override
  final DateTime? closedAt;
  @override
  final DateTime? cancelledAt;
  @override
  final bool slaExempt;
}

/// Expected values below were produced by running the web demo's own
/// src/lib/{sla,fiscal,ids}.ts. A failure here means the port has drifted.
void main() {
  group('working week', () {
    test('Friday and Saturday are the weekend', () {
      expect(isWeekend(DateTime(2026, 9, 25)), isTrue); // Friday
      expect(isWeekend(DateTime(2026, 9, 26)), isTrue); // Saturday
      expect(isWeekend(DateTime(2026, 9, 27)), isFalse); // Sunday is a work day
      expect(isWeekend(DateTime(2026, 9, 24)), isFalse); // Thursday
    });

    test('dueDate skips the weekend', () {
      // Filed Saturday, 3 working days: Sun, Mon, Tue -> 29 Sep.
      expect(dueDate(DateTime(2026, 9, 26, 10), 3),
          DateTime(2026, 9, 29, 23, 59, 59));
    });

    test('dueDate crosses a month boundary', () {
      expect(dueDate(DateTime(2026, 9, 24, 10), 7),
          DateTime(2026, 10, 5, 23, 59, 59));
      expect(dueDate(DateTime(2026, 10, 28, 10), 5),
          DateTime(2026, 11, 4, 23, 59, 59));
    });

    test('a same-day service is due at end of the day it was filed', () {
      expect(dueDate(DateTime(2026, 9, 26, 10), 0),
          DateTime(2026, 9, 26, 23, 59, 59));
    });

    test('workingDaysBetween ignores the weekend and signs the direction', () {
      expect(workingDaysBetween(DateTime(2026, 9, 24), DateTime(2026, 10, 1)), 5);
      expect(workingDaysBetween(DateTime(2026, 10, 1), DateTime(2026, 9, 24)), -5);
      expect(workingDaysBetween(DateTime(2026, 9, 24), DateTime(2026, 9, 24)), 0);
    });
  });

  group('SLA status', () {
    final asOf = DateTime(2026, 9, 26, 12);

    test('an open record past its deadline is overdue', () {
      final r = _Subject(DateTime(2026, 9, 20, 23, 59, 59));
      expect(isOverdue(r, asOf: asOf), isTrue);
      expect(slaStatus(r, asOf: asOf), SlaStatus.overdue);
    });

    test('a record closed after its deadline stays overdue in the report', () {
      // Closing late does not make it on time — that is the whole point of
      // measuring against the charter.
      final r = _Subject(DateTime(2026, 9, 20, 23, 59, 59),
          closedAt: DateTime(2026, 9, 24));
      expect(isOverdue(r, asOf: asOf), isTrue);
      expect(daysOverdue(r, asOf: asOf), greaterThanOrEqualTo(1));
    });

    test('a record closed before its deadline is on time', () {
      final r = _Subject(DateTime(2026, 9, 30, 23, 59, 59),
          closedAt: DateTime(2026, 9, 24));
      expect(slaStatus(r, asOf: asOf), SlaStatus.onTime);
      expect(daysOverdue(r, asOf: asOf), 0);
    });

    test('a cancelled record is never overdue, because nobody is waiting', () {
      final r = _Subject(DateTime(2026, 9, 1), cancelledAt: DateTime(2026, 9, 5));
      expect(isOverdue(r, asOf: asOf), isFalse);
      expect(slaStatus(r, asOf: asOf), SlaStatus.onTime);
    });

    test('an exempt record is never measured', () {
      // The daily trip log promises a citizen nothing.
      final r = _Subject(DateTime(2026, 9, 1), slaExempt: true);
      expect(slaStatus(r, asOf: asOf), SlaStatus.onTime);
      expect(daysOverdue(r, asOf: asOf), 0);
    });

    test('one working day or less left reads as due soon', () {
      final r = _Subject(DateTime(2026, 9, 27, 23, 59, 59));
      expect(slaStatus(r, asOf: asOf), SlaStatus.dueSoon);
      final far = _Subject(DateTime(2026, 10, 15, 23, 59, 59));
      expect(slaStatus(far, asOf: asOf), SlaStatus.onTime);
    });
  });

  group('fiscal year', () {
    test('runs July to June', () {
      expect(fiscalYearOf(DateTime(2026, 6, 30)), '2025-26');
      expect(fiscalYearOf(DateTime(2026, 7, 1)), '2026-27');
      expect(fiscalYearOf(DateTime(2026, 12, 31)), '2026-27');
      expect(fiscalYearOf(DateTime(2027, 1, 1)), '2026-27');
    });

    test('a licence is valid until 30 June whatever month it was issued', () {
      expect(validUntil('2026-27'), DateTime(2027, 6, 30));
      expect(fiscalYearStart('2026-27'), DateTime(2026, 7, 1));
    });

    test('options descend from the current year', () {
      final options = fiscalYearOptions(count: 3);
      expect(options, hasLength(3));
      expect(options.first, currentFiscalYear());
      expect(int.parse(options[1].substring(0, 4)),
          int.parse(options[0].substring(0, 4)) - 1);
    });
  });

  group('identifiers', () {
    test('match the shapes printed on documents', () {
      expect(trackingNo(2026, 123), 'BOGCC-2026-000123');
      expect(licenceNo('2026-27', 13), 'BOGCC/TL/2026-27/00013');
      expect(registerSerialNo('SL', '2026-27', 7), 'SL/2026-27/007');
      expect(certificateNo('2026-27', 42), 'BOGCC/CERT/2026-27/0042');
      expect(receiptNo('2026-27', 104), 'MR/2026-27/0104');
      expect(holdingNo(5, 123), 'W05-0123');
      expect(applicationNo('2026-27', 7), 'BOGCC/APP/2026-27/0007');
    });

    test('receipts map onto 100-leaf paper books', () {
      expect(receiptBookRef(1), (bookNo: 1, pageNo: 1));
      expect(receiptBookRef(100), (bookNo: 1, pageNo: 100));
      expect(receiptBookRef(101), (bookNo: 2, pageNo: 1));
      expect(receiptBookRef(250), (bookNo: 3, pageNo: 50));
    });

    test('transaction ids avoid characters that are ambiguous aloud', () {
      var i = 0;
      final id = txnId(() => (i++ % 34) / 34);
      expect(id, startsWith('TXN'));
      expect(id, hasLength(11));
      expect(id.substring(3), isNot(contains('I')));
      expect(id.substring(3), isNot(contains('O')));
    });
  });

  group('status tones', () {
    test('a licence hands off to the right desk', () {
      expect(nextActionFor(LicenceStatus.submitted)?.role, AppRole.inspector);
      expect(nextActionFor(LicenceStatus.verified)?.role, AppRole.licenceOfficer);
      expect(nextActionFor(LicenceStatus.approved)?.role, AppRole.accounts);
      expect(nextActionFor(LicenceStatus.issued), isNull);
      expect(nextActionFor(LicenceStatus.cancelled), isNull);
    });

    test('first status is pending, last is success, cancelled is danger', () {
      const statuses = ['received', 'assigned', 'repaired'];
      expect(entryStatusTone(statuses, 'received'), Tone.pending);
      expect(entryStatusTone(statuses, 'assigned'), Tone.info);
      expect(entryStatusTone(statuses, 'repaired'), Tone.success);
      expect(entryStatusTone(statuses, 'repaired', cancelled: true), Tone.danger);
      expect(entryStatusTone(statuses, 'nonsense'), Tone.neutral);
    });
  });
}
