/// Office staff, one fictional person per role.
///
/// Office login is a role picker with no password — the point of the demo is
/// which desk does which step, not authentication. A real deployment replaces
/// this with proper accounts and per-section permissions.
library;

import '../domain/enums.dart';
import 'wards.dart';

class AppUser {
  const AppUser({
    required this.role,
    required this.name,
    required this.title,
    required this.designation,
    required this.hint,
    this.ward,
  });

  final AppRole role;
  final String name;
  final String title;
  final String designation;

  /// One line explaining the desk, shown on the role picker.
  final String hint;

  /// Set for the councillor, who only sees their own ward.
  final int? ward;
}

const users = <AppRole, AppUser>{
  AppRole.citizen: AppUser(
    role: AppRole.citizen,
    name: 'নাগরিক',
    title: 'নাগরিক',
    designation: 'বগুড়া সিটি কর্পোরেশন',
    hint: 'সেবার আবেদন, ট্র্যাকিং ও ফি পরিশোধ',
  ),
  AppRole.operator: AppUser(
    role: AppRole.operator,
    name: 'মোঃ রফিকুল ইসলাম',
    title: 'ডাটা এন্ট্রি অপারেটর',
    designation: 'রাজস্ব শাখা',
    hint: 'কাউন্টারে আবেদন ও রেজিস্টার এন্ট্রি করেন',
  ),
  AppRole.inspector: AppUser(
    role: AppRole.inspector,
    name: 'শাহানা পারভীন',
    title: 'লাইসেন্স পরিদর্শক',
    designation: 'রাজস্ব শাখা',
    hint: 'সরেজমিনে প্রতিষ্ঠান যাচাই করেন',
  ),
  AppRole.licenceOfficer: AppUser(
    role: AppRole.licenceOfficer,
    name: 'মোঃ আনিসুর রহমান',
    title: 'লাইসেন্স অফিসার',
    designation: 'রাজস্ব শাখা',
    hint: 'লাইসেন্স অনুমোদন দেন ও রেজিস্টার নম্বর বসান',
  ),
  AppRole.accounts: AppUser(
    role: AppRole.accounts,
    name: 'সুমন কুমার দাস',
    title: 'হিসাবরক্ষক / ক্যাশিয়ার',
    designation: 'হিসাব শাখা',
    hint: 'ফি আদায় করেন ও রসিদ দেন',
  ),
  AppRole.revenueOfficer: AppUser(
    role: AppRole.revenueOfficer,
    name: 'মোঃ তৌহিদুল ইসলাম',
    title: 'রাজস্ব কর্মকর্তা',
    designation: 'রাজস্ব শাখা',
    hint: 'হোল্ডিং করের দাবি ও আদায় দেখেন',
  ),
  AppRole.electrician: AppUser(
    role: AppRole.electrician,
    name: 'মোঃ জাহিদ হাসান',
    title: 'ইলেকট্রিশিয়ান',
    designation: 'বিদ্যুৎ শাখা',
    hint: 'সড়কবাতি মেরামত করেন',
  ),
  AppRole.conservancy: AppUser(
    role: AppRole.conservancy,
    name: 'নাজমা বেগম',
    title: 'পরিচ্ছন্নতা পরিদর্শক',
    designation: 'পরিচ্ছন্নতা শাখা',
    hint: 'বর্জ্য অভিযোগ ও গাড়ির ট্রিপ দেখেন',
  ),
  AppRole.councillor: AppUser(
    role: AppRole.councillor,
    name: 'মোঃ দেলোয়ার হোসেন',
    title: 'ওয়ার্ড কাউন্সিলর',
    designation: 'ওয়ার্ড $councillorWard',
    hint: 'নিজ ওয়ার্ডের সনদ অনুমোদন করেন',
    ward: councillorWard,
  ),
  AppRole.ceo: AppUser(
    role: AppRole.ceo,
    name: 'ড. মোস্তাফিজুর রহমান',
    title: 'প্রধান নির্বাহী কর্মকর্তা',
    designation: 'প্রধান কার্যালয়',
    hint: 'সার্বিক তত্ত্বাবধান, রিপোর্ট ও নোটিশ',
  ),
  AppRole.mayor: AppUser(
    role: AppRole.mayor,
    name: 'ইঞ্জিনিয়ার আব্দুল মোমেন',
    title: 'মেয়র / প্রশাসক',
    designation: 'বগুড়া সিটি কর্পোরেশন',
    hint: 'পুরো শহরের সেবা ও রাজস্বের চিত্র দেখেন',
  ),
};

/// Order of the office role picker: the workflow first, then oversight.
const officeRoleOrder = <AppRole>[
  AppRole.operator,
  AppRole.inspector,
  AppRole.licenceOfficer,
  AppRole.accounts,
  AppRole.revenueOfficer,
  AppRole.electrician,
  AppRole.conservancy,
  AppRole.councillor,
  AppRole.ceo,
  AppRole.mayor,
];

AppUser userFor(AppRole role) => users[role]!;

/// Short Bangla title for a role, used in timelines and handoff buttons.
String roleTitle(AppRole role) => users[role]!.title;
