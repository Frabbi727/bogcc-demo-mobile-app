import '../../domain/enums.dart';
import 'register_config.dart';

/// C7 — market shop rent collection.
///
/// A shop pays every month, so the real ledger is a demand-and-collection book
/// like holding tax. This engine holds one workflow per record, so the book is
/// kept the simple way the counter already writes it: one line = one shop, one
/// month. The line is raised with the month's rent, closed when accounts
/// collects it, and the outstanding column carries whatever was not paid.
const marketRentRegister = RegisterConfig(
  key: 'market-rent',
  title: 'মার্কেট দোকান ভাড়া রেজিস্টার',
  section: 'রাজস্ব শাখা',
  serialPrefix: 'MR',
  description: 'প্রতি মাসে প্রতি দোকানের ভাড়ার দাবি, আদায় ও বকেয়ার হিসাব — এক লাইনে এক মাস',
  dateField: 'createdAt',
  applicantFields: ApplicantFields(name: 'allottee', mobile: 'allotteeMobile'),
  createRoles: [AppRole.operator, AppRole.accounts, AppRole.revenueOfficer],
  cancelRoles: [AppRole.revenueOfficer, AppRole.ceo],
  totals: ['monthlyRent', 'collected', 'due'],
  steps: [
    RegisterStep(key: 'raised', label: 'ভাড়ার দাবি উত্থাপিত', citizenLabel: 'দাবি উত্থাপিত'),
    RegisterStep(
      key: 'collected',
      label: 'আদায় সম্পন্ন',
      citizenLabel: 'আদায় সম্পন্ন',
      actors: [AppRole.accounts],
      requiredFields: ['collected', 'collectedDate', 'receiptNo'],
    ),
    RegisterStep(
      key: 'verified',
      label: 'রাজস্ব কর্মকর্তা যাচাইকৃত',
      citizenLabel: 'যাচাইকৃত',
      actors: [AppRole.revenueOfficer],
    ),
  ],
  fields: [
    RegisterField(
      key: 'market',
      label: 'মার্কেটের নাম',
      type: FieldType.select,
      options: [
        'ফতেহ আলী বাজার মার্কেট',
        'সাতমাথা সুপার মার্কেট',
        'নিউ মার্কেট',
        'ঠনঠনিয়া হকার্স মার্কেট',
        'বড়গোলা মার্কেট',
      ],
      required: true,
      showInBook: true,
    ),
    RegisterField(key: 'shopNo', label: 'দোকান নং', type: FieldType.text, required: true, showInBook: true),
    RegisterField(key: 'allottee', label: 'বরাদ্দগ্রহীতার নাম', type: FieldType.text, required: true, showInBook: true),
    RegisterField(key: 'allotteeMobile', label: 'বরাদ্দগ্রহীতার মোবাইল', type: FieldType.phone, required: true),
    RegisterField(key: 'businessType', label: 'ব্যবসার ধরন', type: FieldType.text, showInBook: true),
    RegisterField(
      key: 'month',
      label: 'মাস',
      type: FieldType.select,
      options: [
        'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
        'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
      ],
      required: true,
      showInBook: true,
    ),
    RegisterField(key: 'monthlyRent', label: 'মাসিক ভাড়া (টাকা)', type: FieldType.number, required: true, showInBook: true),
    RegisterField(key: 'ward', label: 'ওয়ার্ড', type: FieldType.ward, required: true, showInBook: true),
    RegisterField(
      key: 'due',
      label: 'পূর্বের বকেয়া (টাকা)',
      type: FieldType.number,
      showInBook: true,
      hint: 'আগের মাস পর্যন্ত যা বাকি আছে',
    ),
    RegisterField(key: 'collected', label: 'আদায়কৃত (টাকা)', type: FieldType.number, showInBook: true, staffOnly: true),
    RegisterField(key: 'collectedDate', label: 'আদায়ের তারিখ', type: FieldType.date, showInBook: true, staffOnly: true),
    RegisterField(key: 'receiptNo', label: 'রসিদ নং', type: FieldType.text, showInBook: true, staffOnly: true),
  ],
);
