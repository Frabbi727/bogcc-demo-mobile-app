import '../../domain/enums.dart';
import 'register_config.dart';

/// C4 — citizenship certificate.
/// Ward-scoped: only that ward's councillor approves it.
const certCitizenRegister = RegisterConfig(
  key: 'cert-citizen',
  serviceKey: 'cert-citizen',
  title: 'নাগরিকত্ব সনদ রেজিস্টার',
  section: 'সাধারণ শাখা',
  serialPrefix: 'CC',
  description: 'নাগরিকত্ব সনদের আবেদন, ফি, কাউন্সিলর অনুমোদন ও ইস্যুর হিসাব',
  citizenFacing: true,
  wardScoped: true,
  printable: true,
  dateField: 'createdAt',
  applicantFields: ApplicantFields(name: 'name', mobile: 'mobile'),
  createRoles: [AppRole.operator],
  cancelRoles: [AppRole.licenceOfficer, AppRole.ceo],
  steps: [
    RegisterStep(
      key: 'received',
      label: 'আবেদন গৃহীত',
      citizenLabel: 'আবেদন গৃহীত',
    ),
    RegisterStep(
      key: 'paid',
      label: 'ফি পরিশোধিত',
      citizenLabel: 'ফি পরিশোধিত',
      actors: [AppRole.accounts],
      payment: true,
    ),
    RegisterStep(
      key: 'approved',
      label: 'কাউন্সিলর অনুমোদিত',
      citizenLabel: 'কাউন্সিলর অনুমোদিত',
      actors: [AppRole.councillor],
    ),
    RegisterStep(
      key: 'issued',
      label: 'সনদ ইস্যুকৃত',
      citizenLabel: 'সনদ প্রস্তুত',
      actors: [AppRole.operator, AppRole.licenceOfficer],
    ),
  ],
  fields: [
    RegisterField(
      key: 'name',
      label: 'নাম',
      type: FieldType.text,
      required: true,
      showInBook: true,
      citizenInput: true,
    ),
    RegisterField(
      key: 'fatherName',
      label: 'পিতার নাম',
      type: FieldType.text,
      required: true,
      showInBook: true,
      citizenInput: true,
    ),
    RegisterField(
      key: 'motherName',
      label: 'মাতার নাম',
      type: FieldType.text,
      required: true,
      citizenInput: true,
    ),
    RegisterField(
      key: 'dob',
      label: 'জন্ম তারিখ',
      type: FieldType.date,
      required: true,
      citizenInput: true,
    ),
    RegisterField(
      key: 'nid',
      label: 'জাতীয় পরিচয়পত্র / জন্ম নিবন্ধন নং',
      type: FieldType.nid,
      required: true,
      showInBook: true,
      citizenInput: true,
    ),
    RegisterField(
      key: 'address',
      label: 'ঠিকানা',
      type: FieldType.text,
      required: true,
      showInBook: true,
      citizenInput: true,
    ),
    RegisterField(
      key: 'ward',
      label: 'ওয়ার্ড',
      type: FieldType.ward,
      required: true,
      showInBook: true,
      citizenInput: true,
    ),
    RegisterField(
      key: 'mobile',
      label: 'মোবাইল',
      type: FieldType.phone,
      required: true,
      citizenInput: true,
    ),
  ],
  certificate: CertificateSpec(
    docTitle: 'নাগরিকত্ব সনদপত্র',
    body: 'এই মর্মে প্রত্যয়ন করা হইতেছে যে, {{name}}, পিতা/স্বামী: {{fatherName}}, '
        'মাতা: {{motherName}}, ঠিকানা: {{address}}, ওয়ার্ড নং {{ward}}, বগুড়া সিটি '
        'কর্পোরেশন — তিনি বগুড়া সিটি কর্পোরেশনের একজন স্থায়ী বাসিন্দা এবং বাংলাদেশের '
        'নাগরিক। আমার জানামতে তিনি রাষ্ট্রবিরোধী কোনো কর্মকাণ্ডে জড়িত নহেন।',
    sections: [
      CertificateSection(
        label: 'আবেদনকারীর তথ্য',
        fields: ['name', 'fatherName', 'motherName', 'dob', 'nid'],
      ),
      CertificateSection(label: 'ঠিকানা', fields: ['address', 'ward']),
    ],
    signatories: ['ওয়ার্ড কাউন্সিলর', 'প্রধান নির্বাহী কর্মকর্তা'],
  ),
);
