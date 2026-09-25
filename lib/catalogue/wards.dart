/// Wards and place names.
///
/// Bogura City Corporation has 21 wards. The area names are real; every
/// councillor name here is invented, as is every phone number.
library;

const wardCount = 21;

const wards = <int>[
  1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
  12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
];

/// Real Bogura neighbourhood names, used in addresses.
const areas = <String>[
  'সাতমাথা', 'ঠনঠনিয়া', 'জলেশ্বরীতলা', 'মালতিনগর',
  'চেলোপাড়া', 'সূত্রাপুর', 'নামাজগড়', 'কালিতলা',
  'বাদুড়তলা', 'ফুলবাড়ি', 'কামারগাড়ি', 'রহমাননগর',
];

/// The ward the demo councillor login is responsible for.
const councillorWard = 5;

class WardInfo {
  const WardInfo({
    required this.ward,
    required this.councillor,
    required this.officeHours,
    required this.mobile,
  });

  final int ward;
  final String councillor;

  /// Fictional office hours, shown on the citizen "my ward" page.
  final String officeHours;
  final String mobile;
}

const _officeHours = 'রবি–বৃহস্পতি, সকাল ১০টা – বিকাল ৫টা';

const _councillorNames = <String>[
  'মোঃ সাইফুল ইসলাম', 'রেহানা আক্তার', 'মোঃ কামরুল হাসান', 'শামসুন নাহার',
  'মোঃ দেলোয়ার হোসেন', 'আফরোজা খাতুন', 'মোঃ নুরুল আমিন', 'তাসলিমা বেগম',
  'মোঃ হাবিবুর রহমান', 'নাসরিন সুলতানা', 'মোঃ আব্দুল মালেক', 'রোকেয়া পারভীন',
  'মোঃ শহিদুল ইসলাম', 'ফরিদা ইয়াসমিন', 'মোঃ মিজানুর রহমান', 'সেলিনা আক্তার',
  'মোঃ আলমগীর কবির', 'মাহমুদা খানম', 'মোঃ রেজাউল করিম', 'শিরিন আক্তার',
  'মোঃ জাকির হোসেন',
];

final wardInfoList = <WardInfo>[
  for (final ward in wards)
    WardInfo(
      ward: ward,
      councillor: _councillorNames[ward - 1],
      officeHours: _officeHours,
      // Matches the web's construction exactly so the two demos show the same
      // (invented) numbers.
      mobile: '017${(10000000 + ward * 11111).toString().substring(0, 8)}',
    ),
];

WardInfo? wardInfo(int ward) {
  for (final w in wardInfoList) {
    if (w.ward == ward) return w;
  }
  return null;
}
