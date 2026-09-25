/// Fiscal year helpers. The Bangladesh government fiscal year runs July to
/// June, and register serials restart at 1 each fiscal year — which is what
/// makes the fiscal year part of nearly every identifier in the system.
library;

import '../../core/time/local_iso.dart';

/// e.g. `2026-27` for any date inside that fiscal year.
String fiscalYearOf(DateTime d) {
  // July is month 7 in Dart, where the TypeScript original compares against
  // month index 6. Same boundary, different numbering.
  final start = d.month >= 7 ? d.year : d.year - 1;
  final end = ((start + 1) % 100).toString().padLeft(2, '0');
  return '$start-$end';
}

/// The fiscal year containing today.
String currentFiscalYear() => fiscalYearOf(now());

/// First day of a fiscal year: 1 July of its start year.
DateTime fiscalYearStart(String fy) =>
    DateTime(int.parse(fy.substring(0, 4)), 7, 1);

/// End of the fiscal year: 30 June of the following year. A trade licence is
/// valid until this date whatever month it was issued in.
DateTime validUntil(String fy) =>
    DateTime(int.parse(fy.substring(0, 4)) + 1, 6, 30);

/// Descending list of fiscal years, for filter dropdowns.
List<String> fiscalYearOptions({int count = 3}) {
  final startYear = int.parse(currentFiscalYear().substring(0, 4));
  return List.generate(count, (i) {
    final s = startYear - i;
    return '$s-${((s + 1) % 100).toString().padLeft(2, '0')}';
  });
}
