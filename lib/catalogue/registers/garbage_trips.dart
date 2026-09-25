import '../../domain/enums.dart';
import 'register_config.dart';

/// C3 — the daily garbage vehicle trip log.
/// Office-only; no citizen ever files one, and nothing here is measured against
/// the charter because the book promises a citizen nothing.
const garbageTripsRegister = RegisterConfig(
  key: 'garbage-trips',
  title: 'বর্জ্য পরিবহন ট্রিপ রেজিস্টার',
  section: 'পরিচ্ছন্নতা শাখা',
  serialPrefix: 'GT',
  description: 'প্রতিদিন কোন গাড়ি কোন ওয়ার্ডে কতবার গিয়েছে তার হিসাব',
  dateField: 'tripDate',
  createRoles: [AppRole.operator, AppRole.conservancy],
  cancelRoles: [AppRole.conservancy, AppRole.ceo],
  totals: ['trips', 'fuel'],
  steps: [
    RegisterStep(key: 'entry', label: 'এন্ট্রি', citizenLabel: 'এন্ট্রি'),
    RegisterStep(
      key: 'verified',
      label: 'সুপারভাইজার যাচাইকৃত',
      citizenLabel: 'যাচাইকৃত',
      actors: [AppRole.conservancy],
    ),
  ],
  fields: [
    RegisterField(key: 'tripDate', label: 'তারিখ', type: FieldType.date, required: true, showInBook: true),
    RegisterField(key: 'vehicleNo', label: 'গাড়ি নং', type: FieldType.text, required: true, showInBook: true),
    RegisterField(key: 'driver', label: 'চালকের নাম', type: FieldType.text, required: true, showInBook: true),
    RegisterField(key: 'ward', label: 'ওয়ার্ড', type: FieldType.ward, required: true, showInBook: true),
    RegisterField(key: 'route', label: 'রুট', type: FieldType.text, showInBook: true),
    RegisterField(key: 'trips', label: 'ট্রিপ সংখ্যা', type: FieldType.number, required: true, showInBook: true),
    RegisterField(
      key: 'dumpSite',
      label: 'ডাম্পিং স্থান',
      type: FieldType.select,
      options: ['ঠনঠনিয়া ডাম্পিং', 'নামুজা ডাম্পিং', 'ফুলবাড়ি ডাম্পিং'],
      required: true,
      showInBook: true,
    ),
    RegisterField(key: 'fuel', label: 'জ্বালানি (লিটার)', type: FieldType.number, showInBook: true),
    RegisterField(key: 'supervisor', label: 'সুপারভাইজার', type: FieldType.text, showInBook: true),
  ],
);
