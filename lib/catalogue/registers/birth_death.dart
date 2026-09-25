import '../../domain/enums.dart';
import 'register_config.dart';

/// C6 — birth and death reference register.
///
/// Registration itself happens in the national BDRIS system, not here. The
/// corporation keeps this book so a 17-digit registration number quoted on a
/// trade licence or certificate application can be checked and the check
/// recorded. Office-only: a citizen never files one of these lines.
const birthDeathRegister = RegisterConfig(
  key: 'birth-death',
  title: 'জন্ম-মৃত্যু রেফারেন্স রেজিস্টার',
  section: 'জন্ম ও মৃত্যু নিবন্ধন শাখা',
  serialPrefix: 'BD',
  description: 'BDRIS নিবন্ধন নম্বর যাচাইয়ের দৈনিক হিসাব — কোন কাজে কার নিবন্ধন দেখা হয়েছে',
  dateField: 'verifyDate',
  createRoles: [AppRole.operator, AppRole.licenceOfficer],
  cancelRoles: [AppRole.licenceOfficer, AppRole.ceo],
  steps: [
    RegisterStep(key: 'entry', label: 'এন্ট্রি', citizenLabel: 'এন্ট্রি'),
    RegisterStep(
      key: 'verified',
      label: 'BDRIS-এ যাচাইকৃত',
      citizenLabel: 'যাচাইকৃত',
      actors: [AppRole.operator, AppRole.licenceOfficer],
      requiredFields: ['matchResult'],
    ),
  ],
  fields: [
    RegisterField(key: 'verifyDate', label: 'যাচাইয়ের তারিখ', type: FieldType.date, required: true, showInBook: true),
    RegisterField(
      key: 'regNo',
      label: 'নিবন্ধন নং (১৭ ডিজিট)',
      type: FieldType.text,
      required: true,
      showInBook: true,
      hint: 'BDRIS সনদে ছাপানো ১৭ সংখ্যার নম্বর',
    ),
    RegisterField(
      key: 'eventType',
      label: 'ধরন',
      type: FieldType.select,
      options: ['জন্ম', 'মৃত্যু'],
      required: true,
      showInBook: true,
    ),
    RegisterField(key: 'name', label: 'নাম', type: FieldType.text, required: true, showInBook: true),
    RegisterField(key: 'fatherName', label: 'পিতার নাম', type: FieldType.text, showInBook: true),
    RegisterField(key: 'motherName', label: 'মাতার নাম', type: FieldType.text),
    RegisterField(key: 'eventDate', label: 'জন্ম / মৃত্যুর তারিখ', type: FieldType.date, required: true, showInBook: true),
    RegisterField(key: 'ward', label: 'ওয়ার্ড', type: FieldType.ward, required: true, showInBook: true),
    RegisterField(
      key: 'usedFor',
      label: 'যে কাজে ব্যবহৃত',
      type: FieldType.select,
      options: ['ট্রেড লাইসেন্স', 'নাগরিকত্ব সনদ', 'ওয়ারিশ সনদ', 'হোল্ডিং কর', 'অন্যান্য'],
      required: true,
      showInBook: true,
    ),
    RegisterField(
      key: 'matchResult',
      label: 'যাচাইয়ের ফল',
      type: FieldType.select,
      options: ['তথ্য মিলেছে', 'তথ্য মেলেনি', 'নিবন্ধন পাওয়া যায়নি'],
      showInBook: true,
      staffOnly: true,
    ),
    RegisterField(key: 'remarks', label: 'মন্তব্য', type: FieldType.textarea, staffOnly: true),
  ],
);
