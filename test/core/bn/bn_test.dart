import 'package:bogcc_demo_mobile_app/core/bn/bn.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Expected values here were produced by running the original
/// `src/lib/bn.ts` from the web demo, not derived by hand. If one of these
/// fails after a change, the port has drifted from the web app and the two
/// demos will disagree on screen.
void main() {
  group('digits', () {
    test('converts ASCII to Bangla and leaves other characters alone', () {
      expect(toBnDigits(2026), '২০২৬');
      expect(toBnDigits('BOGCC-2026-000123'), 'BOGCC-২০২৬-০০০১২৩');
      expect(toBnDigits('কোনো সংখ্যা নেই'), 'কোনো সংখ্যা নেই');
    });

    test('converts Bangla back to ASCII', () {
      expect(bnToEnDigits('০১৭১২৩৪৫৬৭৮'), '01712345678');
      expect(bnToEnDigits('BOGCC-২০২৬-০০০১২৩'), 'BOGCC-2026-000123');
    });

    test('round-trips every integer it is given', () {
      // Property check: display then re-read must be the identity, because the
      // track screen accepts a pasted tracking number in either script.
      for (var n = 0; n < 2000; n++) {
        expect(bnToEnDigits(toBnDigits(n)), '$n');
      }
      expect(bnToEnDigits(toBnDigits(-98765)), '-98765');
    });

    test('detects Bangla numerals', () {
      expect(hasBnDigits('ওয়ার্ড ৫'), isTrue);
      expect(hasBnDigits('ward 5'), isFalse);
    });
  });

  group('numbers', () {
    test('groups the Indian way: last three, then twos', () {
      expect(groupIndian(0), '0');
      expect(groupIndian(999), '999');
      expect(groupIndian(1000), '1,000');
      expect(groupIndian(125000), '1,25,000');
      expect(groupIndian(10000000), '1,00,00,000');
      expect(groupIndian(123456789), '12,34,56,789');
    });

    test('formats taka', () {
      expect(formatTaka(125000), '৳১,২৫,০০০');
      expect(formatTaka(0), '৳০');
      expect(formatTaka(100), '৳১০০');
      expect(formatTaka(-500), '-৳৫০০');
    });

    test('keeps decimals but drops trailing zeros', () {
      // The Mayor's average-rating tile would otherwise read ৪ for 4.2.
      expect(formatDecimalBn(4.2), '৪.২');
      expect(formatDecimalBn(4.0), '৪');
      expect(formatDecimalBn(4.25, places: 2), '৪.২৫');
      expect(formatDecimalBn(1234.5), '১,২৩৪.৫');
    });
  });

  group('dates', () {
    final d = DateTime(2026, 9, 25, 15, 10);

    test('formats a Gregorian date in Bangla', () {
      expect(formatDateBn(d), '২৫ সেপ্টেম্বর ২০২৬');
    });

    test('uses parts of day rather than AM/PM', () {
      expect(formatTimeBn(d), 'বিকাল ৩:১০');
      expect(formatTimeBn(DateTime(2026, 1, 1, 9, 5)), 'সকাল ৯:০৫');
      expect(formatTimeBn(DateTime(2026, 1, 1, 0, 0)), 'রাত ১২:০০');
      expect(formatTimeBn(DateTime(2026, 1, 1, 12, 0)), 'দুপুর ১২:০০');
      expect(formatTimeBn(DateTime(2026, 1, 1, 5, 0)), 'ভোর ৫:০০');
      expect(formatTimeBn(DateTime(2026, 1, 1, 19, 0)), 'সন্ধ্যা ৭:০০');
    });

    test('formats date and time together', () {
      expect(formatDateTimeBn(d), '২৫ সেপ্টেম্বর ২০২৬, বিকাল ৩:১০');
    });
  });

  group('Bangla calendar', () {
    test('1 Boishakh is fixed to 14 April', () {
      expect(banglaCalendarDate(DateTime(2026, 4, 14)), '১ বৈশাখ ১৪৩৩ বঙ্গাব্দ');
    });

    test('13 April is still the previous Bangla year', () {
      // The boundary is the whole point of the helper: a record filed on the
      // 13th belongs to last year's book, one filed on the 14th to this year's.
      expect(
        banglaCalendarDate(DateTime(2026, 4, 13)),
        '৩০ চৈত্র ১৪৩২ বঙ্গাব্দ',
      );
    });

    test('converts a mid-year date', () {
      expect(
        banglaCalendarDate(DateTime(2026, 9, 25)),
        '১০ আশ্বিন ১৪৩৩ বঙ্গাব্দ',
      );
    });
  });

  group('amount in words', () {
    test('reads like a hand-filled receipt', () {
      expect(amountInWords(0), 'শূন্য টাকা মাত্র');
      expect(amountInWords(1500), 'এক হাজার পাঁচশত টাকা মাত্র');
      expect(amountInWords(100), 'একশত টাকা মাত্র');
      expect(amountInWords(125000), 'এক লক্ষ পঁচিশ হাজার টাকা মাত্র');
      expect(amountInWords(99), 'নিরানব্বই টাকা মাত্র');
    });

    test('recurses through crore', () {
      expect(
        amountInWords(123456789),
        'বারো কোটি চৌত্রিশ লক্ষ ছাপ্পান্ন হাজার সাতশত উননব্বই টাকা মাত্র',
      );
      expect(amountInWords(1000000), 'দশ লক্ষ টাকা মাত্র');
    });
  });

  group('relative time', () {
    final from = DateTime(2026, 9, 26, 12, 0);

    test('covers every branch', () {
      expect(timeAgoBn(from.add(const Duration(minutes: 5)), from: from), 'এখনই');
      expect(timeAgoBn(from.subtract(const Duration(seconds: 30)), from: from),
          'এইমাত্র');
      expect(timeAgoBn(from.subtract(const Duration(minutes: 5)), from: from),
          '৫ মিনিট আগে');
      expect(timeAgoBn(from.subtract(const Duration(hours: 3)), from: from),
          '৩ ঘণ্টা আগে');
      expect(timeAgoBn(from.subtract(const Duration(days: 4)), from: from),
          '৪ দিন আগে');
      expect(timeAgoBn(from.subtract(const Duration(days: 90)), from: from),
          '৩ মাস আগে');
      expect(timeAgoBn(from.subtract(const Duration(days: 800)), from: from),
          '২ বছর আগে');
    });
  });

  group('input formatters', () {
    TextEditingValue type(TextInputFormatter f, String text) => f.formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          ),
        );

    test('normalises a Bangla-typed mobile number to ASCII', () {
      expect(
        type(const BanglaDigitInputFormatter(), '০১৭১২৩৪৫৬৭৮').text,
        '01712345678',
      );
    });

    test('digits-only strips separators a user pastes in', () {
      expect(type(const DigitsOnlyInputFormatter(), '০১৭১-২৩৪৫৬৭').text,
          '0171234567');
      expect(type(const DigitsOnlyInputFormatter(), '01712 345678').text,
          '01712345678');
    });

    test('parses text that may be in either script', () {
      expect(parseIntBn('৫'), 5);
      expect(parseIntBn('21'), 21);
      expect(parseIntBn('ওয়ার্ড'), isNull);
      expect(parseDoubleBn('৪.৫'), 4.5);
    });
  });
}
