import 'bn_digits.dart';

/// Indian digit grouping: 125000 -> "1,25,000".
///
/// The last three digits group as one, then every two after that — which is why
/// this cannot be done with a plain `NumberFormat` thousands separator.
String groupIndian(num n) {
  final s = n.abs().truncate().toString();
  if (s.length <= 3) return s;

  final head = s.substring(0, s.length - 3);
  final tail = s.substring(s.length - 3);

  // Walk the head right-to-left inserting a comma every two digits.
  final buffer = StringBuffer();
  for (var i = 0; i < head.length; i++) {
    final fromRight = head.length - i;
    if (i > 0 && fromRight.isEven) buffer.write(',');
    buffer.write(head[i]);
  }
  return '$buffer,$tail';
}

/// Money, e.g. `৳১,২৫,০০০`.
String formatTaka(num n) {
  final sign = n < 0 ? '-' : '';
  return '$sign৳${toBnDigits(groupIndian(n))}';
}

/// Plain grouped number in Bangla digits, no currency symbol.
String formatNumberBn(num n) => toBnDigits(groupIndian(n));

/// A number that keeps its decimals, e.g. `৪.২`.
///
/// Averages and ratings would otherwise be truncated to whole numbers by the
/// grouping helpers. Trailing zeros are dropped, so 4.0 still reads `৪`.
String formatDecimalBn(num n, {int places = 1}) {
  final sign = n < 0 ? '-' : '';
  final abs = n.abs();
  final fixed = abs.toStringAsFixed(places);
  final dot = fixed.indexOf('.');
  final whole = dot == -1 ? fixed : fixed.substring(0, dot);
  var decimals = dot == -1 ? '' : fixed.substring(dot + 1);

  while (decimals.endsWith('0')) {
    decimals = decimals.substring(0, decimals.length - 1);
  }

  final grouped = groupIndian(int.parse(whole));
  return sign + toBnDigits(decimals.isEmpty ? grouped : '$grouped.$decimals');
}
