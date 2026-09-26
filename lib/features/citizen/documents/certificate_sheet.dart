/// The certificate itself, as an A4 sheet.
///
/// Ported from the web's `src/pages/print/Certificate.tsx`. The wording, the
/// fields and the signatories all come from the register's [CertificateSpec],
/// so a new certificate register needs no new widget here.
///
/// **This is a Flutter widget, not a PDF, and that is deliberate.** The `pdf`
/// package has no complex-script shaper: Bengali conjuncts and pre-base vowels
/// render broken through it. Going through Flutter's own text engine and
/// exporting a raster is the only way these glyphs come out right. See
/// `doc/decisions.md`.
library;

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../catalogue/registers/registers.dart';
import '../../../catalogue/users.dart';
import '../../../catalogue/wards.dart';
import '../../../core/bn/bn.dart';
import '../../../domain/enums.dart';
import '../../../domain/models/register_entry.dart';
import '../../../domain/models/shared.dart';
import '../../../engine/field_display.dart';
import '../../../ui/theme/colors.dart';
import '../../../ui/theme/spacing.dart';
import '../../../ui/theme/typography.dart';

/// A4 at a comfortable raster density. The sheet is laid out at this width and
/// scaled to fit the screen, so the exported PNG is the same drawing the
/// citizen looked at rather than a second layout that could drift from it.
const certificateSheetWidth = 794.0;
const certificateSheetHeight = 1123.0;

/// The display face, with its Bengali fallback.
///
/// Every heading on the sheet goes through this rather than naming the family
/// inline: a style that forgets [AppFonts.fallback] renders tofu for any glyph
/// Tiro Bangla happens not to carry, and on a signed certificate that is not a
/// cosmetic bug.
TextStyle _display({
  required double size,
  double? height,
  Color color = AppColors.ink,
  FontWeight? weight,
}) =>
    TextStyle(
      fontFamily: AppFonts.display,
      fontFamilyFallback: AppFonts.fallback,
      fontSize: size,
      height: height,
      color: color,
      fontWeight: weight,
    );

class CertificateSheet extends StatelessWidget {
  const CertificateSheet({
    required this.entry,
    required this.config,
    super.key,
  });

  final RegisterEntry entry;
  final RegisterConfig config;

  /// The date the certificate bears: when the last step was reached, falling
  /// back to when the line was opened.
  DateTime get issuedOn {
    final lastKey = config.steps.last.key;
    for (final step in entry.history.reversed) {
      if (step.status == lastKey) return step.at;
    }
    return entry.createdAt;
  }

  /// What the QR encodes.
  ///
  /// The whole record travels in the query string rather than an id, because
  /// there is no server to look an id up against: a phone scanning this must
  /// be able to check it offline, which is the entire reason for printing one.
  String get verifyUrl {
    final params = <String, String>{
      't': 'cert',
      'ln': entry.certificateNo ?? entry.serialNo,
      'bn': config.certificate?.docTitle ?? 'সনদপত্র',
      'on': entry.applicantName,
      'vu': issuedOn.toIso8601String().substring(0, 10),
      'w': entry.ward.toString(),
    };
    return Uri(
      scheme: 'https',
      host: 'bogcc.demo',
      path: '/verify',
      queryParameters: params,
    ).toString();
  }

  RegisterField? _field(String key) {
    for (final f in config.fields) {
      if (f.key == key) return f;
    }
    return null;
  }

  /// `{{field}}` placeholders, filled from the entry's own data.
  String get _body {
    final template = config.certificate?.body ?? '';
    return template.replaceAllMapped(
      RegExp(r'\{\{(\w+)\}\}'),
      (m) => interpolatedField(_field(m.group(1)!), entry.data[m.group(1)!]),
    );
  }

