import '../time/local_iso.dart';
import 'bn_digits.dart';

const _gregorianMonthsBn = [
  'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
  'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
];

/// e.g. `২৫ সেপ্টেম্বর ২০২৬`
String formatDateBn(DateTime d) =>
    '${toBnDigits(d.day)} ${_gregorianMonthsBn[d.month - 1]} ${toBnDigits(d.year)}';

/// Bangla name for the part of day a 24-hour clock hour falls in. Bangla has no
/// AM/PM; a receipt reads `বিকাল ৩:১০`, never `3:10 PM`.
String dayPartBn(int hour24) {
  if (hour24 >= 4 && hour24 < 6) return 'ভোর';
  if (hour24 >= 6 && hour24 < 12) return 'সকাল';
  if (hour24 >= 12 && hour24 < 15) return 'দুপুর';
  if (hour24 >= 15 && hour24 < 18) return 'বিকাল';
  if (hour24 >= 18 && hour24 < 20) return 'সন্ধ্যা';
  return 'রাত';
}

/// e.g. `বিকাল ৩:১০`
String formatTimeBn(DateTime d) {
  final h12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final mm = d.minute.toString().padLeft(2, '0');
  return '${dayPartBn(d.hour)} ${toBnDigits(h12)}:${toBnDigits(mm)}';
}

/// e.g. `২৫ সেপ্টেম্বর ২০২৬, বিকাল ৩:১০`
String formatDateTimeBn(DateTime d) => '${formatDateBn(d)}, ${formatTimeBn(d)}';

/* ---------- Revised Bangladesh calendar ---------- */

const _banglaMonths = [
  'বৈশাখ', 'জ্যৈষ্ঠ', 'আষাঢ়', 'শ্রাবণ', 'ভাদ্র', 'আশ্বিন',
  'কার্তিক', 'অগ্রহায়ণ', 'পৌষ', 'মাঘ', 'ফাল্গুন', 'চৈত্র',
];

bool _isLeapYear(int y) => (y % 4 == 0 && y % 100 != 0) || y % 400 == 0;

/// Day count of each Bangla month for a Bangla year beginning in [startYear].
List<int> _banglaMonthLengths(int startYear) {
  // Falgun of this Bangla year falls in the Gregorian year after 14 April, so
  // its length is decided by the *next* Gregorian year's leap status.
  final falgun = _isLeapYear(startYear + 1) ? 30 : 29;
  return [31, 31, 31, 31, 31, 31, 30, 30, 30, 30, falgun, 30];
}

/// Days since the epoch for a calendar date, via UTC so no zone offset or DST
/// transition can shift the count. This is arithmetic on calendar days, not an
/// instant, so using UTC here does not violate the local-time rule.
int _dayNumber(int y, int m, int d) =>
    DateTime.utc(y, m, d).millisecondsSinceEpoch ~/ 86400000;

/// Revised Bangladesh calendar date, e.g. `১০ আশ্বিন ১৪৩৩ বঙ্গাব্দ`.
/// 1 Boishakh is fixed to 14 April.
String banglaCalendarDate(DateTime date) {
  final gy = date.year;
  final today = _dayNumber(gy, date.month, date.day);
  final newYearThisYear = _dayNumber(gy, 4, 14);

  // Before 14 April we are still in the Bangla year that began last April.
  final startYear = today >= newYearThisYear ? gy : gy - 1;
  final banglaYear = startYear - 593;
  var offset = today - _dayNumber(startYear, 4, 14);

  final lengths = _banglaMonthLengths(startYear);
  var monthIndex = 0;
  while (monthIndex < 11 && offset >= lengths[monthIndex]) {
    offset -= lengths[monthIndex];
    monthIndex += 1;
  }

  return '${toBnDigits(offset + 1)} ${_banglaMonths[monthIndex]} '
      '${toBnDigits(banglaYear)} বঙ্গাব্দ';
}

/* ---------- Relative time ---------- */

/// Coarse relative time, e.g. `৫ মিনিট আগে`.
///
/// Used on activity feeds where how fresh a line is matters more than its exact
/// timestamp. Months are approximated at 30 days, as on the web.
String timeAgoBn(DateTime then, {DateTime? from}) {
  final diff = (from ?? now()).difference(then);
  if (diff.isNegative) return 'এখনই';
  if (diff.inMinutes < 1) return 'এইমাত্র';
  if (diff.inHours < 1) return '${toBnDigits(diff.inMinutes)} মিনিট আগে';
  if (diff.inDays < 1) return '${toBnDigits(diff.inHours)} ঘণ্টা আগে';

  final days = diff.inDays;
  if (days < 30) return '${toBnDigits(days)} দিন আগে';
  final months = days ~/ 30;
  if (months < 12) return '${toBnDigits(months)} মাস আগে';
  return '${toBnDigits(months ~/ 12)} বছর আগে';
}
