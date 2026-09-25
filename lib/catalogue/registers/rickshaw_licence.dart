import '../../domain/enums.dart';
import 'register_config.dart';

/// C8 — rickshaw, van and easy-bike licences.
///
/// Same shape as a trade licence, with a number plate allotted at approval and a
/// yearly renewal date carried on the line. Office-only for now: the counter
/// takes the application, the licence officer allots the plate.
const rickshawLicenceRegister = RegisterConfig(
  key: 'rickshaw-licence',
  title: 'রিকশা / ভ্যান লাইসেন্স রেজিস্টার',
  section: 'লাইসেন্স শাখা',
  serialPrefix: 'RL',
  description: 'রিকশা, ভ্যান ও ইজিবাইকের লাইসেন্স, প্লেট বরাদ্দ ও বার্ষিক নবায়নের হিসাব',
  printable: true,
  dateField: 'createdAt',
  applicantFields: ApplicantFields(name: 'ownerName', mobile: 'ownerMobile'),
  createRoles: [AppRole.operator, AppRole.licenceOfficer],
  cancelRoles: [AppRole.licenceOfficer, AppRole.ceo],
  totals: ['fee'],
  steps: [
    RegisterStep(key: 'received', label: 'আবেদন গৃহীত', citizenLabel: 'আবেদন গৃহীত'),
    RegisterStep(
      key: 'feePaid',
      label: 'ফি জমা',
      citizenLabel: 'ফি জমা',
      actors: [AppRole.accounts],
      requiredFields: ['moneyReceiptNo'],
    ),
    RegisterStep(
      key: 'approved',
      label: 'প্লেট বরাদ্দ ও অনুমোদন',
      citizenLabel: 'অনুমোদিত',
      actors: [AppRole.licenceOfficer],
      requiredFields: ['plateNo'],
    ),
    RegisterStep(
      key: 'issued',
      label: 'লাইসেন্স ইস্যুকৃত',
      citizenLabel: 'লাইসেন্স প্রস্তুত',
      actors: [AppRole.operator, AppRole.licenceOfficer],
      requiredFields: ['issueDate', 'renewDate'],
    ),
  ],
  fields: [
    RegisterField(
      key: 'vehicleType',
      label: 'যানবাহনের ধরন',
      type: FieldType.select,
      options: ['রিকশা', 'ভ্যান', 'ইজিবাইক', 'ঠেলাগাড়ি'],
      required: true,
      showInBook: true,
    ),
    RegisterField(key: 'ownerName', label: 'মালিকের নাম', type: FieldType.text, required: true, showInBook: true),
    RegisterField(key: 'ownerMobile', label: 'মালিকের মোবাইল', type: FieldType.phone, required: true),
    RegisterField(key: 'ownerNid', label: 'মালিকের জাতীয় পরিচয়পত্র নং', type: FieldType.nid),
    RegisterField(key: 'driverName', label: 'চালকের নাম', type: FieldType.text, showInBook: true),
    RegisterField(key: 'address', label: 'ঠিকানা', type: FieldType.text, required: true, showInBook: true),
    RegisterField(key: 'ward', label: 'ওয়ার্ড', type: FieldType.ward, required: true, showInBook: true),
    RegisterField(key: 'fee', label: 'ফি (টাকা)', type: FieldType.number, required: true, showInBook: true),
    RegisterField(
      key: 'applicationKind',
      label: 'আবেদনের ধরন',
      type: FieldType.select,
      options: ['নতুন', 'নবায়ন'],
      required: true,
      showInBook: true,
    ),
    RegisterField(key: 'moneyReceiptNo', label: 'রসিদ নং', type: FieldType.text, staffOnly: true),
    RegisterField(key: 'plateNo', label: 'প্লেট নং', type: FieldType.text, showInBook: true, staffOnly: true),
    RegisterField(key: 'issueDate', label: 'ইস্যুর তারিখ', type: FieldType.date, showInBook: true, staffOnly: true),
    RegisterField(key: 'renewDate', label: 'নবায়নের তারিখ', type: FieldType.date, showInBook: true, staffOnly: true),
  ],
  certificate: CertificateSpec(
    docTitle: 'রিকশা / ভ্যান লাইসেন্স',
    body: 'এই মর্মে জানানো যাইতেছে যে, {{ownerName}}, ঠিকানা: {{address}}, ওয়ার্ড নং '
        '{{ward}}, বগুড়া সিটি কর্পোরেশন — তাঁহার {{vehicleType}} যানবাহনটি প্লেট নং '
        '{{plateNo}} সহ বগুড়া সিটি কর্পোরেশন এলাকায় চলাচলের জন্য লাইসেন্সপ্রাপ্ত হইল। '
        'এই লাইসেন্স {{renewDate}} তারিখ পর্যন্ত বলবৎ থাকিবে এবং প্রতি বৎসর নবায়ন করিতে হইবে।',
    sections: [
      CertificateSection(label: 'যানবাহনের তথ্য', fields: ['vehicleType', 'plateNo', 'driverName']),
      CertificateSection(label: 'মালিকের তথ্য', fields: ['ownerName', 'ownerNid', 'address', 'ward']),
      CertificateSection(label: 'লাইসেন্স', fields: ['fee', 'issueDate', 'renewDate']),
    ],
    signatories: ['লাইসেন্স কর্মকর্তা', 'প্রধান নির্বাহী কর্মকর্তা'],
  ),
);
