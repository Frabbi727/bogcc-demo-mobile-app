import 'package:flutter/services.dart';

import 'bn_digits.dart';

/// Normalises Bangla numerals to ASCII as the user types.
///
/// Android keyboards disagree: Ridmik and Avro in Bangla mode emit ০-৯, while
/// Gboard's numeric row emits 0-9. Without this, half the province types a
/// mobile number the app cannot parse. Applying it at the input layer means
/// every stored value is ASCII and nothing downstream has to care.
class BanglaDigitInputFormatter extends TextInputFormatter {
  const BanglaDigitInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!hasBnDigits(newValue.text)) return newValue;
    // Bangla and ASCII digits are both one UTF-16 unit, so the selection offset
    // survives the substitution unchanged.
    return newValue.copyWith(text: bnToEnDigits(newValue.text));
  }
}

/// Keeps only digits, after normalising Bangla ones. For mobile, NID and
/// holding-number fields where a stray character is always a mistake.
class DigitsOnlyInputFormatter extends TextInputFormatter {
  const DigitsOnlyInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final ascii = bnToEnDigits(newValue.text);
    final digits = ascii.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits == newValue.text) return newValue;

    // Keep the caret where the user left it rather than snapping to the end,
    // which matters when correcting a digit in the middle of a mobile number.
    final removedBefore = ascii
        .substring(0, newValue.selection.baseOffset.clamp(0, ascii.length))
        .replaceAll(RegExp(r'[0-9]'), '')
        .length;
    final offset =
        (newValue.selection.baseOffset - removedBefore).clamp(0, digits.length);

    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}

/// Parses user-entered text that may contain Bangla numerals.
int? parseIntBn(String? s) =>
    s == null ? null : int.tryParse(bnToEnDigits(s).trim());

/// As [parseIntBn], for decimals.
double? parseDoubleBn(String? s) =>
    s == null ? null : double.tryParse(bnToEnDigits(s).trim());
