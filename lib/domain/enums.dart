/// Closed sets from the domain model, ported from `src/types.ts`.
///
/// The Bangla labels live next to each enum rather than in a separate map,
/// because in this app the label *is* part of the domain: it appears on the
/// printed register line, and changing it changes what the book says.
library;

/// Every user of the system.
///
/// The ten office desks come straight from `src/data/users.ts`. [citizen] is the
/// addition the mobile app makes: on the web a citizen has no role at all, but
/// here one role config drives the whole shell, so the citizen needs a seat in
/// the same enum.
enum AppRole {
  citizen,
  operator,
  inspector,
  licenceOfficer,
  accounts,
  revenueOfficer,
  electrician,
  conservancy,
  councillor,
  ceo,
  mayor;

  bool get isOffice => this != AppRole.citizen;
}

/// Where a request came in from. Drives the অনলাইন badge and channel reports.
enum Channel { office, online }

enum LicenceStatus { submitted, verified, approved, issued, cancelled }

enum BusinessNature {
  single('একক'),
  partnership('অংশীদারি'),
  company('কোম্পানি');

  const BusinessNature(this.label);
  final String label;
}

/// How a service's fee is worked out.
enum FeeKind { free, fixed, byBusinessType, asBilled }

/// Counter collection modes.
enum PaymentMode {
  cash('নগদ'),
  bkash('বিকাশ'),
  bank('ব্যাংক');

  const PaymentMode(this.label);
  final String label;
}

/// Mock gateway methods. Neutral labels only — no official logos anywhere,
/// because this is a demo and must not imply a real integration.
enum OnlineMethod {
  bkash('bKash'),
  nagad('Nagad'),
  card('কার্ড');

  const OnlineMethod(this.label);
  final String label;
}

enum PaymentStatus { pending, paid, failed }

/// Revenue head, so the daily statement and the Mayor charts can group money.
enum RevenueHead {
  tradeLicence('ট্রেড লাইসেন্স'),
  holdingTax('হোল্ডিং কর'),
  certificate('সনদ'),
  other('অন্যান্য');

  const RevenueHead(this.label);
  final String label;
}

enum PropertyType {
  residential('আবাসিক'),
  commercial('বাণিজ্যিক'),
  mixed('মিশ্র');

  const PropertyType(this.label);
  final String label;
}

/// Complaint photos come in pairs: the problem, then the finished work.
enum PhotoKind { before, after }

/// Badge and status colour.
enum Tone { neutral, info, pending, success, danger }

/// What kind of record an audit line points at.
enum AuditRecordType {
  tradeLicence,
  registerEntry,
  receipt,
  payment,
  holding,
  notice,
  system,
}

/// The field types the config-driven register engine can render.
enum FieldType {
  text,
  number,
  date,
  ward,
  select,
  textarea,
  phone,
  nid,
  photo,
  heirs,
}
