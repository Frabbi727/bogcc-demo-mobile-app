import '../../domain/enums.dart';
import 'register_config.dart';

/// C2 — garbage and cleanliness complaints.
const garbageRegister = RegisterConfig(
  key: 'garbage',
  serviceKey: 'garbage',
  title: 'বর্জ্য ও পরিচ্ছন্নতা অভিযোগ রেজিস্টার',
  section: 'পরিচ্ছন্নতা শাখা',
  serialPrefix: 'GC',
  description: 'ময়লা, ডাস্টবিন ও ড্রেন সংক্রান্ত অভিযোগ এবং সমাধানের হিসাব',
  citizenFacing: true,
  dateField: 'createdAt',
  applicantFields:
      ApplicantFields(name: 'complainant', mobile: 'complainantMobile'),
  createRoles: [AppRole.operator, AppRole.conservancy],
  cancelRoles: [AppRole.conservancy, AppRole.ceo],
  steps: [
    RegisterStep(
      key: 'received',
      label: 'অভিযোগ গৃহীত',
      citizenLabel: 'অভিযোগ গৃহীত',
    ),
    RegisterStep(
      key: 'assigned',
      label: 'পরিচ্ছন্নতা দল নিযুক্ত',
      citizenLabel: 'পরিচ্ছন্নতা দল পাঠানো হয়েছে',
      actors: [AppRole.conservancy],
      requiredFields: ['team'],
    ),
    RegisterStep(
      key: 'cleaned',
      label: 'পরিষ্কার সম্পন্ন',
      citizenLabel: 'পরিষ্কার সম্পন্ন',
      actors: [AppRole.conservancy],
      requiredFields: ['resolvedDate'],
    ),
  ],
  fields: [
    RegisterField(
      key: 'ward',
      label: 'ওয়ার্ড',
      type: FieldType.ward,
      required: true,
      showInBook: true,
      citizenInput: true,
    ),
    RegisterField(
      key: 'landmark',
      label: 'এলাকা / ল্যান্ডমার্ক',
      type: FieldType.text,
      required: true,
      showInBook: true,
      citizenInput: true,
    ),
    RegisterField(
      key: 'problemType',
      label: 'সমস্যার ধরন',
      type: FieldType.select,
      options: ['ময়লা জমে আছে', 'ডাস্টবিন উপচে পড়ছে', 'ড্রেন বন্ধ', 'মৃত প্রাণী'],
      required: true,
      showInBook: true,
      citizenInput: true,
    ),
    RegisterField(
      key: 'photo',
      label: 'সমস্যার ছবি',
      type: FieldType.photo,
      citizenInput: true,
    ),
    RegisterField(
      key: 'description',
      label: 'বিবরণ',
      type: FieldType.textarea,
      citizenInput: true,
    ),
    RegisterField(
      key: 'complainant',
      label: 'অভিযোগকারীর নাম',
      type: FieldType.text,
      required: true,
      showInBook: true,
      citizenInput: true,
    ),
    RegisterField(
      key: 'complainantMobile',
      label: 'অভিযোগকারীর মোবাইল',
      type: FieldType.phone,
      required: true,
      citizenInput: true,
    ),
    RegisterField(
      key: 'team',
      label: 'নিযুক্ত দল',
      type: FieldType.text,
      showInBook: true,
      staffOnly: true,
    ),
    RegisterField(
      key: 'resolvedDate',
      label: 'সমাধানের তারিখ',
      type: FieldType.date,
      showInBook: true,
      staffOnly: true,
    ),
  ],
);
