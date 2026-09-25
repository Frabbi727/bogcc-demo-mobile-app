/// Citizen charter — the service catalogue.
///
/// Defined once and read by both the office side and the Citizen Corner, so the
/// promised time, the fee and the step labels a citizen sees can never drift
/// from what the office actually does. All fees and times are DEMO values
/// (ডেমো হার).
library;

import '../domain/enums.dart';

class ServiceFee {
  const ServiceFee({required this.kind, required this.label, this.amount});

  final FeeKind kind;

  /// Set when [kind] is [FeeKind.fixed].
  final int? amount;

  /// Bangla description shown on the charter.
  final String label;
}

class ServiceDef {
  const ServiceDef({
    required this.key,
    required this.name,
    required this.description,
    required this.charterDays,
    required this.fee,
    required this.requiredDocs,
    required this.section,
    required this.statuses,
    required this.citizenLabels,
    required this.citizenFacing,
    this.registerKey,
    this.infoOnly = false,
    this.externalUrl,
  });

  final String key;
  final String name;
  final String description;

  /// Charter time in working days. 0 means over the counter, same day.
  final int charterDays;
  final ServiceFee fee;

  /// Documents the citizen must bring or attach.
  final List<String> requiredDocs;
  final String section;

  /// Internal status keys, in order. The first is set on creation.
  final List<String> statuses;

  /// Internal status key -> the label a citizen reads.
  final Map<String, String> citizenLabels;

  final bool citizenFacing;

  /// Registers handled by the config-driven engine link to their config here.
  final String? registerKey;

  /// Some services are not ours to deliver. The charter still lists them, but
  /// the page only explains where the citizen should go instead.
  final bool infoOnly;
  final String? externalUrl;
}

