/// Per-register field values for seeded entries.
///
/// Each register gets data that looks like what that desk actually writes, so
/// a register book on screen reads like the paper one rather than like filler.
library;

import '../../catalogue/names.dart';
import '../../catalogue/wards.dart';
import '../../core/random/seeded_rng.dart';
import '../../core/time/local_iso.dart';
import '../../domain/models/shared.dart';

String _pad(int n, [int w = 2]) => n.toString().padLeft(w, '0');

String _dateOnly(DateTime d) => '${d.year}-${_pad(d.month)}-${_pad(d.day)}';

const _bnMonths = [
  'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
  'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
];

class EntryContext {
  const EntryContext({
    required this.ward,
    required this.applicantName,
    required this.applicantMobile,
    required this.createdAt,
  });

  final int ward;
  final String applicantName;
  final String applicantMobile;
  final DateTime createdAt;
}

/// The data map for a new seeded entry in [registerKey].
Map<String, dynamic> buildEntryData(
  SeededRng rng,
  String registerKey,
  EntryContext ctx,
) {
  final area = rng.pick(areas);
  final road = rng.pick(roads);

  switch (registerKey) {
    case 'streetlight':
      return {
        'poleNo': rng.chance(0.75)
            ? 'P-${ctx.ward}-${rng.int_(100, 999)}'
            : '',
        'ward': ctx.ward,
        'road': '$road, $area',
        // Weighted: a dead lamp is by far the commonest complaint.
        'faultType': rng.pick(
          ['বাতি নষ্ট', 'বাতি নষ্ট', 'তার ছেঁড়া', 'খুঁটি হেলে গেছে', 'সুইচ নষ্ট'],
        ),
        'description':
            rng.chance(0.5) ? 'রাতে পুরো এলাকা অন্ধকার থাকে।' : '',
        'complainant': ctx.applicantName,
        'complainantMobile': ctx.applicantMobile,
      };

    case 'garbage':
      return {
        'ward': ctx.ward,
        'landmark': '$road সংলগ্ন, $area',
        'problemType': rng.pick(
          ['ময়লা জমে আছে', 'ডাস্টবিন উপচে পড়ছে', 'ড্রেন বন্ধ', 'মৃত প্রাণী'],
        ),
        'description':
            rng.chance(0.5) ? 'দুর্গন্ধে চলাচল করা কঠিন হয়ে পড়েছে।' : '',
        'complainant': ctx.applicantName,
        'complainantMobile': ctx.applicantMobile,
      };

    case 'garbage-trips':
      return {
        'tripDate': _dateOnly(ctx.createdAt),
        'vehicleNo': rng.pick(vehicles),
        'driver': rng.pick(drivers),
        'ward': ctx.ward,
        'route': '$area — $road',
        'trips': rng.int_(2, 6),
        'dumpSite':
            rng.pick(['ঠনঠনিয়া ডাম্পিং', 'নামুজা ডাম্পিং', 'ফুলবাড়ি ডাম্পিং']),
        'fuel': rng.int_(8, 22),
        'supervisor': rng.pick(supervisors),
      };

    case 'cert-citizen':
      return {
        'name': ctx.applicantName,
        'fatherName': rng.pick(fatherNames),
        'motherName': rng.pick(motherNames),
        'dob': '${rng.int_(1960, 2005)}-${_pad(rng.int_(1, 12))}-'
            '${_pad(rng.int_(1, 28))}',
        'nid': '${rng.int_(1000000000, 9999999999)}',
        'address': '$road, $area',
        'ward': ctx.ward,
        'mobile': ctx.applicantMobile,
      };

    case 'cert-warish':
      return {
        'deceasedName': rng.pick(maleNames),
        'deathDate': _dateOnly(shiftDays(ctx.createdAt, -rng.int_(30, 400))),
        'applicantName': ctx.applicantName,
        'relation': rng.pick(['পুত্র', 'কন্যা', 'স্ত্রী']),
        'address': '$road, $area',
        'ward': ctx.ward,
        'mobile': ctx.applicantMobile,
        'heirs': [for (final h in _buildHeirs(rng)) h.toJson()],
      };

    case 'market-rent':
      final rent = rng.int_(12, 45) * 500;
      return {
        'market': rng.pick(markets),
        'shopNo': '${rng.pick(['A', 'B', 'C', 'D'])}-${rng.int_(1, 48)}',
        'allottee': ctx.applicantName,
        'allotteeMobile': ctx.applicantMobile,
        'businessType': rng.pick(shopTrades),
        'month': _bnMonths[ctx.createdAt.month - 1],
        'monthlyRent': rent,
        'ward': ctx.ward,
        // Most shops start the month clear; a few carry an arrear forward.
        'due': rng.chance(0.25) ? rent * rng.int_(1, 3) : 0,
      };

    case 'rickshaw-licence':
      final vehicleType =
          rng.pick(['রিকশা', 'রিকশা', 'ভ্যান', 'ইজিবাইক', 'ঠেলাগাড়ি']);
      return {
        'vehicleType': vehicleType,
        'ownerName': ctx.applicantName,
        'ownerMobile': ctx.applicantMobile,
        'ownerNid': '${rng.int_(1000000000, 9999999999)}',
        'driverName':
            rng.chance(0.6) ? rng.pick(maleNames) : ctx.applicantName,
        'address': '$road, $area',
        'ward': ctx.ward,
        'fee': switch (vehicleType) {
          'ইজিবাইক' => 1500,
          'ভ্যান' => 800,
          _ => 500,
        },
        'applicationKind': rng.chance(0.55) ? 'নবায়ন' : 'নতুন',
      };

    case 'building-plan':
      final buildingUse =
          rng.pick(['আবাসিক', 'আবাসিক', 'বাণিজ্যিক', 'মিশ্র', 'শিল্প']);
      final floors =
          buildingUse == 'আবাসিক' ? rng.int_(1, 5) : rng.int_(2, 8);
      return {
        'applicationDate': _dateOnly(ctx.createdAt),
        'applicantName': ctx.applicantName,
        'applicantMobile': ctx.applicantMobile,
        'holdingNo': '${ctx.ward}/${rng.int_(100, 999)}',
        'ward': ctx.ward,
        'landArea': rng.int_(3, 20),
        'floors': floors,
        'buildingUse': buildingUse,
        'designerName': rng.pick(designers),
        'fee': floors * rng.int_(2, 4) * 1000,
      };

    case 'birth-death':
      final eventType = rng.chance(0.72) ? 'জন্ম' : 'মৃত্যু';
      final year =
          eventType == 'জন্ম' ? rng.int_(1985, 2024) : rng.int_(2015, 2025);
      return {
        'verifyDate': _dateOnly(ctx.createdAt),
        // BDRIS numbers are 17 digits: a 4-digit year then 13 more.
        'regNo': '$year${rng.int_(1000000000000, 9999999999999)}',
        'eventType': eventType,
        'name': rng.chance(0.4) ? rng.pick(femaleNames) : rng.pick(maleNames),
        'fatherName': rng.pick(fatherNames),
        'motherName': rng.pick(motherNames),
        'eventDate':
            '$year-${_pad(rng.int_(1, 12))}-${_pad(rng.int_(1, 28))}',
        'ward': ctx.ward,
        'usedFor': rng.pick(
          ['ট্রেড লাইসেন্স', 'নাগরিকত্ব সনদ', 'ওয়ারিশ সনদ', 'হোল্ডিং কর', 'অন্যান্য'],
        ),
      };

    default:
      return {'ward': ctx.ward};
  }
}

