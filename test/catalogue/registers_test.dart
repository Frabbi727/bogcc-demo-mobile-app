import 'package:bogcc_demo_mobile_app/catalogue/registers/registers.dart';
import 'package:bogcc_demo_mobile_app/catalogue/services.dart';
import 'package:bogcc_demo_mobile_app/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';

/// These check invariants the three generic screens rely on. A config that
/// breaks one of them compiles perfectly well and then misbehaves at runtime —
/// a step nobody can action, a book column with no field, a certificate with no
/// template — so the checks live here rather than in a code review.
void main() {
  group('the registry', () {
    test('holds all nine registers with unique keys and prefixes', () {
      expect(registers, hasLength(9));
      expect(registers.map((r) => r.key).toSet(), hasLength(9));
      expect(registers.map((r) => r.serialPrefix).toSet(), hasLength(9));
    });

    test('looks up by key and by service', () {
      expect(getRegister('streetlight')?.title, contains('সড়কবাতি'));
      expect(getRegister('nonexistent'), isNull);
      expect(getRegister(null), isNull);
      expect(registerForService('cert-warish')?.key, 'cert-warish');
      expect(registerForService(null), isNull);
    });

    test('four registers are citizen-facing', () {
      expect(
        citizenRegisters.map((r) => r.key),
        ['streetlight', 'garbage', 'cert-citizen', 'cert-warish'],
      );
    });
  });

  group('every config', () {
    test('has at least two steps, the first of which is creation', () {
      for (final r in registers) {
        expect(r.steps.length, greaterThanOrEqualTo(2), reason: r.key);
        // Nobody "advances into" the first step — it is set when the line is
        // opened, so it must have no actors or the UI would offer a dead button.
        expect(r.steps.first.actors, isEmpty, reason: '${r.key} first step');
      }
    });

    test('every later step has someone who can action it', () {
      for (final r in registers) {
        for (final step in r.steps.skip(1)) {
          expect(
            step.actors,
            isNotEmpty,
            reason: '${r.key}/${step.key} can never be reached',
          );
        }
      }
    });

    test('every step actor is an office role, never the citizen', () {
      for (final r in registers) {
        for (final step in r.steps) {
          for (final role in step.actors) {
            expect(role.isOffice, isTrue, reason: '${r.key}/${step.key}');
          }
        }
      }
    });

    test('every required field on a step actually exists', () {
      for (final r in registers) {
        for (final step in r.steps) {
          for (final key in step.requiredFields) {
            expect(
              r.fieldOf(key),
              isNotNull,
              reason: '${r.key}/${step.key} requires unknown field "$key"',
            );
          }
        }
      }
    });

    test('field keys are unique within a register', () {
      for (final r in registers) {
        final keys = r.fields.map((f) => f.key).toList();
        expect(keys.toSet(), hasLength(keys.length), reason: r.key);
      }
    });

    test('the date field it filters by is a real field or createdAt', () {
      for (final r in registers) {
        if (r.dateField == 'createdAt') continue;
        expect(
          r.fieldOf(r.dateField),
          isNotNull,
          reason: '${r.key} filters on unknown field "${r.dateField}"',
        );
      }
    });

    test('every total is a numeric field', () {
      for (final r in registers) {
        for (final key in r.totals) {
          final field = r.fieldOf(key);
          expect(field, isNotNull, reason: '${r.key} totals unknown "$key"');
          expect(field!.type, FieldType.number, reason: '${r.key}.$key');
        }
      }
    });

    test('applicant fields exist and are the right types', () {
      for (final r in registers) {
        final a = r.applicantFields;
        if (a == null) continue;
        expect(r.fieldOf(a.name)?.type, FieldType.text, reason: r.key);
        expect(r.fieldOf(a.mobile)?.type, FieldType.phone, reason: r.key);
      }
    });

    test('someone can create, and someone can cancel', () {
      // Nothing is ever deleted, so a register with no cancel role would have
      // records that can never be corrected.
      for (final r in registers) {
        expect(r.createRoles, isNotEmpty, reason: r.key);
        expect(r.cancelRoles, isNotEmpty, reason: r.key);
      }
    });

    test('a printable register carries a certificate template', () {
      for (final r in registers) {
        if (!r.printable) continue;
        expect(r.certificate, isNotNull, reason: '${r.key} is printable but has no template');
        expect(r.certificate!.signatories, isNotEmpty, reason: r.key);
      }
    });

    test('every certificate placeholder maps to a real field', () {
      // A stray {{typo}} would print literally on a signed certificate.
      final placeholder = RegExp(r'\{\{(\w+)\}\}');
      for (final r in registers) {
        final cert = r.certificate;
        if (cert == null) continue;
        for (final match in placeholder.allMatches(cert.body)) {
          final key = match.group(1)!;
          expect(
            r.fieldOf(key),
            isNotNull,
            reason: '${r.key} certificate body references unknown "$key"',
          );
        }
        for (final section in cert.sections) {
          for (final key in section.fields) {
            expect(r.fieldOf(key), isNotNull, reason: '${r.key}/${section.label} -> $key');
          }
        }
      }
    });

    test('a citizen-facing register links to a service and asks for something', () {
      for (final r in registers.where((r) => r.citizenFacing)) {
        expect(r.serviceKey, isNotNull, reason: r.key);
        expect(serviceOf(r.serviceKey), isNotNull, reason: r.key);
        expect(r.citizenFields, isNotEmpty, reason: r.key);
        expect(r.applicantFields, isNotNull,
            reason: '${r.key} cannot notify the applicant');
      }
    });

    test('a citizen is never asked for a staff-only field', () {
      for (final r in registers) {
        for (final f in r.citizenFields) {
          expect(f.staffOnly, isFalse, reason: '${r.key}.${f.key}');
        }
      }
    });

    test('its steps agree with the service catalogue it implements', () {
      // The citizen's tracking screen reads step labels from the register and
      // the charter reads them from the catalogue; if they disagree, the
      // applicant is told two different stories.
      for (final r in registers.where((r) => r.serviceKey != null)) {
        final service = serviceOf(r.serviceKey);
        if (service == null || service.statuses.isEmpty) continue;
        expect(r.statusKeys, service.statuses, reason: r.key);
        for (final step in r.steps) {
          expect(
            service.citizenLabels[step.key],
            step.citizenLabel,
            reason: '${r.key}/${step.key} label differs from the charter',
          );
        }
      }
    });

    test('select fields offer options, and non-select fields do not', () {
      for (final r in registers) {
        for (final f in r.fields) {
          if (f.type == FieldType.select) {
            expect(f.options, isNotNull, reason: '${r.key}.${f.key}');
            expect(f.options, isNotEmpty, reason: '${r.key}.${f.key}');
          } else {
            expect(f.options, isNull, reason: '${r.key}.${f.key}');
          }
        }
      }
    });
  });

  group('workflow helpers', () {
    final sl = getRegister('streetlight')!;

    test('nextStep walks the workflow and stops at the end', () {
      expect(sl.nextStep('received')?.key, 'assigned');
      expect(sl.nextStep('assigned')?.key, 'repaired');
      expect(sl.nextStep('repaired'), isNull);
      expect(sl.nextStep('nonsense'), isNull);
    });

    test('canAdvance gates on the next step actors, not the current ones', () {
      // The electrician repairs, but does not assign; the operator assigns but
      // does not repair. Getting this backwards is the classic engine bug.
      expect(sl.canAdvance('received', AppRole.operator), isTrue);
      expect(sl.canAdvance('received', AppRole.electrician), isFalse);
      expect(sl.canAdvance('assigned', AppRole.electrician), isTrue);
      expect(sl.canAdvance('assigned', AppRole.operator), isFalse);
      expect(sl.canAdvance('repaired', AppRole.electrician), isFalse);
      expect(sl.canAdvance('received', AppRole.citizen), isFalse);
    });

    test('field partitions are disjoint where they should be', () {
      for (final r in registers) {
        // intakeFields is everything a walk-in operator fills: never staff-only.
        for (final f in r.intakeFields) {
          expect(f.staffOnly, isFalse, reason: '${r.key}.${f.key}');
        }
        // Every citizen field is also an intake field.
        for (final f in r.citizenFields) {
          expect(r.intakeFields.map((i) => i.key), contains(f.key));
        }
      }
    });

    test('applicantFrom reads the applicant out of entry data', () {
      expect(
        sl.applicantFrom({
          'complainant': 'রহিমা খাতুন',
          'complainantMobile': '01700000000',
        }),
        (name: 'রহিমা খাতুন', mobile: '01700000000'),
      );
      // Missing or wrongly typed data yields null rather than a bad record.
      expect(sl.applicantFrom({'complainant': 'রহিমা'}), isNull);
      expect(sl.applicantFrom({'complainant': 5, 'complainantMobile': '01'}), isNull);
      // A register that does not collect them says so.
      expect(getRegister('garbage-trips')!.applicantFrom({}), isNull);
    });

    test('only the two internal log books have no applicant', () {
      // Both are records the office keeps for itself, so there is nobody to
      // notify and nothing to track.
      final withoutApplicant =
          registers.where((r) => r.applicantFields == null).map((r) => r.key);
      expect(withoutApplicant, ['garbage-trips', 'birth-death']);
    });
  });
}
