import 'package:bogcc_demo_mobile_app/catalogue/business_types.dart';
import 'package:bogcc_demo_mobile_app/catalogue/services.dart';
import 'package:bogcc_demo_mobile_app/catalogue/users.dart';
import 'package:bogcc_demo_mobile_app/catalogue/wards.dart';
import 'package:bogcc_demo_mobile_app/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('services', () {
    test('every declared status has a citizen-facing label', () {
      // This is the charter's whole promise: a citizen never sees a raw
      // internal status key. Nothing in the type system enforces it.
      for (final s in services) {
        for (final status in s.statuses) {
          expect(
            s.citizenLabels[status],
            isNotNull,
            reason: '${s.key} has no citizen label for "$status"',
          );
        }
      }
    });

    test('every cancellable service can say so to the citizen', () {
      // Nothing is ever deleted -- it is cancelled with a reason and stays
      // visible -- so every service a citizen can apply for needs wording for
      // that. holding-pay is the one exception: a payment is not cancelled, it
      // either completes or fails, and the gateway screen says which.
      for (final s in services.where((s) => s.citizenFacing)) {
        if (s.key == 'holding-pay') {
          expect(s.citizenLabels.containsKey('cancelled'), isFalse);
          continue;
        }
        expect(
          s.citizenLabels['cancelled'],
          isNotNull,
          reason: '${s.key} cannot tell a citizen it was cancelled',
        );
      }
    });

    test('keys are unique', () {
      final keys = services.map((s) => s.key).toList();
      expect(keys.toSet(), hasLength(keys.length));
    });

    test('an info-only service points somewhere and offers no application', () {
      final bdris = serviceOf('bdris')!;
      expect(bdris.infoOnly, isTrue);
      expect(bdris.externalUrl, isNotNull);
      expect(bdris.citizenFacing, isFalse);
      expect(bdris.statuses, isEmpty);
    });

    test('a fixed fee actually carries an amount', () {
      for (final s in services.where((s) => s.fee.kind == FeeKind.fixed)) {
        expect(s.fee.amount, isNotNull, reason: '${s.key} is fixed-fee but has no amount');
        expect(fixedFeeOf(s.key), greaterThan(0));
      }
      expect(fixedFeeOf('cert-citizen'), 100);
      expect(fixedFeeOf('cert-warish'), 200);
      // A free or as-billed service reports zero rather than throwing.
      expect(fixedFeeOf('streetlight'), 0);
      expect(fixedFeeOf('unknown-service'), 0);
    });

    test('citizen label falls back to the raw key rather than showing nothing', () {
      expect(citizenLabel('streetlight', 'assigned'), 'মিস্ত্রি পাঠানো হয়েছে');
      expect(citizenLabel('streetlight', 'nonsense'), 'nonsense');
    });

    test('charter days default sensibly for an unknown service', () {
      expect(charterDaysOf('tl-new'), 7);
      expect(charterDaysOf('unknown'), 3);
    });

    test('citizenServices excludes the info-only entry', () {
      expect(citizenServices.map((s) => s.key), isNot(contains('bdris')));
      expect(citizenServices, hasLength(7));
    });
  });

  group('wards', () {
    test('there are 21, numbered from 1', () {
      expect(wardCount, 21);
      expect(wards.first, 1);
      expect(wards.last, 21);
      expect(wards, hasLength(21));
    });

    test('every ward has a councillor and contact details', () {
      for (final ward in wards) {
        final info = wardInfo(ward)!;
        expect(info.councillor, isNotEmpty);
        expect(info.mobile, matches(RegExp(r'^01\d{9}$')));
      }
      expect(wardInfo(99), isNull);
    });

    test('the demo councillor login matches its ward entry', () {
      expect(userFor(AppRole.councillor).ward, councillorWard);
      expect(wardInfo(councillorWard)!.councillor,
          userFor(AppRole.councillor).name);
    });
  });

  group('users', () {
    test('every role has a user, including the citizen', () {
      for (final role in AppRole.values) {
        expect(users[role], isNotNull, reason: '$role has no user');
        expect(userFor(role).hint, isNotEmpty);
      }
    });

    test('the office picker lists every office role and no citizen', () {
      expect(officeRoleOrder, hasLength(AppRole.values.length - 1));
      expect(officeRoleOrder, isNot(contains(AppRole.citizen)));
      expect(officeRoleOrder.toSet(), hasLength(officeRoleOrder.length));
      for (final role in officeRoleOrder) {
        expect(role.isOffice, isTrue);
      }
    });
  });

  group('trade licence fees', () {
    test('a new licence is charged for the book, a renewal is not', () {
      final fresh = feeLinesFor('grocery');
      final renewal = feeLinesFor('grocery', renewal: true);
      expect(fresh.map((l) => l.label), contains('আবেদন ফরম ও বই মূল্য'));
      expect(renewal.map((l) => l.label),
          isNot(contains('আবেদন ফরম ও বই মূল্য')));
      expect(feeTotalOf(fresh) - feeTotalOf(renewal), formAndBookFee);
    });

    test('the totals match the demo schedule', () {
      // grocery: 1200 licence + 300 signboard + 180 VAT + 200 book
      expect(feeTotalOf(feeLinesFor('grocery')), 1880);
      // wholesale: 5000 + 900 + 750 + 200
      expect(feeTotalOf(feeLinesFor('wholesale')), 6850);
    });

    test('a late renewal adds 10% of the licence fee', () {
      final onTime = feeTotalOf(feeLinesFor('grocery', renewal: true));
      final late = feeTotalOf(feeLinesFor('grocery', renewal: true, late: true));
      expect(late - onTime, 120);
    });

    test('lateness is measured from 30 September of the fiscal year', () {
      expect(isLateRenewal('2026-27', DateTime(2026, 9, 30, 12)), isFalse);
      expect(isLateRenewal('2026-27', DateTime(2026, 10, 1)), isTrue);
    });

    test('an unknown business type falls back rather than throwing', () {
      expect(businessTypeOf('nonexistent').key, businessTypes.first.key);
    });

    test('keys are unique and every rate is positive', () {
      final keys = businessTypes.map((t) => t.key).toList();
      expect(keys.toSet(), hasLength(keys.length));
      for (final t in businessTypes) {
        expect(t.licenceFee, greaterThan(0));
        expect(t.signboardTax, greaterThan(0));
      }
    });
  });
}