  List<Heir> get _heirs {
    for (final f in config.fields) {
      if (f.type == FieldType.heirs) return entry.heirs(f.key);
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final certificate = config.certificate;
    if (certificate == null) return const SizedBox.shrink();

    final councillor = wardInfo(entry.ward)?.councillor ??
        userFor(AppRole.councillor).name;
    final cancelled = entry.cancelled != null;

    return Container(
      width: certificateSheetWidth,
      constraints: const BoxConstraints(minHeight: certificateSheetHeight),
      color: AppColors.page,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(section: config.section, docTitle: certificate.docTitle),
            const SizedBox(height: Insets.lg),
            _NumberLine(entry: entry, issuedOn: issuedOn),
            const SizedBox(height: Insets.lg),

            Text(
              _body,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 15, height: 2),
            ),

            for (final section in certificate.sections) ...[
              const SizedBox(height: Insets.lg),
              _SectionTable(
                label: section.label,
                rows: [
                  for (final key in section.fields)
                    (
                      _field(key)?.label ?? key,
                      displayField(_field(key), entry.data[key]),
                    ),
                ],
              ),
            ],

            if (_heirs.isNotEmpty) ...[
              const SizedBox(height: Insets.lg),
              _HeirsTable(heirs: _heirs),
            ],

            const SizedBox(height: Insets.xl),
            _Footing(
              verifyUrl: verifyUrl,
              issuedOn: issuedOn,
              cancelled: cancelled,
              signatories: certificate.signatories,
              councillor: councillor,
              ward: entry.ward,
            ),

            // Not a Spacer: the sheet is also laid out unbounded (a scroll
            // view, a golden), and a flex child with no ceiling throws there.
            const SizedBox(height: Insets.xxl),
            const Divider(),
            _FootNote(issuedOn: issuedOn),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.section, required this.docTitle});

  final String section;
  final String docTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: Insets.md),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.ink, width: 2),
        ),
      ),
      child: Column(
        children: [
          Text(
            'গণপ্রজাতন্ত্রী বাংলাদেশ সরকার',
            style: _display(size: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 2),
          Text(
            'বগুড়া সিটি কর্পোরেশন',
            style: _display(size: 26, height: 1.2),
          ),
          Text(
            '$section, বগুড়া',
            style: _display(size: 13.5, color: AppColors.muted),
          ),
          const SizedBox(height: Insets.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Insets.lg,
              vertical: Insets.xs,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.ink, width: 2),
            ),
            child: Text(
              docTitle,
              style: _display(size: 19),
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberLine extends StatelessWidget {
  const _NumberLine({required this.entry, required this.issuedOn});

  final RegisterEntry entry;
  final DateTime issuedOn;

  @override
  Widget build(BuildContext context) {
    // Wrapped, not a Row: these three run long on a real record, and the web
    // lets them flow onto a second line rather than clipping the date off.
    return Wrap(
      spacing: Insets.lg,
      runSpacing: Insets.xs,
      alignment: WrapAlignment.spaceBetween,
      children: [
        _pair('সনদ নং', toBnDigits(entry.certificateNo ?? emptyFieldMark)),
        _pair('রেজিস্টার ক্রমিক নং', toBnDigits(entry.serialNo)),
        _pair('তারিখ', formatDateBn(issuedOn)),
      ],
    );
  }

  Widget _pair(String label, String value) => RichText(
        maxLines: 1,
        text: TextSpan(
          style: _display(size: 14, color: AppColors.ink),
          children: [
            TextSpan(text: '$label: '),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
}

class _SectionTable extends StatelessWidget {
  const _SectionTable({required this.label, required this.rows});

  final String label;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _display(size: 14, color: AppColors.muted),
        ),
        const SizedBox(height: Insets.xs),
        Table(
          border: TableBorder.all(color: AppColors.rule),
          columnWidths: const {0: FractionColumnWidth(0.34)},
          children: [
            for (final (label, value) in rows)
              TableRow(
                children: [
                  _cell(label, muted: true),
                  _cell(value),
                ],
              ),
          ],
        ),
      ],
    );
  }

  static Widget _cell(String text, {bool muted = false}) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.md,
          vertical: 6,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13.5,
            color: muted ? AppColors.muted : AppColors.ink,
          ),
        ),
      );
}