const services = <ServiceDef>[
  ServiceDef(
    key: 'tl-new',
    name: 'নতুন ট্রেড লাইসেন্স',
    description:
        'শহরে নতুন ব্যবসা শুরু করতে ট্রেড লাইসেন্স নিতে হয়। আবেদনের পর পরিদর্শক সরেজমিনে '
        'প্রতিষ্ঠান যাচাই করেন, এরপর অনুমোদন ও ফি পরিশোধের মাধ্যমে লাইসেন্স ইস্যু হয়।',
    charterDays: 7,
    fee: ServiceFee(
      kind: FeeKind.byBusinessType,
      label: 'ব্যবসার ধরন অনুযায়ী (ডেমো হার)',
    ),
    requiredDocs: [
      'জাতীয় পরিচয়পত্রের কপি',
      'দোকান/প্রতিষ্ঠানের ভাড়ার চুক্তিপত্র বা মালিকানার দলিল',
      'হোল্ডিং কর পরিশোধের সর্বশেষ রসিদ',
      'পাসপোর্ট সাইজের ছবি',
    ],
    section: 'রাজস্ব শাখা',
    statuses: ['submitted', 'verified', 'approved', 'issued'],
    citizenLabels: {
      'submitted': 'আবেদন গৃহীত',
      'verified': 'মাঠ পর্যায়ে যাচাই সম্পন্ন',
      'approved': 'অনুমোদিত, ফি পরিশোধ করুন',
      'issued': 'লাইসেন্স প্রস্তুত',
      'cancelled': 'বাতিল (কারণসহ)',
    },
    citizenFacing: true,
  ),
  ServiceDef(
    key: 'tl-renew',
    name: 'ট্রেড লাইসেন্স নবায়ন',
    description:
        'প্রতি অর্থবছরে ৩০ জুনের মধ্যে লাইসেন্স নবায়ন করতে হয়। পুরোনো লাইসেন্স নম্বর দিলে '
        'তথ্য আপনাআপনি চলে আসে; নতুন করে মাঠ যাচাইয়ের প্রয়োজন হয় না।',
    charterDays: 3,
    fee: ServiceFee(
      kind: FeeKind.byBusinessType,
      label: 'ব্যবসার ধরন অনুযায়ী; ৩০ সেপ্টেম্বরের পর ১০% বিলম্ব ফি (ডেমো)',
    ),
    requiredDocs: [
      'পুরোনো ট্রেড লাইসেন্সের কপি',
      'হোল্ডিং কর পরিশোধের সর্বশেষ রসিদ',
    ],
    section: 'রাজস্ব শাখা',
    statuses: ['submitted', 'verified', 'approved', 'issued'],
    citizenLabels: {
      'submitted': 'নবায়ন আবেদন গৃহীত',
      'verified': 'কাগজপত্র যাচাই সম্পন্ন',
      'approved': 'অনুমোদিত, ফি পরিশোধ করুন',
      'issued': 'নবায়নকৃত লাইসেন্স প্রস্তুত',
      'cancelled': 'বাতিল (কারণসহ)',
    },
    citizenFacing: true,
  ),
  ServiceDef(
    key: 'holding-pay',
    name: 'হোল্ডিং কর পরিশোধ',
    description:
        'হোল্ডিং নম্বর দিয়ে আপনার বার্ষিক ধার্যকৃত কর, পরিশোধিত অংশ ও বকেয়া দেখতে পারবেন '
        'এবং কিস্তি বা পূর্ণ অর্থ অনলাইনে পরিশোধ করতে পারবেন।',
    charterDays: 0,
    fee: ServiceFee(kind: FeeKind.asBilled, label: 'ধার্যকৃত দাবি অনুযায়ী'),
    requiredDocs: ['হোল্ডিং নম্বর'],
    section: 'রাজস্ব শাখা',
    statuses: ['submitted', 'paid'],
    citizenLabels: {
      'submitted': 'পরিশোধ শুরু হয়েছে',
      'paid': 'পরিশোধ সম্পন্ন, রসিদ প্রস্তুত',
    },
    citizenFacing: true,
  ),
  ServiceDef(
    key: 'streetlight',
    name: 'সড়কবাতি অভিযোগ',
    description:
        'রাস্তার বাতি নষ্ট, তার ছেঁড়া বা খুঁটি হেলে গেলে ছবি দিয়ে অভিযোগ করুন। '
        'বিদ্যুৎ শাখা মিস্ত্রি পাঠিয়ে মেরামত করবে।',
    charterDays: 3,
    fee: ServiceFee(kind: FeeKind.free, label: 'বিনামূল্যে'),
    requiredDocs: ['সমস্যার ছবি (থাকলে)', 'খুঁটি নম্বর বা রাস্তার নাম'],
    section: 'বিদ্যুৎ শাখা',
    statuses: ['received', 'assigned', 'repaired'],
    citizenLabels: {
      'received': 'অভিযোগ গৃহীত',
      'assigned': 'মিস্ত্রি পাঠানো হয়েছে',
      'repaired': 'সমস্যার সমাধান হয়েছে',
      'cancelled': 'বাতিল (কারণসহ)',
    },
    citizenFacing: true,
    registerKey: 'streetlight',
  ),
  ServiceDef(
    key: 'garbage',
    name: 'বর্জ্য / পরিচ্ছন্নতা অভিযোগ',
    description:
        'ময়লা জমে থাকা, ডাস্টবিন উপচে পড়া বা ড্রেন বন্ধ থাকলে অভিযোগ করুন। '
        'পরিচ্ছন্নতা শাখা দল পাঠিয়ে পরিষ্কার করবে।',
    charterDays: 2,
    fee: ServiceFee(kind: FeeKind.free, label: 'বিনামূল্যে'),
    requiredDocs: ['সমস্যার ছবি (থাকলে)', 'এলাকা বা ল্যান্ডমার্ক'],
    section: 'পরিচ্ছন্নতা শাখা',
    statuses: ['received', 'assigned', 'cleaned'],
    citizenLabels: {
      'received': 'অভিযোগ গৃহীত',
      'assigned': 'পরিচ্ছন্নতা দল পাঠানো হয়েছে',
      'cleaned': 'পরিষ্কার সম্পন্ন',
      'cancelled': 'বাতিল (কারণসহ)',
    },
    citizenFacing: true,
    registerKey: 'garbage',
  ),
  ServiceDef(
    key: 'cert-citizen',
    name: 'নাগরিকত্ব সনদ',
    description:
        'বগুড়া সিটি কর্পোরেশনের স্থায়ী বাসিন্দা হিসেবে নাগরিকত্ব সনদ। ফি পরিশোধের পর '
        'সংশ্লিষ্ট ওয়ার্ড কাউন্সিলর অনুমোদন দিলে সনদ প্রস্তুত হয়।',
    charterDays: 2,
    fee: ServiceFee(kind: FeeKind.fixed, amount: 100, label: '৳১০০ (ডেমো হার)'),
    requiredDocs: ['জাতীয় পরিচয়পত্রের কপি', 'হোল্ডিং কর পরিশোধের রসিদ'],
    section: 'সাধারণ শাখা',
    statuses: ['received', 'paid', 'approved', 'issued'],
    citizenLabels: {
      'received': 'আবেদন গৃহীত',
      'paid': 'ফি পরিশোধিত',
      'approved': 'কাউন্সিলর অনুমোদিত',
      'issued': 'সনদ প্রস্তুত',
      'cancelled': 'বাতিল (কারণসহ)',
    },
    citizenFacing: true,
    registerKey: 'cert-citizen',
  ),
  ServiceDef(
    key: 'cert-warish',
    name: 'ওয়ারিশ সনদ',
    description:
        'মৃত ব্যক্তির উত্তরাধিকারীদের তালিকাসহ ওয়ারিশ সনদ। আবেদনের তথ্য যাচাইয়ের পর '
        'ওয়ার্ড কাউন্সিলর অনুমোদন দেন।',
    charterDays: 7,
    fee: ServiceFee(kind: FeeKind.fixed, amount: 200, label: '৳২০০ (ডেমো হার)'),
    requiredDocs: [
      'মৃত্যু সনদের কপি',
      'আবেদনকারীর জাতীয় পরিচয়পত্র',
      'ওয়ারিশদের নাম, সম্পর্ক ও বয়সের তালিকা',
    ],
    section: 'সাধারণ শাখা',
    statuses: ['received', 'paid', 'verified', 'approved', 'issued'],
    citizenLabels: {
      'received': 'আবেদন গৃহীত',
      'paid': 'ফি পরিশোধিত',
      'verified': 'তথ্য যাচাই সম্পন্ন',
      'approved': 'কাউন্সিলর অনুমোদিত',
      'issued': 'সনদ প্রস্তুত',
      'cancelled': 'বাতিল (কারণসহ)',
    },
    citizenFacing: true,
    registerKey: 'cert-warish',
  ),
  ServiceDef(
    key: 'bdris',
    name: 'জন্ম ও মৃত্যু নিবন্ধন',
    description:
        'জন্ম ও মৃত্যু নিবন্ধন হয় সরকারের জাতীয় BDRIS সিস্টেমে, সিটি কর্পোরেশনের আলাদা '
        'রেজিস্টারে নয়। প্রকৃত ব্যবস্থায় কর্পোরেশন ১৭ ডিজিটের নিবন্ধন নম্বর ধরে একটি '
        'রেফারেন্স রেজিস্টার রাখবে, যাতে ট্রেড লাইসেন্স বা সনদের আবেদনে নিবন্ধন যাচাই করা যায়।',
    charterDays: 0,
    fee: ServiceFee(kind: FeeKind.asBilled, label: 'জাতীয় নির্ধারিত হার'),
    requiredDocs: ['জাতীয় BDRIS পোর্টালের নির্দেশনা অনুযায়ী'],
    section: 'জন্ম ও মৃত্যু নিবন্ধন শাখা',
    statuses: [],
    citizenLabels: {},
    citizenFacing: false,
    infoOnly: true,
    externalUrl: 'https://bdris.gov.bd',
  ),
];

ServiceDef? serviceOf(String? key) {
  if (key == null) return null;
  for (final s in services) {
    if (s.key == key) return s;
  }
  return null;
}

/// Services a citizen can actually apply for online.
final citizenServices = services.where((s) => s.citizenFacing).toList();

/// The citizen-facing label for an internal status.
/// Falls back to the raw key rather than showing nothing.
String citizenLabel(String serviceKey, String status) =>
    serviceOf(serviceKey)?.citizenLabels[status] ?? status;

/// Charter days for a service, used to compute the deadline.
int charterDaysOf(String serviceKey) => serviceOf(serviceKey)?.charterDays ?? 3;

/// The fixed fee for a service, or 0 when it is free or billed another way.
int fixedFeeOf(String serviceKey) {
  final fee = serviceOf(serviceKey)?.fee;
  return fee?.kind == FeeKind.fixed ? (fee?.amount ?? 0) : 0;
}
