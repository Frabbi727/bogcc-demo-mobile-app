import 'package:bogcc_demo_mobile_app/catalogue/registers/registers.dart';
import 'package:bogcc_demo_mobile_app/core/time/local_iso.dart';
import 'package:bogcc_demo_mobile_app/domain/enums.dart';
import 'package:bogcc_demo_mobile_app/domain/models/register_entry.dart';
import 'package:bogcc_demo_mobile_app/domain/models/shared.dart';
import 'package:bogcc_demo_mobile_app/engine/field_display.dart';
import 'package:bogcc_demo_mobile_app/features/citizen/documents/certificate_sheet.dart';
import 'package:bogcc_demo_mobile_app/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/load_app_fonts.dart';

RegisterEntry _entry({
  required String registerKey,
  required Map<String, dynamic> data,
  String? certificateNo,
  String status = 'issued',
}) {
  final at = DateTime(2026, 9, 20, 11, 30);
  return RegisterEntry(
    id: 'e1',
    serviceKey: registerKey,
    trackingNo: 'BOGCC-2026-000123',
    channel: Channel.online,
    applicantName: data['name']?.toString() ??
        data['applicantName']?.toString() ??
        'নাগরিক',
    applicantMobile: '01712345678',
    ward: 5,
    status: status,
    history: [
      HistoryStep(
        status: status,
        at: at,
        byName: 'ডাটা এন্ট্রি অপারেটর',
        byRole: AppRole.operator,
      ),
    ],
    createdAt: at,
    dueAt: at,
    fiscalYear: '2026-27',
    registerKey: registerKey,
    serial: 7,
    serialNo: 'CC/2026-27/007',
    certificateNo: certificateNo,
    receiptId: 'r1',
    data: data,
  );
}

const _citizenData = <String, dynamic>{
  'name': 'রহিমা খাতুন',
  'fatherName': 'আব্দুল করিম',
  'motherName': 'সালেহা বেগম',
  'dob': '1990-03-14',
  'nid': '1994881234567',
  'address': 'সাতমাথা, সদর',
  'ward': 5,
  'mobile': '01712345678',
};