class _HeirsTable extends StatelessWidget {
  const _HeirsTable({required this.heirs});

  final List<Heir> heirs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ওয়ারিশগণের তালিকা',
          style: _display(size: 14, color: AppColors.muted),
        ),
        const SizedBox(height: Insets.xs),
        Table(
          border: TableBorder.all(color: AppColors.rule),
          columnWidths: const {0: FixedColumnWidth(56)},
          children: [
            TableRow(
              decoration: const BoxDecoration(color: AppColors.paper),
              children: [
                _SectionTable._cell('ক্রম'),
                _SectionTable._cell('নাম'),
                _SectionTable._cell('সম্পর্ক'),
                _SectionTable._cell('বয়স'),
              ],
            ),
            for (final (i, heir) in heirs.indexed)
              TableRow(
                children: [
                  _SectionTable._cell(toBnDigits(i + 1)),
                  _SectionTable._cell(heir.name),
                  _SectionTable._cell(heir.relation),
                  _SectionTable._cell('${toBnDigits(heir.age)} বছর'),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _Footing extends StatelessWidget {
  const _Footing({
    required this.verifyUrl,
    required this.issuedOn,
    required this.cancelled,
    required this.signatories,
    required this.councillor,
    required this.ward,
  });

  final String verifyUrl;
  final DateTime issuedOn;
  final bool cancelled;
  final List<String> signatories;
  final String councillor;
  final int ward;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            QrImageView(
              data: verifyUrl,
              size: 92,
              padding: EdgeInsets.zero,
              // Medium: the sheet may be photographed rather than scanned, and
              // the extra redundancy costs nothing at this size.
              errorCorrectionLevel: QrErrorCorrectLevel.M,
            ),
            const SizedBox(height: Insets.xs),
            const SizedBox(
              width: 92,
              child: Text(
                'যাচাইয়ের জন্য স্ক্যান করুন',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.muted),
              ),
            ),
          ],
        ),
        RubberStamp(
          label: cancelled ? 'বাতিল' : 'অনুমোদিত',
          sub: formatDateBn(issuedOn),
        ),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (i, title) in signatories.indexed) ...[
                if (i > 0) const SizedBox(width: Insets.lg),
                Flexible(
                  child: _Signature(
                    name: i == 0 ? councillor : userFor(AppRole.ceo).name,
                    title:
                        i == 0 ? '$title, ওয়ার্ড ${toBnDigits(ward)}' : title,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Signature extends StatelessWidget {
  const _Signature({required this.name, required this.title});

  final String name;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      margin: const EdgeInsets.only(top: Insets.xxl),
      padding: const EdgeInsets.only(top: Insets.xs),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.ink)),
      ),
      child: Column(
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            style: _display(size: 13),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

/// A rubber stamp, tilted like a hand-pressed one on a register page.
class RubberStamp extends StatelessWidget {
  const RubberStamp({required this.label, this.sub, super.key});

  final String label;
  final String? sub;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.105, // about -6°, matching the web's `-rotate-6`.
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.stamp, width: 2),
          boxShadow: const [
            BoxShadow(color: AppColors.page, spreadRadius: 2),
            BoxShadow(color: AppColors.stamp, spreadRadius: 3.5),
            BoxShadow(color: AppColors.page, spreadRadius: 0),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: _display(size: 17, height: 1.1, color: AppColors.stamp),
            ),
            if (sub != null)
              Text(
                sub!,
                style: const TextStyle(
                  fontSize: 9.5,
                  height: 1.1,
                  color: AppColors.stamp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FootNote extends StatelessWidget {
  const _FootNote({required this.issuedOn});

  final DateTime issuedOn;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'ইস্যুর তারিখ: ${formatDateBn(issuedOn)} · '
            '${banglaCalendarDate(issuedOn)}',
            style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
          ),
        ),
        const Text(
          'ডেমো সংস্করণ — সকল তথ্য কাল্পনিক',
          style: TextStyle(
            fontSize: 11.5,
            color: AppColors.amber,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
