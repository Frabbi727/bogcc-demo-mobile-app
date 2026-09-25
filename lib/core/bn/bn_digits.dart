/// Bangla numeral conversion.
///
/// The convention throughout the app: values are **stored** with ASCII digits
/// and **displayed** with Bangla ones. [toBnDigits] is the display half;
/// [bnToEnDigits] is the input half, so a keyboard that emits ০-৯ still produces
/// a value the rest of the code can parse.
library;

const _bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

/// Code unit of '০', the base of the contiguous Bangla digit block.
const _bnZero = 0x09E6;
const _asciiZero = 0x0030;

/// Converts every 0-9 to ০-৯ and leaves everything else alone.
String toBnDigits(Object value) {
  final s = value.toString();
  final out = StringBuffer();
  for (final unit in s.codeUnits) {
    if (unit >= _asciiZero && unit <= _asciiZero + 9) {
      out.write(_bnDigits[unit - _asciiZero]);
    } else {
      out.writeCharCode(unit);
    }
  }
  return out.toString();
}

/// Converts ০-৯ back to 0-9 and leaves everything else alone.
///
/// Every numeric input in the app runs through this before parsing: Android
/// keyboards disagree about which digits they emit, and `int.parse` on raw
/// controller text throws on a Bangla numeral.
String bnToEnDigits(String s) {
  final out = StringBuffer();
  for (final unit in s.codeUnits) {
    if (unit >= _bnZero && unit <= _bnZero + 9) {
      out.writeCharCode(_asciiZero + (unit - _bnZero));
    } else {
      out.writeCharCode(unit);
    }
  }
  return out.toString();
}

/// `true` when the string contains at least one Bangla numeral.
bool hasBnDigits(String s) =>
    s.codeUnits.any((u) => u >= _bnZero && u <= _bnZero + 9);
