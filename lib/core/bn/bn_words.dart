/// Bangla words for money amounts, as written on a hand-filled money receipt.
library;

const _unitsBn = [
  'শূন্য', 'এক', 'দুই', 'তিন', 'চার', 'পাঁচ', 'ছয়', 'সাত', 'আট', 'নয়',
  'দশ', 'এগারো', 'বারো', 'তেরো', 'চৌদ্দ', 'পনেরো', 'ষোলো', 'সতেরো', 'আঠারো', 'উনিশ',
  'বিশ', 'একুশ', 'বাইশ', 'তেইশ', 'চব্বিশ', 'পঁচিশ', 'ছাব্বিশ', 'সাতাশ', 'আঠাশ', 'উনত্রিশ',
  'ত্রিশ', 'একত্রিশ', 'বত্রিশ', 'তেত্রিশ', 'চৌত্রিশ', 'পঁয়ত্রিশ', 'ছত্রিশ', 'সাঁইত্রিশ', 'আটত্রিশ', 'উনচল্লিশ',
  'চল্লিশ', 'একচল্লিশ', 'বিয়াল্লিশ', 'তেতাল্লিশ', 'চুয়াল্লিশ', 'পঁয়তাল্লিশ', 'ছেচল্লিশ', 'সাতচল্লিশ', 'আটচল্লিশ', 'উনপঞ্চাশ',
  'পঞ্চাশ', 'একান্ন', 'বায়ান্ন', 'তিপ্পান্ন', 'চুয়ান্ন', 'পঞ্চান্ন', 'ছাপ্পান্ন', 'সাতান্ন', 'আটান্ন', 'উনষাট',
  'ষাট', 'একষট্টি', 'বাষট্টি', 'তেষট্টি', 'চৌষট্টি', 'পঁয়ষট্টি', 'ছেষট্টি', 'সাতষট্টি', 'আটষট্টি', 'উনসত্তর',
  'সত্তর', 'একাত্তর', 'বাহাত্তর', 'তিয়াত্তর', 'চুয়াত্তর', 'পঁচাত্তর', 'ছিয়াত্তর', 'সাতাত্তর', 'আটাত্তর', 'উনআশি',
  'আশি', 'একাশি', 'বিরাশি', 'তিরাশি', 'চুরাশি', 'পঁচাশি', 'ছিয়াশি', 'সাতাশি', 'আটাশি', 'উননব্বই',
  'নব্বই', 'একানব্বই', 'বিরানব্বই', 'তিরানব্বই', 'চুরানব্বই', 'পঁচানব্বই', 'ছিয়ানব্বই', 'সাতানব্বই', 'আটানব্বই', 'নিরানব্বই',
];

const _suffix = ' টাকা মাত্র';

/// Bangla words for a taka amount, e.g. `এক হাজার পাঁচশত টাকা মাত্র`.
///
/// Groups by কোটি / লক্ষ / হাজার / শত, the way the amount line on a paper money
/// receipt is filled in. Paisa are ignored: nothing in this system bills them.
String amountInWords(num n) {
  final whole = n.abs().truncate();
  if (whole == 0) return 'শূন্য$_suffix';

  final parts = <String>[];
  var rest = whole;

  final crore = rest ~/ 10000000;
  rest %= 10000000;
  final lakh = rest ~/ 100000;
  rest %= 100000;
  final thousand = rest ~/ 1000;
  rest %= 1000;
  final hundred = rest ~/ 100;
  final below = rest % 100;

  // Crore recurses, so ১২ কোটি and ১,২৩,৪৫,৬৭,৮৯০ both read correctly.
  if (crore > 0) {
    parts.add('${amountInWords(crore).replaceAll(_suffix, '')} কোটি');
  }
  if (lakh > 0) parts.add('${_unitsBn[lakh]} লক্ষ');
  if (thousand > 0) parts.add('${_unitsBn[thousand]} হাজার');
  if (hundred > 0) parts.add('${_unitsBn[hundred]}শত');
  if (below > 0) parts.add(_unitsBn[below]);

  final sign = n < 0 ? 'ঋণাত্মক ' : '';
  return '$sign${parts.join(' ')}$_suffix';
}
