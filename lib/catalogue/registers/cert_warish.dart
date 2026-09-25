import '../../domain/enums.dart';
import 'register_config.dart';

/// C5 — warish (inheritance) certificate.
///
/// Same flow as the citizenship certificate plus a staff verification step,
/// because the heirs list has to be checked before the councillor signs it.
const certWarishRegister = RegisterConfig(
  key: 'cert-warish',
  serviceKey: 'cert-warish',
  title: 'ওয়ারিশ সনদ রেজিস্টার',
  section: 'সাধারণ শাখা',
  serialPrefix: 'CW',
  description: 'ওয়ারিশ সনদের আবেদন, উত্তরাধিকারীর তালিকা যাচাই ও ইস্যুর হিসাব',
  citizenFacing: true,
  wardScoped: true,
  printable: true,
  dateField: 'createdAt',
  applicantFields: ApplicantFields(name: 'applicantName', mobile: 'mobile'),
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
      key: 'verified',
      label: 'তথ্য যাচাই সম্পন্ন',
      citizenLabel: 'তথ্য যাচাই সম্পন্ন',
      actors: [AppRole.operator, AppRole.inspector],
      requiredFields: ['verifyNote'],
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
      key: 'deceasedName',
      label: 'মৃত ব্যক্তির নাম',
      type: FieldType.text,
      required: true,
      showInBook: true,
      citizenInput: true,
    ),
    RegisterField(
      key: 'deathDate',
      label: 'মৃত্যুর তারিখ',
      type: FieldType.date,
      required: true,
      showInBook: true,
      citizenInput: true,
    ),
    RegisterField(
      key: 'applicantName',
      label: 'আবেদনকারীর নাম',
      type: FieldType.text,
      required: true,
      showInBook: true,
      citizenInput: true,
    ),
    RegisterField(
      key: 'relation',
      label: 'মৃতের সাথে সম্পর্ক',
      type: FieldType.text,
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
    RegisterField(
      key: 'heirs',
      label: 'উত্তরাধিকারীদের তালিকা',
      type: FieldType.heirs,
      required: true,
      citizenInput: true,
      hint: 'প্রত্যেকের নাম, সম্পর্ক ও বয়স দিন',
    ),
    RegisterField(
      key: 'verifyNote',
      label: 'যাচাইয়ের মন্তব্য',
      type: FieldType.textarea,
      staffOnly: true,
    ),
  ],
  certificate: CertificateSpec(
    docTitle: 'ওয়ারিশ সনদপত্র',
    body: 'এই মর্মে প্রত্যয়ন করা হইতেছে যে, {{deceasedName}}, ঠিকানা: {{address}}, '
        'ওয়ার্ড নং {{ward}}, বগুড়া সিটি কর্পোরেশন — গত {{deathDate}} তারিখে '
        'মৃত্যুবরণ করিয়াছেন। আমার জানামতে ও স্থানীয় অনুসন্ধানে নিম্নলিখিত '
        'ব্যক্তিগণই তাঁহার বৈধ ওয়ারিশ হিসাবে বিদ্যমান আছেন।',
    sections: [
      CertificateSection(
        label: 'মৃত ব্যক্তির তথ্য',
        fields: ['deceasedName', 'deathDate', 'address', 'ward'],
      ),
      CertificateSection(
        label: 'আবেদনকারী',
        fields: ['applicantName', 'relation', 'mobile'],
      ),
    ],
    signatories: ['ওয়ার্ড কাউন্সিলর', 'প্রধান নির্বাহী কর্মকর্তা'],
  ),
);
