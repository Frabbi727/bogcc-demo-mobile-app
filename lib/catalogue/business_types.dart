/// Trade licence fee schedule.
///
/// These are DEMO rates (ডেমো হার), not the real gazetted schedule. A real
/// system reads them from a rate table an officer can edit per fiscal year.
library;

import '../domain/models/shared.dart';

class BusinessType {
  const BusinessType({
    required this.key,
    required this.label,
    required this.licenceFee,
    required this.signboardTax,
  });

  final String key;
  final String label;
  final int licenceFee;
  final int signboardTax;
}

const businessTypes = <BusinessType>[
  BusinessType(key: 'grocery', label: 'মুদি দোকান', licenceFee: 1200, signboardTax: 300),
  BusinessType(key: 'pharmacy', label: 'ঔষধের দোকান', licenceFee: 2500, signboardTax: 500),
  BusinessType(key: 'restaurant', label: 'রেস্তোরাঁ', licenceFee: 3500, signboardTax: 700),
  BusinessType(key: 'clothing', label: 'কাপড়ের দোকান', licenceFee: 1800, signboardTax: 400),
  BusinessType(key: 'electronics', label: 'ইলেকট্রনিক্স', licenceFee: 3000, signboardTax: 600),
  BusinessType(key: 'sweets', label: 'দই-মিষ্টির দোকান', licenceFee: 2000, signboardTax: 450),
  BusinessType(key: 'mobile-service', label: 'মোবাইল সার্ভিসিং', licenceFee: 1500, signboardTax: 350),
  BusinessType(key: 'workshop', label: 'ওয়ার্কশপ', licenceFee: 2200, signboardTax: 500),
  BusinessType(key: 'coaching', label: 'কোচিং সেন্টার', licenceFee: 2800, signboardTax: 550),
  BusinessType(key: 'wholesale', label: 'পাইকারি ব্যবসা', licenceFee: 5000, signboardTax: 900),
];

/// Fixed charge for the application form and the licence book.
const formAndBookFee = 200;

const vatRate = 0.15;

/// Demo late surcharge on a renewal filed after 30 September.
const renewalLateSurcharge = 0.1;

BusinessType businessTypeOf(String key) {
  for (final t in businessTypes) {
    if (t.key == key) return t;
  }
  return businessTypes.first;
}

int feeTotalOf(List<FeeLine> lines) =>
    lines.fold(0, (sum, l) => sum + l.amount);

/// The fee lines charged on a trade licence.
List<FeeLine> feeLinesFor(
  String typeKey, {
  bool renewal = false,
  bool late = false,
}) {
  final t = businessTypeOf(typeKey);
  return [
    FeeLine(label: 'লাইসেন্স ফি', amount: t.licenceFee),
    FeeLine(label: 'সাইনবোর্ড কর', amount: t.signboardTax),
    FeeLine(
      label: 'ভ্যাট (লাইসেন্স ফির ১৫%)',
      amount: (t.licenceFee * vatRate).round(),
    ),
    // A renewal reuses the existing licence book, so only a new licence is
    // charged for one.
    if (!renewal) const FeeLine(label: 'আবেদন ফরম ও বই মূল্য', amount: formAndBookFee),
    if (late)
      FeeLine(
        label: 'বিলম্ব ফি (১০%, ডেমো)',
        amount: (t.licenceFee * renewalLateSurcharge).round(),
      ),
  ];
}

/// True when a renewal for [fiscalYear] is being filed after 30 September.
bool isLateRenewal(String fiscalYear, DateTime at) {
  final cutoff =
      DateTime(int.parse(fiscalYear.substring(0, 4)), 9, 30, 23, 59, 59);
  return at.isAfter(cutoff);
}