void main() {
  group('field display', () {
    final config = getRegister('cert-citizen')!;
    RegisterField field(String key) =>
        config.fields.firstWhere((f) => f.key == key);

    test('a date is written as a Bangla calendar date, not a raw ISO string',
        () {
      // '1990-03-14' printed literally on a signed certificate is the failure
      // this guards: it is the value as stored, not as read.
      final shown = displayField(field('dob'), '1990-03-14');
      expect(shown, isNot(contains('1990')));
      expect(shown, isNot(contains('-')));
      expect(shown, contains('১৯৯০'));
    });

    test('digits are Bangla everywhere they are shown', () {
      expect(displayField(field('nid'), '1994881234567'), '১৯৯৪৮৮১২৩৪৫৬৭');
      expect(displayField(field('ward'), 5), 'ওয়ার্ড ৫');
    });

    test('an empty value reads as a known absence, not a blank', () {
      expect(displayField(field('name'), null), emptyFieldMark);
      expect(displayField(field('name'), ''), emptyFieldMark);
    });

    test('interpolation leaves no wording of its own around the value', () {
      // Inside a sentence the ward number must not carry its own label, or the
      // certificate reads "ওয়ার্ড নং ওয়ার্ড ৫".
      expect(interpolatedField(field('ward'), 5), '৫');
      expect(interpolatedField(field('dob'), '1990-03-14'), contains('১৯৯০'));
    });
  });

  group('certificate body', () {
    testWidgets('every placeholder is replaced with the entry\'s own value',
        (tester) async {
      final config = getRegister('cert-citizen')!;
      final sheet = CertificateSheet(
        entry: _entry(registerKey: 'cert-citizen', data: _citizenData),
        config: config,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: buildAppTheme(),
          home: Scaffold(body: SingleChildScrollView(child: sheet)),
        ),
      );

      // No `{{...}}` survives anywhere on the sheet.
      final texts = tester
          .widgetList<Text>(find.byType(Text))
          .map((t) => t.data ?? '')
          .join('\n');
      expect(texts, isNot(contains('{{')));
      expect(texts, contains('রহিমা খাতুন'));
      expect(texts, contains('সাতমাথা, সদর'));
    });

    testWidgets('an unpaid-looking warish sheet still lists every heir',
        (tester) async {
      final config = getRegister('cert-warish')!;
      final heirsKey = config.fields
          .firstWhere((f) => f.type == FieldType.heirs)
          .key;

      final sheet = CertificateSheet(
        entry: _entry(
          registerKey: 'cert-warish',
          data: <String, dynamic>{
            'deceasedName': 'মোঃ আব্দুল করিম',
            'deathDate': '2026-02-11',
            'address': 'সাতমাথা, সদর',
            'ward': 5,
            'applicantName': 'রহিমা খাতুন',
            'relation': 'কন্যা',
            'mobile': '01712345678',
            heirsKey: [
              const Heir(name: 'রহিমা খাতুন', relation: 'কন্যা', age: 34)
                  .toJson(),
              const Heir(name: 'সালেহা বেগম', relation: 'স্ত্রী', age: 58)
                  .toJson(),
            ],
          },
        ),
        config: config,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: buildAppTheme(),
          home: Scaffold(body: SingleChildScrollView(child: sheet)),
        ),
      );

      expect(find.text('রহিমা খাতুন'), findsWidgets);
      expect(find.text('সালেহা বেগম'), findsWidgets);
      expect(find.text('৩৪ বছর'), findsOneWidget);
      expect(find.text('৫৮ বছর'), findsOneWidget);
    });
  });

  group('issue date', () {
    test('it is when the final step was reached, not when it was applied for',
        () {
      final config = getRegister('cert-citizen')!;
      final applied = DateTime(2026, 9, 1, 10);
      final issued = DateTime(2026, 9, 20, 16, 5);

      final entry = _entry(
        registerKey: 'cert-citizen',
        data: _citizenData,
      ).copyWith(
        createdAt: applied,
        history: [
          HistoryStep(
            status: 'received',
            at: applied,
            byName: 'নাগরিক',
            byRole: AppRole.operator,
          ),
          HistoryStep(
            status: config.steps.last.key,
            at: issued,
            byName: 'ডাটা এন্ট্রি অপারেটর',
            byRole: AppRole.operator,
          ),
        ],
      );

      final sheet = CertificateSheet(entry: entry, config: config);
      expect(sheet.issuedOn, issued);
    });

    test('it falls back to the filing date when the step is missing', () {
      final config = getRegister('cert-citizen')!;
      final entry = _entry(
        registerKey: 'cert-citizen',
        data: _citizenData,
        status: 'received',
      ).copyWith(history: const []);

      expect(
        CertificateSheet(entry: entry, config: config).issuedOn,
        entry.createdAt,
      );
    });

    test('the timestamp never drifts to another calendar day', () {
      // A certificate reached at 11pm must not be dated tomorrow. Nothing here
      // may call toUtc(); see core/time/local_iso.dart.
      final late = DateTime(2026, 9, 20, 23, 40);
      final config = getRegister('cert-citizen')!;
      final entry = _entry(
        registerKey: 'cert-citizen',
        data: _citizenData,
      ).copyWith(
        history: [
          HistoryStep(
            status: config.steps.last.key,
            at: late,
            byName: 'অপারেটর',
            byRole: AppRole.operator,
          ),
        ],
      );

      final sheet = CertificateSheet(entry: entry, config: config);
      expect(sheet.verifyUrl, contains('2026-09-20'));
      expect(iso(sheet.issuedOn), isNot(endsWith('Z')));
    });
  });

  group('verification QR', () {
    test('it carries the record itself, so a scan works with no server', () {
      final config = getRegister('cert-citizen')!;
      final sheet = CertificateSheet(
        entry: _entry(
          registerKey: 'cert-citizen',
          data: _citizenData,
          certificateNo: 'BOGCC/CERT/2026-27/0042',
        ),
        config: config,
      );

      final params = Uri.parse(sheet.verifyUrl).queryParameters;
      expect(params['t'], 'cert');
      expect(params['ln'], 'BOGCC/CERT/2026-27/0042');
      expect(params['on'], 'রহিমা খাতুন');
      expect(params['w'], '5');
      expect(params['bn'], 'নাগরিকত্ব সনদপত্র');
    });

    test('it falls back to the register serial before a number is assigned',
        () {
      final sheet = CertificateSheet(
        entry: _entry(registerKey: 'cert-citizen', data: _citizenData),
        config: getRegister('cert-citizen')!,
      );
      expect(Uri.parse(sheet.verifyUrl).queryParameters['ln'],
          'CC/2026-27/007');
    });
  });

  group('golden', () {
    setUpAll(loadAppFonts);

    testWidgets('the citizenship certificate renders its Bangla correctly',
        (tester) async {
      tester.view.physicalSize =
          const Size(certificateSheetWidth, certificateSheetHeight);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          home: Scaffold(
            body: CertificateSheet(
              entry: _entry(
                registerKey: 'cert-citizen',
                data: _citizenData,
                certificateNo: 'BOGCC/CERT/2026-27/0042',
              ),
              config: getRegister('cert-citizen')!,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Without loadAppFonts this records a sheet of tofu boxes as "expected".
      await expectLater(
        find.byType(CertificateSheet),
        matchesGoldenFile('goldens/cert_citizen_sheet.png'),
      );
    });
  });
}
