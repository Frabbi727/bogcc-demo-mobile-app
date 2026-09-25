import 'dart:convert';

import 'package:bogcc_demo_mobile_app/domain/enums.dart';
import 'package:bogcc_demo_mobile_app/domain/models/audit_entry.dart';
import 'package:bogcc_demo_mobile_app/domain/models/holding.dart';
import 'package:bogcc_demo_mobile_app/domain/models/json.dart';
import 'package:bogcc_demo_mobile_app/domain/models/licence.dart';
import 'package:bogcc_demo_mobile_app/domain/models/money.dart';
import 'package:bogcc_demo_mobile_app/domain/models/register_entry.dart';
import 'package:bogcc_demo_mobile_app/domain/models/shared.dart';
import 'package:bogcc_demo_mobile_app/domain/rules/sla.dart';
import 'package:flutter_test/flutter_test.dart';

/// A hand-written fixture, deliberately covering the awkward parts: a nested
/// list of objects (heirs), an optional timestamp, a sealed union, and a
/// cancelled record.
const _entryJson = {
  'id': 'e1',
  'serviceKey': 'cert-warish',
  'trackingNo': 'BOGCC-2026-000123',
  'channel': 'online',
  'applicantName': 'রহিমা খাতুন',
  'applicantMobile': '01700000000',
  'ward': 5,
  'status': 'verified',
  'history': [
    {
      'status': 'received',
      'at': '2026-09-20T10:00:00.000',
      'byName': 'অপারেটর',
      'byRole': 'operator',
      'note': 'অনলাইনে জমা',
      'publicNote': true,
    },
  ],
  'createdAt': '2026-09-20T10:00:00.000',
  'dueAt': '2026-09-29T23:59:59.000',
  'closedAt': null,
  'serial': 8,
  'registerNo': 'CW/2026-27/008',
  'fiscalYear': '2026-27',
  'cancelled': null,
  'feedback': null,
  'photos': <Map<String, dynamic>>[],
  'slaExempt': false,
  'registerKey': 'cert-warish',
  'serialNo': 'CW/2026-27/008',
  'data': {
    'deceasedName': 'আব্দুল করিম',
    'heirs': [
      {'name': 'রহিমা খাতুন', 'relation': 'স্ত্রী', 'age': 52},
      {'name': 'সাকিব করিম', 'relation': 'পুত্র', 'age': 28},
    ],
  },
  'feeLines': [
    {'label': 'সনদ ফি', 'amount': 200},
  ],
  'feeTotal': 200,
  'paymentId': 'p1',
  'receiptId': 'r1',
  'certificateNo': null,
};

