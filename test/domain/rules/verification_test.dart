import 'dart:io';

import 'package:bogcc_demo_mobile_app/app/bootstrap.dart';
import 'package:bogcc_demo_mobile_app/catalogue/registers/registers.dart';
import 'package:bogcc_demo_mobile_app/core/time/local_iso.dart';
import 'package:bogcc_demo_mobile_app/domain/enums.dart';
import 'package:bogcc_demo_mobile_app/domain/models/shared.dart';
import 'package:bogcc_demo_mobile_app/domain/rules/fiscal.dart';
import 'package:bogcc_demo_mobile_app/domain/rules/verification.dart';
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('number matching', () {
    test('Bangla digits typed off paper still match the stored number', () {
      // Android keyboards disagree about which digits they emit, so the same
      // number reaches us both ways and both must find the record.
      expect(normaliseDocumentNo('CC/২০২৬-২৭/০০৭'), 'CC/2026-27/007');
      expect(normaliseDocumentNo('  cc/2026-27/007  '), 'CC/2026-27/007');
      expect(normaliseDocumentNo('CC / 2026-27 / 007'), 'CC/2026-27/007');
    });

    test('an empty query matches nothing rather than the first record', () {
      expect(
        findVerifiable(licences: [], entries: [], wanted: '   '),
        isNull,
      );
    });
  });

  group('verdict', () {
    final checkedAt = DateTime(2026, 9, 26, 12);

    VerificationSubject certificate({Cancellation? cancelled}) =>
        VerificationSubject(
          kind: DocumentKind.certificate,
          no: 'BOGCC/CERT/2026-27/0042',
          title: 'নাগরিকত্ব সনদপত্র',
          issuedOn: DateTime(2026, 9, 20),
          cancellation: cancelled,
          fromRecord: true,
        );

    VerificationSubject licence({DateTime? expiry, Cancellation? cancelled}) =>
        VerificationSubject(
          kind: DocumentKind.licence,
          no: 'BOGCC/TL/2026-27/00013',
          title: 'মেসার্স করিম স্টোর',
          validUntil: expiry,
          cancellation: cancelled,
          fromRecord: true,
        );

    test('a genuine certificate is valid', () {
      expect(certificate().verdictAt(checkedAt), Verdict.valid);
    });

    test('a cancelled certificate is NEVER valid', () {
      // The one result that would embarrass the demo, and the reason
      // cancellation is checked before anything else.
      final subject = certificate(
        cancelled: Cancellation(
          at: DateTime(2026, 9, 22),
          by: 'প্রধান নির্বাহী কর্মকর্তা',
          reason: 'ভুল তথ্যের ভিত্তিতে ইস্যু হয়েছিল',
        ),
      );
      expect(subject.verdictAt(checkedAt), Verdict.cancelled);
      expect(verdictLabel(subject.verdictAt(checkedAt), subject.kind),
          'বাতিল সনদ');
    });

    test('a cancelled licence beats an unexpired date on the paper', () {
      final subject = licence(
        expiry: DateTime(2027, 6, 30),
        cancelled: Cancellation(
          at: DateTime(2026, 9, 22),
          by: 'লাইসেন্স কর্মকর্তা',
          reason: 'প্রতিষ্ঠান বন্ধ',
        ),
      );
      expect(subject.verdictAt(checkedAt), Verdict.cancelled);
    });

    test('a licence is valid through the whole of its last day', () {
      final subject = licence(expiry: DateTime(2026, 9, 26));
      // Checked at noon on the expiry date itself.
      expect(subject.verdictAt(checkedAt), Verdict.valid);
      // And at one minute to midnight.
      expect(
        subject.verdictAt(DateTime(2026, 9, 26, 23, 59)),
        Verdict.valid,
      );
      // But not the next morning.
      expect(subject.verdictAt(DateTime(2026, 9, 27, 0, 1)), Verdict.expired);
    });

    test('a licence with no expiry at all is not treated as valid', () {
      expect(licence().verdictAt(checkedAt), Verdict.expired);
    });

    test('a certificate does not expire', () {
      expect(
        certificate().verdictAt(DateTime(2099, 1, 1)),
        Verdict.valid,
      );
    });
  });

  group('subjects from a QR', () {
    test('it reads what the certificate printed into its own URL', () {
      final subject = subjectFromQr(
        Uri.parse(
          'https://bogcc.demo/verify?t=cert&ln=BOGCC%2FCERT%2F2026-27%2F0042'
          '&bn=%E0%A6%A8%E0%A6%BE%E0%A6%97%E0%A6%B0%E0%A6%BF%E0%A6%95%E0%A6%A4'
          '%E0%A7%8D%E0%A6%AC%20%E0%A6%B8%E0%A6%A8%E0%A6%A6%E0%A6%AA%E0%A6%A4'
          '%E0%A7%8D%E0%A6%B0&vu=2026-09-20&w=5',
        ),
      )!;

      expect(subject.kind, DocumentKind.certificate);
      expect(subject.no, 'BOGCC/CERT/2026-27/0042');
      expect(subject.title, 'নাগরিকত্ব সনদপত্র');
      expect(subject.ward, 5);
      expect(subject.issuedOn, DateTime(2026, 9, 20));
      expect(subject.validUntil, isNull);
      expect(subject.fromRecord, isFalse,
          reason: 'a QR cannot know about a later cancellation');
    });

    test('a QR with no number is not a subject', () {
      expect(subjectFromQr(Uri.parse('https://bogcc.demo/verify')), isNull);
      expect(subjectFromQr(Uri.parse('https://bogcc.demo/verify?t=cert&ln=')),
          isNull);
    });

    test('anything not marked a certificate is read as a licence', () {
      final subject =
          subjectFromQr(Uri.parse('https://bogcc.demo/verify?ln=X&vu=2027-06-30'))!;
      expect(subject.kind, DocumentKind.licence);
      expect(subject.validUntil, DateTime(2027, 6, 30));
      expect(subject.issuedOn, isNull);
    });
  });

  group('what the camera read', () {
    test('one of our own QRs comes back with its URL to fall back on', () {
      final code = readScannedCode(
        'https://bogcc.demo/verify?t=cert&ln=BOGCC%2FCERT%2F2026-27%2F0042'
        '&vu=2026-09-20',
      )!;

      expect(code.number, 'BOGCC/CERT/2026-27/0042');
      expect(code.isOurs, isTrue);
      expect(subjectFromQr(code.verifyUrl!)!.no, 'BOGCC/CERT/2026-27/0042');
    });

    test('a foreign QR is only a number, with nothing to fall back on', () {
      // A wifi QR, a URL shortener, a competitor's certificate: there is no
      // trusting its contents, so it gets looked up and nothing more.
      final code = readScannedCode('WIFI:S=BOGCC;T=WPA;P=secret;;')!;
      expect(code.isOurs, isFalse);
      expect(code.verifyUrl, isNull);
      expect(code.number, 'WIFI:S=BOGCC;T=WPA;P=secret;;');
    });

    test('a bare number written on a sticker still scans', () {
      final code = readScannedCode('  BOGCC/TL/2026-27/00013  ')!;
      expect(code.isOurs, isFalse);
      expect(code.number, 'BOGCC/TL/2026-27/00013');
    });

    test('a verify URL with an empty number is not treated as ours', () {
      final code = readScannedCode('https://bogcc.demo/verify?t=cert&ln=')!;
      expect(code.isOurs, isFalse,
          reason: 'there is no number in it to stand in for a record');
    });

    test('an empty read is nothing at all', () {
      expect(readScannedCode(''), isNull);
      expect(readScannedCode('   '), isNull);
    });
  });

  group('against the seeded data', () {
    late Directory tmp;
    late AppServices services;

    setUp(() async {
      tmp = await Directory.systemTemp.createTemp('bogcc_verify');
      PathProviderPlatform.instance = _FakePathProvider(tmp.path);
      services = await bootstrap();
    });

    tearDown(() async {
      await Hive.close();
      if (tmp.existsSync()) await tmp.delete(recursive: true);
    });

    test('an issued certificate is found by its certificate number', () {
      final entry = services.initialState.entries.firstWhere(
        (e) => e.certificateNo != null && e.cancelled == null,
      );

      final found = findVerifiable(
        licences: services.initialState.licences,
        entries: services.initialState.entries,
        wanted: entry.certificateNo!,
      );
      final subject = subjectFromRecord(found)!;

      expect(subject.kind, DocumentKind.certificate);
      expect(subject.no, entry.certificateNo);
      expect(subject.ownerName, entry.applicantName);
      expect(subject.verdictAt(now()), Verdict.valid);
    });

    test('a complaint serial never verifies as a certificate', () {
      // A streetlight complaint has a serial too. Its register issues no
      // certificate, so it must not be verifiable at all.
      final complaint = services.initialState.entries
          .firstWhere((e) => e.registerKey == 'streetlight');
      expect(getRegister('streetlight')!.certificate, isNull);

      expect(
        findVerifiable(
          licences: services.initialState.licences,
          entries: services.initialState.entries,
          wanted: complaint.serialNo,
        ),
        isNull,
      );
    });

    test('a cancelled seeded record reads as cancelled, not valid', () {
      final cancelled = services.initialState.entries.where(
        (e) => e.cancelled != null && getRegister(e.registerKey)?.certificate != null,
      );
      // The seed may or may not include one; when it does, it must be correct.
      for (final entry in cancelled) {
        final subject = subjectFromRecord(entry)!;
        expect(subject.verdictAt(now()), Verdict.cancelled);
      }
    });

    test('an issued licence is found and reads valid until 30 June', () {
      final licence = services.initialState.licences.firstWhere(
        (l) => l.licenceStatus == LicenceStatus.issued && l.cancelled == null,
      );

      final found = findVerifiable(
        licences: services.initialState.licences,
        entries: services.initialState.entries,
        wanted: licence.registerNo ?? licence.appNo,
      );
      final subject = subjectFromRecord(found)!;

      expect(subject.kind, DocumentKind.licence);
      expect(subject.validUntil, validUntil(licence.fiscalYear));
      expect(subject.validUntil!.month, 6);
      expect(subject.validUntil!.day, 30);
    });

    test('the record beats the QR when both describe the same number', () {
      // Print a certificate, then cancel it. Scanning the old paper must not
      // report the stale "valid" the QR itself still carries.
      final entry = services.initialState.entries
          .firstWhere((e) => e.certificateNo != null && e.cancelled == null);

      final cancelledEntry = entry.copyWith(
        cancelled: Cancellation(
          at: now(),
          by: 'প্রধান নির্বাহী কর্মকর্তা',
          reason: 'ভুল তথ্য',
        ),
      );
      final entries = [
        for (final e in services.initialState.entries)
          if (e.id == entry.id) cancelledEntry else e,
      ];

      final fromQr = subjectFromQr(
        Uri.parse('https://bogcc.demo/verify?t=cert&ln=${entry.certificateNo}'
            '&vu=2026-09-20'),
      )!;
      expect(fromQr.verdictAt(now()), Verdict.valid);

      final record = findVerifiable(
        licences: services.initialState.licences,
        entries: entries,
        wanted: entry.certificateNo!,
      );
      expect(subjectFromRecord(record)!.verdictAt(now()), Verdict.cancelled);
    });
  });
}
