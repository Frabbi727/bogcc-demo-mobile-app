/// Creating and advancing register entries.
///
/// Every mutation does the same four things, which is the invariant the whole
/// system rests on:
///   1. patch the record and append a [HistoryStep]
///   2. append an [AuditEntry] — the log is append-only
///   3. queue a [AppNotification] when the register is citizen-facing
///   4. persist, including the serial counters
///
/// Nothing is ever deleted; cancelling is its own action that keeps the record.
library;

import 'package:uuid/uuid.dart';

import '../../catalogue/registers/registers.dart';
import '../../catalogue/services.dart';
import '../../catalogue/users.dart';
import '../../core/time/local_iso.dart';
import '../../data/seed/seed_builder.dart';
import '../../data/seed/seed_data.dart';
import '../../domain/enums.dart';
import '../../domain/models/audit_entry.dart';
import '../../domain/models/messaging.dart';
import '../../domain/models/register_entry.dart';
import '../../domain/models/shared.dart';
import '../../domain/rules/fiscal.dart';
import '../../domain/rules/ids.dart';
import '../../domain/rules/sla.dart';
import '../demo_store.dart';

const _uuid = Uuid();

/// Files a new application from the citizen side.
///
/// The serial is taken at this moment because this is when the paper book would
/// get its next line — not when the form was opened, and not when staff first
/// look at it.
Future<RegisterEntry> createCitizenEntry({
  required DemoStore store,
  required RegisterConfig config,
  required Map<String, dynamic> data,
  required String applicantMobile,
}) async {
  final createdAt = now();
  final fy = fiscalYearOf(createdAt);
  final serviceKey = config.serviceKey ?? config.key;

  final applicant = config.applicantFrom(data);
  final applicantName = applicant?.name ?? 'নাগরিক';
  final mobile = applicant?.mobile ?? applicantMobile;
  final ward = (data['ward'] as num?)?.toInt() ?? 1;

  final sequences = store.sequences;
  final serial =
      sequences.next(SeqKeys.register(config.serialPrefix, fy));
  final tracking =
      trackingNo(createdAt.year, sequences.next(SeqKeys.tracking(createdAt.year)));

  final firstStep = config.steps.first;
  final fee = fixedFeeOf(serviceKey);
  final feeLines = fee > 0 ? [FeeLine(label: 'সনদ ফি', amount: fee)] : null;

  final entry = RegisterEntry(
    id: _uuid.v4(),
    serviceKey: serviceKey,
    trackingNo: tracking,
    channel: Channel.online,
    applicantName: applicantName,
    applicantMobile: mobile,
    ward: ward,
    status: firstStep.key,
    history: [
      HistoryStep(
        status: firstStep.key,
        at: createdAt,
        byName: '$applicantName (অনলাইন)',
        byRole: AppRole.operator,
        note: 'নাগরিক কর্নার থেকে অনলাইনে আবেদন জমা হয়েছে।',
        publicNote: true,
      ),
    ],
    createdAt: createdAt,
    dueAt: dueDate(createdAt, charterDaysOf(serviceKey)),
    fiscalYear: fy,
    registerKey: config.key,
    slaExempt: !config.citizenFacing,
    serial: serial,
    serialNo: registerSerialNo(config.serialPrefix, fy, serial),
    data: data,
    feeLines: feeLines,
    feeTotal: feeLines == null ? null : fee,
  );

  await store.putEntry(entry);

  await store.appendAudit(
    AuditEntry(
      id: _uuid.v4(),
      at: createdAt,
      userName: applicantName,
      role: AppRole.operator,
      action: firstStep.label,
      recordType: AuditRecordType.registerEntry,
      recordKey: config.key,
      recordId: entry.id,
      recordLabel: '${entryLabelOf(entry)} (${entry.serialNo})',
      note: 'অনলাইনে জমা',
    ),
  );

  if (config.citizenFacing) {
    await store.putNotification(
      AppNotification(
        id: _uuid.v4(),
        mobile: mobile,
        text: '$tracking: ${firstStep.citizenLabel}',
        at: createdAt,
        trackingNo: tracking,
      ),
    );
  }

  // Only now, once the record that used the serial is safely written.
  await store.flushSequences();

  return entry;
}

/// The Bangla title of whoever acts next, for the "what happens now" line.
String? nextActorTitle(RegisterConfig config, String status) {
  final next = config.nextStep(status);
  if (next == null || next.actors.isEmpty) return null;
  return roleTitle(next.actors.first);
}
