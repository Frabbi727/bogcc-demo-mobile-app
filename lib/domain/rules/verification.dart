/// Checking whether a licence or certificate is genuine.
///
/// Ported from the web's `src/pages/Verify.tsx`. Kept as pure functions rather
/// than living inside the screen because the verdict is the part that matters
/// and it should be testable without a widget tree — a certificate wrongly
/// reported valid is the worst single failure this demo can have.
///
/// Two ways a subject arrives:
///   - looked up in this device's own data, which is authoritative
///   - read out of a scanned QR's own query string, for a phone that has
///     never opened the app
///
/// **The record always wins over the QR.** Only the record knows whether the
/// document was cancelled after it was printed, and a cancelled certificate
/// must never read as valid.
library;

import '../../catalogue/registers/registers.dart';
import '../../core/bn/bn.dart';
import '../../core/time/local_iso.dart';
import '../models/licence.dart';
import '../models/register_entry.dart';
import '../models/shared.dart';
import 'fiscal.dart';

enum DocumentKind { licence, certificate }

enum Verdict {
  /// বৈধ — genuine and in force.
  valid,

  /// মেয়াদোত্তীর্ণ — genuine, but past its expiry. Licences only.
  expired,

  /// বাতিল — cancelled, with a reason on the record.
  cancelled,
}

/// What is being checked, whichever way it arrived.
class VerificationSubject {
  const VerificationSubject({
    required this.kind,
    required this.no,
    required this.title,
    required this.fromRecord,
    this.ownerName,
    this.ward,
    this.validUntil,
    this.issuedOn,
    this.cancellation,
  });

  final DocumentKind kind;
  final String no;
  final String title;

  /// True when this came from this device's data rather than from the QR.
  /// A QR can only ever say what was true at printing time.
  final bool fromRecord;

  final String? ownerName;
  final int? ward;

  /// Licences expire at the end of their fiscal year.
  final DateTime? validUntil;

  /// Certificates carry an issue date instead.
  final DateTime? issuedOn;

  final Cancellation? cancellation;

  Verdict verdictAt(DateTime checkedAt) {
    // Cancellation is checked first and beats everything else, including an
    // unexpired date on the paper. This ordering is the point of the function.
    if (cancellation != null) return Verdict.cancelled;
    if (kind == DocumentKind.certificate) return Verdict.valid;

    final expiry = validUntil;
    if (expiry == null) return Verdict.expired;
    // Valid through the whole of the last day, not until midnight starting it.
    final endOfDay = DateTime(expiry.year, expiry.month, expiry.day, 23, 59, 59);
    return checkedAt.isAfter(endOfDay) ? Verdict.expired : Verdict.valid;
  }
}

/// Bangla digits and stray spacing must not stop a number from matching: the
/// number is read off paper and typed by hand, often on a Bangla keyboard.
String normaliseDocumentNo(String s) =>
    bnToEnDigits(s).trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');

/// Finds the licence or certificate a number refers to, or null.
///
/// Only registers that actually issue a certificate are verifiable. A
/// streetlight complaint has a serial number too, and must never come back as
/// a valid certificate.
Object? findVerifiable({
  required List<Licence> licences,
  required List<RegisterEntry> entries,
  required String wanted,
}) {
  final needle = normaliseDocumentNo(wanted);
  if (needle.isEmpty) return null;

  for (final licence in licences) {
    if (normaliseDocumentNo(licence.registerNo ?? '') == needle ||
        normaliseDocumentNo(licence.appNo) == needle) {
      return licence;
    }
  }

  for (final entry in entries) {
    if (getRegister(entry.registerKey)?.certificate == null) continue;
    if (normaliseDocumentNo(entry.certificateNo ?? '') == needle ||
        normaliseDocumentNo(entry.serialNo) == needle) {
      return entry;
    }
  }
  return null;
}

/// Builds a subject from a record held on this device.
VerificationSubject? subjectFromRecord(Object? record) {
  if (record is Licence) {
    return VerificationSubject(
      kind: DocumentKind.licence,
      no: record.registerNo ?? record.appNo,
      title: record.business.nameBn,
      ownerName: record.owner.name,
      ward: record.business.ward,
      validUntil: validUntil(record.fiscalYear),
      cancellation: record.cancelled,
      fromRecord: true,
    );
  }

  if (record is RegisterEntry) {
    final config = getRegister(record.registerKey);
    return VerificationSubject(
      kind: DocumentKind.certificate,
      no: record.certificateNo ?? record.serialNo,
      title: config?.certificate?.docTitle ?? config?.title ?? 'সনদ',
      ownerName: record.applicantName,
      ward: record.ward,
      issuedOn: record.closedAt ?? record.createdAt,
      cancellation: record.cancelled,
      fromRecord: true,
    );
  }

  return null;
}

/// Builds a subject from the query string a QR carries.
///
/// Used only when the record is not on this device. It cannot know about a
/// later cancellation, which is why [VerificationSubject.fromRecord] is false
/// and the screen says so.
VerificationSubject? subjectFromQr(Uri uri) {
  final p = uri.queryParameters;
  final no = p['ln'];
  if (no == null || no.isEmpty) return null;

  final kind =
      p['t'] == 'cert' ? DocumentKind.certificate : DocumentKind.licence;
  final on = tryParseIso(p['vu']);

  return VerificationSubject(
    kind: kind,
    no: no,
    title: p['bn'] ??
        (kind == DocumentKind.certificate ? 'সনদ' : 'ট্রেড লাইসেন্স'),
    ownerName: p['on'],
    ward: int.tryParse(p['w'] ?? ''),
    validUntil: kind == DocumentKind.licence ? on : null,
    issuedOn: kind == DocumentKind.certificate ? on : null,
    fromRecord: false,
  );
}

/// What a scanned code turned out to be.
///
/// The camera hands back a raw string and has no idea what it means. One of our
/// own QRs is a whole verify URL whose query string can stand in for a record
/// this device does not hold; anything else — a foreign QR, a code someone
/// wrote out by hand — is only a number to look up.
class ScannedCode {
  const ScannedCode({required this.number, this.verifyUrl});

  /// The number to search for.
  final String number;

  /// The URL, when the code was one of ours. Null means there is nothing to
  /// fall back on if the record is not on this device.
  final Uri? verifyUrl;

  bool get isOurs => verifyUrl != null;
}

/// Reads what the camera saw, or null when there is nothing usable in it.
ScannedCode? readScannedCode(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;

  final uri = Uri.tryParse(trimmed);
  final ln = uri?.queryParameters['ln'];
  if (uri != null && ln != null && ln.isNotEmpty) {
    return ScannedCode(number: ln, verifyUrl: uri);
  }

  // Not one of ours. Still worth looking up: a number reaching us this way is
  // no less real, and if nothing matches, "no record" is the honest answer.
  return ScannedCode(number: trimmed);
}

/// Bangla label for a verdict, as printed on the result card.
String verdictLabel(Verdict verdict, DocumentKind kind) =>
    switch ((verdict, kind)) {
      (Verdict.cancelled, DocumentKind.certificate) => 'বাতিল সনদ',
      (Verdict.cancelled, DocumentKind.licence) => 'বাতিল লাইসেন্স',
      (Verdict.valid, DocumentKind.certificate) => 'বৈধ সনদ',
      (Verdict.valid, DocumentKind.licence) => 'বৈধ লাইসেন্স',
      (Verdict.expired, _) => 'মেয়াদোত্তীর্ণ',
    };