/// A plausible heirs list.
///
/// A person has one widow and one mother, so those relations are drawn at most
/// once; sons, daughters and siblings may repeat.
List<Heir> _buildHeirs(SeededRng rng) {
  const singular = {'স্ত্রী', 'মাতা'};
  final target = rng.int_(2, 5);
  final used = <String>{};
  final heirs = <Heir>[];

  // Bounded rather than `while (heirs.length < target)`: with only two singular
  // relations available a naive loop can spin forever on an unlucky stream.
  for (var attempt = 0; attempt < 60 && heirs.length < target; attempt++) {
    final relation = rng.pick(heirRelations);
    if (singular.contains(relation) && used.contains(relation)) continue;
    used.add(relation);
    final female = relation == 'স্ত্রী' ||
        relation == 'মাতা' ||
        relation == 'কন্যা' ||
        relation == 'বোন';
    heirs.add(
      Heir(
        name: female ? rng.pick(femaleNames) : rng.pick(maleNames),
        relation: relation,
        age: switch (relation) {
          'মাতা' => rng.int_(55, 80),
          'স্ত্রী' => rng.int_(35, 65),
          _ => rng.int_(18, 50),
        },
      ),
    );
  }
  return heirs;
}

/// Values staff write into a register at the step that asks for them.
Object staffFieldValue(
  SeededRng rng,
  String key,
  DateTime at,
  Map<String, dynamic> data,
) {
  switch (key) {
    case 'technician':
      return rng.pick(technicians);
    case 'materials':
      return rng.pick(materials);
    case 'team':
      return rng.pick(cleaningTeams);
    case 'repairDate':
    case 'resolvedDate':
    case 'collectedDate':
    case 'issueDate':
    case 'inspectionDate':
    case 'approvalDate':
      return _dateOnly(at);
    case 'verifyNote':
      return 'ওয়ারিশদের তালিকা যাচাই করা হয়েছে; তথ্য সঠিক পাওয়া গেছে।';
    case 'receiptNo':
    case 'moneyReceiptNo':
      return 'R-${rng.int_(1000, 9999)}';
    case 'collected':
      // Most shopkeepers clear the month in full; a few pay part of it.
      final rent = (data['monthlyRent'] as num?)?.toInt() ?? 0;
      return rng.chance(0.78)
          ? rent
          : (rent * rng.int_(40, 80) / 100 / 10).round() * 10;
    case 'plateNo':
      final prefix = switch (data['vehicleType']) {
        'ইজিবাইক' => 'EB',
        'ভ্যান' => 'VN',
        _ => 'RK',
      };
      return '$prefix-${rng.int_(1000, 9999)}';
    case 'renewDate':
      // A licence runs for one year from the day it is issued.
      return _dateOnly(DateTime(at.year + 1, at.month, at.day));
    case 'matchResult':
      return rng.chance(0.88)
          ? 'তথ্য মিলেছে'
          : rng.pick(['তথ্য মেলেনি', 'নিবন্ধন পাওয়া যায়নি']);
    case 'inspectionNote':
      return rng.pick([
        'সরেজমিনে পরিদর্শন করা হইয়াছে; নকশা অনুযায়ী জমির পরিমাণ ও সেটব্যাক সঠিক পাওয়া গিয়াছে।',
        'পরিদর্শনে দেখা যায় পার্শ্ববর্তী রাস্তার প্রস্থ পর্যাপ্ত; নির্মাণে আপত্তি নাই।',
        'নকশায় উল্লিখিত তলা সংখ্যার সহিত জমির পরিমাণ সঙ্গতিপূর্ণ পাওয়া গিয়াছে।',
      ]);
    default:
      return '';
  }
}