void main() {
  group('RegisterEntry', () {
    test('round-trips through JSON unchanged', () {
      final entry = RegisterEntry.fromJson(asJsonMap(_entryJson));
      final again = RegisterEntry.fromJson(asJsonMap(entry.toJson()));
      expect(again, entry);
      expect(jsonEncode(again.toJson()), jsonEncode(entry.toJson()));
    });

    test('typed accessors narrow the free-form data map', () {
      final entry = RegisterEntry.fromJson(asJsonMap(_entryJson));
      expect(entry.text('deceasedName'), 'আব্দুল করিম');
      expect(entry.heirs('heirs'), hasLength(2));
      expect(entry.heirs('heirs').first.relation, 'স্ত্রী');
      expect(entry.heirs('nonexistent'), isEmpty);
      expect(entry.number('missing'), isNull);
    });

    test('is an SlaSubject, so the generic helpers accept it', () {
      final entry = RegisterEntry.fromJson(asJsonMap(_entryJson));
      expect(entry, isA<SlaSubject>());
      expect(entry.cancelledAt, isNull);
      expect(entry.isOpen, isTrue);
      expect(slaStatus(entry, asOf: DateTime(2026, 9, 22)), SlaStatus.onTime);
      expect(slaStatus(entry, asOf: DateTime(2026, 10, 5)), SlaStatus.overdue);
    });

    test('publicHistory keeps the steps but strips private notes', () {
      // A citizen must see that a step happened without reading an internal
      // remark attached to it.
      final entry = RegisterEntry.fromJson(asJsonMap(_entryJson));
      final withPrivate = entry.copyWith(
        history: [
          ...entry.history,
          HistoryStep(
            status: 'verified',
            at: DateTime(2026, 9, 22),
            byName: 'পরিদর্শক',
            byRole: AppRole.inspector,
            note: 'অভ্যন্তরীণ মন্তব্য',
          ),
        ],
      );
      expect(withPrivate.publicHistory, hasLength(2));
      expect(withPrivate.publicHistory[0].note, 'অনলাইনে জমা');
      expect(withPrivate.publicHistory[1].note, isNull);
      expect(withPrivate.publicHistory[1].status, 'verified');
    });

    test('a cancelled record is never overdue', () {
      final entry = RegisterEntry.fromJson(asJsonMap(_entryJson)).copyWith(
        cancelled: Cancellation(
          at: DateTime(2026, 9, 25),
          by: 'লাইসেন্স অফিসার',
          reason: 'তথ্য অসম্পূর্ণ',
        ),
      );
      expect(entry.cancelledAt, DateTime(2026, 9, 25));
      expect(entry.isOpen, isFalse);
      expect(isOverdue(entry, asOf: DateTime(2027, 1, 1)), isFalse);
    });
  });

  group('asJsonMap', () {
    test('converts the Map<dynamic, dynamic> Hive hands back, recursively', () {
      // Hive returns untyped maps at every level. This is the single place that
      // gets fixed, so a deep model does not fail with an opaque _TypeError.
      final hiveish = <dynamic, dynamic>{
        'holdingNo': 'W05-0123',
        'ward': 5,
        'ownerName': 'করিম',
        'ownerMobile': '01700000000',
        'address': 'সাতমাথা',
        'area': 'সদর',
        'propertyType': 'residential',
        'floors': 2,
        'annualValuation': 120000,
        'bills': <dynamic>[
          <dynamic, dynamic>{
            'fiscalYear': '2026-27',
            'lines': <dynamic>[
              <dynamic, dynamic>{'label': 'কর', 'amount': 8400},
            ],
            'total': 8400,
            'instalments': <dynamic>[
              <dynamic, dynamic>{'no': 1, 'amount': 2100, 'paidAt': null},
              <dynamic, dynamic>{
                'no': 2,
                'amount': 2100,
                'paidAt': '2026-09-01T10:00:00.000',
                'receiptId': 'r9',
              },
            ],
            'arrears': 1500,
            'surcharge': 150,
          },
        ],
      };

      final holding = Holding.fromJson(asJsonMap(hiveish));
      expect(holding.propertyType, PropertyType.residential);
      final bill = holding.billFor('2026-27')!;
      expect(bill.instalments, hasLength(2));
      expect(bill.paid, 2100);
      expect(bill.due, 8400 - 2100 + 1500 + 150);
      expect(bill.isSettled, isFalse);
    });

    test('rejects a value that is not an object', () {
      expect(() => asJsonMap(<int>[1, 2]), throwsArgumentError);
    });
  });

  group('PaymentTarget', () {
    test('each arm round-trips and stays distinguishable', () {
      const targets = [
        PaymentTarget.tradeLicence(id: 'l1'),
        PaymentTarget.registerEntry(id: 'e1', registerKey: 'cert-citizen'),
        PaymentTarget.holding(
          holdingNo: 'W05-0123',
          fiscalYear: '2026-27',
          instalment: 2,
        ),
      ];
      for (final t in targets) {
        expect(PaymentTarget.fromJson(asJsonMap(t.toJson())), t);
      }
      expect(targets[0], isA<TradeLicenceTarget>());
      expect(targets[2], isA<HoldingTarget>());
    });
  });

  group('Licence', () {
    test('exposes its typed status through the BaseRecord string one', () {
      final licence = Licence(
        id: 'l1',
        serviceKey: 'tl-new',
        trackingNo: 'BOGCC-2026-000001',
        channel: Channel.office,
        applicantName: 'করিম',
        applicantMobile: '01700000000',
        ward: 5,
        licenceStatus: LicenceStatus.approved,
        createdAt: DateTime(2026, 9, 20),
        dueAt: DateTime(2026, 9, 29, 23, 59, 59),
        fiscalYear: '2026-27',
        appNo: 'BOGCC/APP/2026-27/0001',
        kind: 'new',
        business: const Business(
          nameBn: 'করিম স্টোর',
          nameEn: 'Karim Store',
          typeKey: 'grocery',
          nature: BusinessNature.single,
          address: 'সাতমাথা',
          area: 'সদর',
          ward: 5,
          holdingNo: 'W05-0123',
        ),
        owner: const Owner(
          name: 'করিম',
          fatherName: 'রহিম',
          motherName: 'আমেনা',
          nid: '1234567890',
          mobile: '01700000000',
        ),
      );
      expect(licence.status, 'approved');
      expect(licence.isRenewal, isFalse);
      expect(Licence.fromJson(asJsonMap(licence.toJson())), licence);
    });
  });

  group('AuditEntry', () {
    test('round-trips with its field changes', () {
      final entry = AuditEntry(
        id: 'a1',
        at: DateTime(2026, 9, 26, 11, 30),
        userName: 'লাইসেন্স অফিসার',
        role: AppRole.licenceOfficer,
        action: 'অনুমোদন',
        recordType: AuditRecordType.tradeLicence,
        recordKey: 'tl-new',
        recordId: 'l1',
        recordLabel: 'BOGCC/TL/2026-27/00013',
        changes: const [
          FieldChange(field: 'status', before: 'verified', after: 'approved'),
        ],
      );
      expect(AuditEntry.fromJson(asJsonMap(entry.toJson())), entry);
    });
  });
}
