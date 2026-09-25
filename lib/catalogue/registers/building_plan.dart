import '../../domain/enums.dart';
import 'register_config.dart';

/// C9 — building plan approval.
///
/// The engineering section takes the application, an inspector visits the plot
/// and writes a report, and the chief executive approves. The plan drawing
/// itself stays on paper in this demo; the book records that it was received
/// and inspected.
const buildingPlanRegister = RegisterConfig(
  key: 'building-plan',
  title: 'ইমারত নকশা অনুমোদন রেজিস্টার',
  section: 'ইঞ্জিনিয়ারিং শাখা',
  serialPrefix: 'BP',
  description: 'ইমারত নির্মাণের নকশার আবেদন, পরিদর্শন প্রতিবেদন ও অনুমোদনের ধাপ',
  dateField: 'applicationDate',
  applicantFields:
      ApplicantFields(name: 'applicantName', mobile: 'applicantMobile'),
  createRoles: [AppRole.operator, AppRole.inspector],
  cancelRoles: [AppRole.ceo],
  totals: ['fee'],
  steps: [
    RegisterStep(key: 'received', label: 'আবেদন গৃহীত', citizenLabel: 'আবেদন গৃহীত'),
    RegisterStep(
      key: 'inspected',
      label: 'পরিদর্শন সম্পন্ন',
      citizenLabel: 'পরিদর্শন সম্পন্ন',
      actors: [AppRole.inspector],
      requiredFields: ['inspectionDate', 'inspectionNote'],
    ),
    RegisterStep(
      key: 'approved',
      label: 'নকশা অনুমোদিত',
      citizenLabel: 'নকশা অনুমোদিত',
      actors: [AppRole.ceo],
      requiredFields: ['approvalDate'],
    ),
  ],
  fields: [
    RegisterField(key: 'applicationDate', label: 'আবেদনের তারিখ', type: FieldType.date, required: true, showInBook: true),
    RegisterField(key: 'applicantName', label: 'আবেদনকারীর নাম', type: FieldType.text, required: true, showInBook: true),
    RegisterField(key: 'applicantMobile', label: 'আবেদনকারীর মোবাইল', type: FieldType.phone, required: true),
    RegisterField(key: 'holdingNo', label: 'হোল্ডিং নং', type: FieldType.text, required: true, showInBook: true),
    RegisterField(key: 'ward', label: 'ওয়ার্ড', type: FieldType.ward, required: true, showInBook: true),
    RegisterField(key: 'landArea', label: 'জমির পরিমাণ (শতাংশ)', type: FieldType.number, required: true, showInBook: true),
    RegisterField(key: 'floors', label: 'তলা সংখ্যা', type: FieldType.number, required: true, showInBook: true),
    RegisterField(
      key: 'buildingUse',
      label: 'ব্যবহারের ধরন',
      type: FieldType.select,
      options: ['আবাসিক', 'বাণিজ্যিক', 'মিশ্র', 'শিল্প'],
      required: true,
      showInBook: true,
    ),
    RegisterField(key: 'designerName', label: 'নকশাকারের নাম', type: FieldType.text, required: true, showInBook: true),
    RegisterField(key: 'fee', label: 'ফি (টাকা)', type: FieldType.number, required: true, showInBook: true),
    RegisterField(key: 'inspectionDate', label: 'পরিদর্শনের তারিখ', type: FieldType.date, showInBook: true, staffOnly: true),
    RegisterField(key: 'inspectionNote', label: 'পরিদর্শন প্রতিবেদন', type: FieldType.textarea, staffOnly: true),
    RegisterField(key: 'approvalDate', label: 'অনুমোদনের তারিখ', type: FieldType.date, showInBook: true, staffOnly: true),
  ],
);
