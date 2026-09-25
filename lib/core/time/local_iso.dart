/// Timestamps, deliberately local and deliberately not UTC.
///
/// The web demo stores local ISO strings with no `Z` suffix so that a record
/// created at 11pm does not read as the next calendar day, which would put it on
/// the wrong line of a register book and against the wrong day's collection
/// total. This port keeps that property.
///
/// The rule this file exists to enforce: **nothing anywhere calls `.toUtc()`**.
/// Every timestamp is produced and parsed here.
library;

/// Current local time. Injected in tests so seeded data is reproducible.
DateTime now() => DateTime.now();

/// Local ISO-8601 with no zone suffix, e.g. `2026-09-26T15:10:04.000`.
///
/// `DateTime.toIso8601String()` already omits the `Z` for a non-UTC value, so
/// this is mostly a named place to assert that intent.
String iso(DateTime d) {
  assert(!d.isUtc, 'Timestamps must stay local; see local_iso.dart');
  return d.toIso8601String();
}

/// Parses a local ISO string produced by [iso]. A string with no zone suffix
/// parses back as local, so the round-trip is lossless.
DateTime parseIso(String s) {
  final d = DateTime.parse(s);
  return d.isUtc ? d.toLocal() : d;
}

/// Same as [parseIso] but tolerant, for values that came from outside.
DateTime? tryParseIso(String? s) {
  if (s == null || s.isEmpty) return null;
  final d = DateTime.tryParse(s);
  if (d == null) return null;
  return d.isUtc ? d.toLocal() : d;
}

/// Midnight on the same local day. Used wherever a comparison is about calendar
/// days rather than instants — due dates, daily collection, register lines.
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Whole days between two local dates, ignoring the time of day.
int daysBetween(DateTime from, DateTime to) =>
    dateOnly(to).difference(dateOnly(from)).inDays;

/// Calendar-day shift. Goes through the `DateTime` constructor rather than
/// `add(Duration(days:))` so a DST transition cannot move the clock time.
DateTime shiftDays(DateTime d, int days) =>
    DateTime(d.year, d.month, d.day + days, d.hour, d.minute, d.second);

/// `true` when both instants fall on the same local calendar day.
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