/// Wards differ noticeably so the Mayor's ward map has contrast rather than a
/// flat wash of one colour. A few wards deliberately carry more complaints.
int pickWardWithContrast(SeededRng rng, String registerKey) {
  const busy = [3, 5, 6, 11, 14];
  if ((registerKey == 'streetlight' || registerKey == 'garbage') &&
      rng.chance(0.45)) {
    return rng.pick(busy);
  }
  return rng.pick(wards);
}

/// A step's note, where the desk would actually write one.
String? stepNote(SeededRng rng, String registerKey, String stepKey) {
  if (registerKey == 'streetlight') {
    if (stepKey == 'assigned') {
      return 'মিস্ত্রি নিযুক্ত করা হয়েছে; আগামীকাল ঘটনাস্থলে যাবেন।';
    }
    if (stepKey == 'repaired') return 'বাতি মেরামত করে চালু করা হয়েছে।';
  }
  if (registerKey == 'garbage') {
    if (stepKey == 'assigned') return 'পরিচ্ছন্নতা দল পাঠানো হয়েছে।';
    if (stepKey == 'cleaned') return 'এলাকা পরিষ্কার করা হয়েছে।';
  }
  if (registerKey == 'cert-warish' && stepKey == 'verified') {
    return 'ওয়ারিশদের তালিকা স্থানীয়ভাবে যাচাই করা হয়েছে।';
  }
  if (stepKey == 'approved') return 'কাউন্সিলর অনুমোদন দিয়েছেন।';
  if (stepKey == 'issued') return 'সনদ প্রস্তুত, আবেদনকারীকে জানানো হয়েছে।';
  return rng.chance(0.3) ? 'কার্যক্রম চলমান।' : null;
}
