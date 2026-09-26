/// Builds the whole demo dataset for a given day.
///
/// EVERY person, business, NID and phone number is invented; only the Bogura
/// area names are real. The data is generated **relative to the day the demo is
/// shown**, so the dashboards are never empty and today's collection always has
/// something in it. A seeded PRNG keyed on that date keeps it identical on every
/// device and across relaunches on the same day.
///
/// This is a port of the web demo's `src/data/seed.ts` in shape, volume and
/// rules — not in its exact random stream. The two apps do not share a store
/// (see the README), so reproducing the draw order across 1,300 lines would buy
/// nothing and break at the first divergence. What is preserved is everything
/// the app and the tests depend on: the record counts, the status spread, the
/// gapless serials, the payment-ordered receipts, a handful of overdue records,
/// and the demo citizen's four requests.
library;

import '../../catalogue/business_types.dart';
import '../../catalogue/names.dart';
import '../../catalogue/registers/registers.dart';
import '../../catalogue/services.dart';
import '../../catalogue/users.dart';
import '../../catalogue/wards.dart';
import '../../core/random/seeded_rng.dart';
import '../../core/time/local_iso.dart';
import '../../domain/enums.dart';
import '../../domain/models/audit_entry.dart';
import '../../domain/models/holding.dart';
import '../../domain/models/licence.dart';
import '../../domain/models/messaging.dart';
import '../../domain/models/money.dart';
import '../../domain/models/register_entry.dart';
import '../../domain/models/shared.dart';
import '../../domain/rules/fiscal.dart';
import '../../domain/rules/ids.dart';
import '../../domain/rules/sla.dart';
import 'seed_data.dart';
import 'seed_fields.dart';
import 'seed_text.dart';

String _pad(int n, [int w = 2]) => n.toString().padLeft(w, '0');

/// A payment that happened, collected first and numbered later.
///
/// Receipt numbers must run in collection order across every revenue head, the
/// way one receipt book at one counter does, so nothing can be numbered until
/// every payment in the dataset is known and sorted.
class _PayEvent {
  _PayEvent({
    required this.at,
    required this.head,
    required this.channel,
    required this.purpose,
    required this.payerName,
    required this.payerMobile,
    required this.feeLines,
    required this.total,
    required this.target,
    required this.link,
    this.mode,
    this.method,
  });

  final DateTime at;
  final RevenueHead head;
  final Channel channel;
  final String purpose;
  final String payerName;
  final String payerMobile;
  final List<FeeLine> feeLines;
  final int total;
  final PaymentTarget target;
  final PaymentMode? mode;
  final OnlineMethod? method;

  /// Writes the allocated ids back onto whatever this paid for.
  final void Function(String paymentId, String receiptId) link;
}

/// Mutable scratch for a licence while its history is being assembled.
class _LicenceDraft {
  _LicenceDraft(this.licence, {this.approvedAt, this.paidAt});
  Licence licence;
  DateTime? approvedAt;
  DateTime? paidAt;
}

class _EntryDraft {
  _EntryDraft(this.entry, this.config);
  RegisterEntry entry;
  final RegisterConfig config;
}

SeedData buildSeed([DateTime? today]) => _SeedBuilder(today ?? now()).build();

class _SeedBuilder {
  _SeedBuilder(this.today)
      : rng = SeededRng(
          'bogcc-${today.year}-${_pad(today.month)}-${_pad(today.day)}',
        );

  final DateTime today;
  final SeededRng rng;

  final sequences = <String, int>{};
  final licences = <Licence>[];
  final entries = <RegisterEntry>[];
  final holdings = <Holding>[];
  final payments = <Payment>[];
  final receipts = <Receipt>[];
  final notifications = <AppNotification>[];
  final notices = <Notice>[];
  final audit = <AuditEntry>[];
  final payEvents = <_PayEvent>[];

  int _auditCount = 0;
  int _smsCount = 0;

  /// How many still-open records may be past their charter deadline.
  ///
  /// A handful — enough to demonstrate the overdue list, not so many that the
  /// office looks broken. Budgeted per area because licences are generated
  /// first and would otherwise use the lot, leaving the complaint registers
  /// with none to show.
  late final _overdueBudget = {'licence': rng.int_(2, 3), 'entry': rng.int_(3, 5)};

  int _nextSeq(String key) {
    final value = (sequences[key] ?? 0) + 1;
    sequences[key] = value;
    return value;
  }

  void _log({
    required DateTime at,
    required String userName,
    required AppRole role,
    required String action,
    required AuditRecordType recordType,
    required String recordKey,
    required String recordId,
    required String recordLabel,
    String? note,
    List<FieldChange> changes = const [],
  }) {
    _auditCount += 1;
    audit.add(
      AuditEntry(
        id: 'au${_pad(_auditCount, 5)}',
        at: at,
        userName: userName,
        role: role,
        action: action,
        recordType: recordType,
        recordKey: recordKey,
        recordId: recordId,
        recordLabel: recordLabel,
        note: note,
        changes: changes,
      ),
    );
  }

  void _sms(String mobile, String text, DateTime at, [String? trackingNo]) {
    _smsCount += 1;
    notifications.add(
      AppNotification(
        id: 'sm${_pad(_smsCount, 5)}',
        mobile: mobile,
        text: text,
        at: at,
        trackingNo: trackingNo,
        // Anything older than three days is treated as already read, so the
        // unread badge shows a believable handful rather than hundreds.
        read: at.isBefore(today.subtract(const Duration(days: 3))),
      ),
    );
  }

  /// A day offset in the past, at a plausible office hour.
  DateTime _pastDay(int minDaysAgo, int maxDaysAgo) {
    final days = rng.int_(minDaysAgo, maxDaysAgo);
    final d = shiftDays(today, -days);
    return DateTime(d.year, d.month, d.day, rng.int_(10, 16), rng.int_(0, 59));
  }

  String _mobile() {
    final prefix = rng.pick(['013', '014', '015', '016', '017', '018', '019']);
    return '$prefix${rng.int_(10000000, 99999999)}';
  }

  String _nid() => '${rng.int_(1000000000, 9999999999)}';

  String _trackingFor(DateTime at) =>
      trackingNo(at.year, _nextSeq(SeqKeys.tracking(at.year)));

  /// Creation date for a record that is still open.
  ///
  /// Most are recent enough to sit comfortably inside the charter; a budgeted
  /// few are backdated past it so the overdue list has rows.
  DateTime _openCreatedAt(String serviceKey, String area) {
    final charter = charterDaysOf(serviceKey).clamp(1, 60);
    if ((_overdueBudget[area] ?? 0) > 0 && rng.chance(0.35)) {
      _overdueBudget[area] = _overdueBudget[area]! - 1;
      return _pastDay(charter + 6, charter + 16);
    }
    return _pastDay(0, charter - 1 < 1 ? 1 : charter - 1);
  }

  DateTime _shift(DateTime from, int days, [int? hour, int minute = 0]) {
    final d = shiftDays(from, days);
    return hour == null
        ? d
        : DateTime(d.year, d.month, d.day, hour, minute);
  }

  /// Ratings average around 4.2, with a few unhappy ones so the number is
  /// believable rather than a flat five stars.
  Feedback _makeFeedback(DateTime at) {
    final roll = rng.next();
    final rating = roll < 0.05
        ? 2
        : roll < 0.15
            ? 3
            : roll < 0.55
                ? 4
                : 5;
    return Feedback(
      rating: rating,
      comment: rng.chance(0.7) ? rng.pick(feedbackComments[rating]!) : null,
      at: at,
    );
  }

  SeedData build() {
    _buildLicences();
    _buildEntries();
    _buildHoldings();
    _settlePayments();
    _buildNotices();
    _assignDemoCitizen();

    audit.sort((a, b) => a.at.compareTo(b.at));
    notifications.sort((a, b) => a.at.compareTo(b.at));

    return SeedData(
      seedDate: today,
      licences: licences,
      entries: entries,
      holdings: holdings,
      payments: payments,
      receipts: receipts,
      notifications: notifications,
      notices: notices,
      audit: audit,
      sequences: sequences,
    );
  }

  /* ================= Trade licences ================= */

  void _buildLicences() {
    // Counts chosen so every status tab and both kinds have something to show.
    const plan = <(LicenceStatus, int)>[
      (LicenceStatus.issued, 26),
      (LicenceStatus.approved, 5),
      (LicenceStatus.verified, 5),
      (LicenceStatus.submitted, 7),
      (LicenceStatus.cancelled, 2),
    ];
    const order = [
      LicenceStatus.submitted,
      LicenceStatus.verified,
      LicenceStatus.approved,
      LicenceStatus.issued,
    ];

    final drafts = <_LicenceDraft>[];
    var index = 0;

    for (final (status, count) in plan) {
      for (var i = 0; i < count; i++) {
        index += 1;
        final kind = rng.chance(0.3) ? 'renewal' : 'new';
        final serviceKey = kind == 'renewal' ? 'tl-renew' : 'tl-new';
        final channel = rng.chance(0.4) ? Channel.online : Channel.office;

        // Issued licences spread across the last 14 months; open ones are
        // recent, bar the budgeted few left old so the SLA list is not empty.
        final createdAt = switch (status) {
          LicenceStatus.issued => _pastDay(2, 420),
          LicenceStatus.cancelled => _pastDay(30, 200),
          _ => _openCreatedAt(serviceKey, 'licence'),
        };

        final fy = fiscalYearOf(createdAt);
        final type = rng.pick(businessTypes);
        final nameBn = rng.pick(businessNames[type.key]!);
        final ward = rng.pick(wards);
        final area = rng.pick(areas);
        final ownerName =
            rng.chance(0.25) ? rng.pick(femaleNames) : rng.pick(maleNames);
        final late = kind == 'renewal' && isLateRenewal(fy, createdAt);
        final fees = feeLinesFor(type.key, renewal: kind == 'renewal', late: late);
        final applicantMobile = _mobile();

        final history = <HistoryStep>[];
        void push(
          String statusKey,
          DateTime at,
          AppRole role, {
          String? note,
          bool publicNote = false,
        }) {
          history.add(
            HistoryStep(
              status: statusKey,
              at: at,
              byName: channel == Channel.online && statusKey == 'submitted'
                  ? '$ownerName (অনলাইন)'
                  : userFor(role).name,
              byRole: role,
              note: note,
              publicNote: publicNote,
            ),
          );
        }

        push(
          'submitted',
          createdAt,
          AppRole.operator,
          note: channel == Channel.online
              ? 'নাগরিক কর্নার থেকে অনলাইনে আবেদন জমা হয়েছে।'
              : 'কাউন্টারে আবেদন গ্রহণ।',
          publicNote: true,
        );

        DateTime? verifiedAt;
        DateTime? approvedAt;
        DateTime? paidAt;
        DateTime? closedAt;
        Cancellation? cancelled;

        bool reached(LicenceStatus s) =>
            status != LicenceStatus.cancelled &&
            order.indexOf(status) >= order.indexOf(s);

        if (reached(LicenceStatus.verified)) {
          verifiedAt = _shift(createdAt, rng.int_(1, 3), rng.int_(11, 15));
          push(
            'verified',
            verifiedAt,
            AppRole.inspector,
            note: kind == 'renewal'
                ? 'নবায়ন — কাগজপত্র যাচাই সম্পন্ন, সরেজমিনে পরিদর্শনের প্রয়োজন হয়নি।'
                : 'সরেজমিনে প্রতিষ্ঠান পরিদর্শন করা হয়েছে; তথ্য সঠিক পাওয়া গেছে।',
            publicNote: true,
          );
        }
        if (reached(LicenceStatus.approved)) {
          approvedAt =
              _shift(verifiedAt ?? createdAt, rng.int_(1, 3), rng.int_(11, 16));
          push('approved', approvedAt, AppRole.licenceOfficer, publicNote: true);
        }
        if (status == LicenceStatus.issued) {
          paidAt =
              _shift(approvedAt ?? createdAt, rng.int_(0, 3), rng.int_(10, 16));
          closedAt = paidAt;
        }
        if (status == LicenceStatus.cancelled) {
          verifiedAt = _shift(createdAt, rng.int_(1, 3), 12);
          push(
            'verified',
            verifiedAt,
            AppRole.inspector,
            note: 'সরেজমিনে পরিদর্শন করা হয়েছে।',
            publicNote: true,
          );
          final at = _shift(verifiedAt, rng.int_(1, 5), 15);
          cancelled = Cancellation(
            at: at,
            by: userFor(AppRole.licenceOfficer).name,
            reason: rng.pick(licenceCancelReasons),
          );
          history.add(
            HistoryStep(
              status: 'cancelled',
              at: at,
              byName: userFor(AppRole.licenceOfficer).name,
              byRole: AppRole.licenceOfficer,
              note: cancelled.reason,
              publicNote: true,
            ),
          );
          closedAt = at;
        }

        final licence = Licence(
          id: 'tl${_pad(index, 3)}',
          serviceKey: serviceKey,
          trackingNo: _trackingFor(createdAt),
          channel: channel,
          applicantName: ownerName,
          applicantMobile: applicantMobile,
          ward: ward,
          licenceStatus: status,
          history: history,
          createdAt: createdAt,
          dueAt: dueDate(createdAt, charterDaysOf(serviceKey)),
          closedAt: closedAt,
          fiscalYear: fy,
          cancelled: cancelled,
          appNo: '',
          kind: kind,
          business: Business(
            nameBn: nameBn,
            nameEn: businessNamesEn[nameBn] ?? nameBn,
            typeKey: type.key,
            nature: rng.pick([
              BusinessNature.single,
              BusinessNature.single,
              BusinessNature.partnership,
              BusinessNature.company,
            ]),
            address: '${rng.pick(roads)}, $area',
            area: area,
            ward: ward,
            holdingNo: holdingNo(ward, rng.int_(1, 400)),
          ),
          owner: Owner(
            name: ownerName,
            fatherName: rng.pick(fatherNames),
            motherName: rng.pick(motherNames),
            nid: _nid(),
            mobile: applicantMobile,
          ),
          feeLines: fees,
          feeTotal: feeTotalOf(fees),
          verificationNote: verifiedAt != null
              ? 'সরেজমিনে তথ্য যাচাই করা হয়েছে; প্রতিষ্ঠান চালু অবস্থায় পাওয়া গেছে।'
              : null,
        );

        drafts.add(_LicenceDraft(licence, approvedAt: approvedAt, paidAt: paidAt));
      }
    }

    // Application numbers follow submission order, so the sequence is gapless.
    final bySubmission = [...drafts]
      ..sort((a, b) => a.licence.createdAt.compareTo(b.licence.createdAt));
    for (final d in bySubmission) {
      d.licence = d.licence.copyWith(
        appNo: applicationNo(
          d.licence.fiscalYear,
          _nextSeq(SeqKeys.app(d.licence.fiscalYear)),
        ),
      );
    }

    // The register serial is written at approval — the moment a new line would
    // be added to the paper book — so serials follow approval order, not
    // submission order.
    final byApproval = drafts.where((d) => d.approvedAt != null).toList()
      ..sort((a, b) => a.approvedAt!.compareTo(b.approvedAt!));
    for (final d in byApproval) {
      final serial = _nextSeq(SeqKeys.licence(d.licence.fiscalYear));
      d.licence = d.licence.copyWith(
        serial: serial,
        registerNo: licenceNo(d.licence.fiscalYear, serial),
      );
    }

    for (final d in drafts) {
      var licence = d.licence;

      for (final step in licence.history) {
        _log(
          at: step.at,
          userName: step.byName,
          role: step.byRole,
          action: licenceAction[step.status] ?? step.status,
          recordType: AuditRecordType.tradeLicence,
          recordKey: 'trade-licence',
          recordId: licence.id,
          recordLabel:
              '${licence.business.nameBn} (${licence.registerNo ?? licence.appNo})',
          note: step.note,
          changes: step.status == 'approved' && licence.serial != null
              ? [
                  FieldChange(
                    field: 'ক্রমিক নং',
                    before: '—',
                    after: '${licence.serial}',
                  ),
                  FieldChange(
                    field: 'লাইসেন্স নং',
                    before: '—',
                    after: licence.registerNo ?? '',
                  ),
                ]
              : const [],
        );
        _sms(
          licence.applicantMobile,
          '${licence.trackingNo}: ${licenceSms[step.status] ?? step.status}',
          step.at,
          licence.trackingNo,
        );
      }

      if (d.paidAt != null) {
        final paidAt = d.paidAt!;
        final online = licence.channel == Channel.online && rng.chance(0.75);
        final id = licence.id;
        payEvents.add(
          _PayEvent(
            at: paidAt,
            head: RevenueHead.tradeLicence,
            channel: online ? Channel.online : Channel.office,
            purpose:
                '${licence.kind == 'renewal' ? 'ট্রেড লাইসেন্স নবায়ন ফি' : 'ট্রেড লাইসেন্স ফি'}'
                ' — ${licence.business.nameBn}',
            payerName: licence.owner.name,
            payerMobile: licence.applicantMobile,
            feeLines: licence.feeLines,
            total: licence.feeTotal,
            mode: online ? null : rng.pick(PaymentMode.values),
            method: online ? rng.pick(OnlineMethod.values) : null,
            target: PaymentTarget.tradeLicence(id: id),
            link: (paymentId, receiptId) {
              final i = licences.indexWhere((l) => l.id == id);
              if (i >= 0) {
                licences[i] = licences[i]
                    .copyWith(paymentId: paymentId, receiptId: receiptId);
              }
            },
          ),
        );
        licence = licence.copyWith(
          history: [
            ...licence.history,
            HistoryStep(
              status: 'issued',
              at: paidAt,
              byName: online
                  ? '${licence.owner.name} (অনলাইন)'
                  : userFor(AppRole.accounts).name,
              byRole: AppRole.accounts,
              note: online
                  ? 'নাগরিক অনলাইনে ফি পরিশোধ করেছেন।'
                  : 'কাউন্টারে ফি আদায় করা হয়েছে।',
              publicNote: true,
            ),
          ],
        );
        _sms(
          licence.applicantMobile,
          '${licence.trackingNo}: ${licenceSms['issued']}',
          paidAt,
          licence.trackingNo,
        );
      }

      // Citizens rate a finished service most of the time.
      if (licence.licenceStatus == LicenceStatus.issued && rng.chance(0.65)) {
        licence = licence.copyWith(
          feedback: _makeFeedback(
            _shift(licence.closedAt ?? licence.createdAt, 1, 19),
          ),
        );
      }

      licences.add(licence);
    }
  }

  /* ================= Register entries ================= */

  void _buildEntries() {
    const plan = <(String, int)>[
      ('streetlight', 35),
      ('garbage', 30),
      ('garbage-trips', 40),
      ('cert-citizen', 20),
      ('cert-warish', 8),
      ('market-rent', 36),
      ('rickshaw-licence', 24),
      ('building-plan', 14),
      ('birth-death', 26),
    ];

    /// Books the office writes in every day rather than case by case. Their
    /// lines are dated across the last few weeks so the daily view is never
    /// empty.
    const dailyBooks = {'garbage-trips', 'market-rent', 'birth-death'};

    final drafts = <_EntryDraft>[];
    var index = 0;

    for (final (key, count) in plan) {
      final config = getRegister(key);
      if (config == null) continue;
      final stepKeys = config.statusKeys;

      for (var i = 0; i < count; i++) {
        index += 1;

        // How far through the workflow this line has got. Most are finished; a
        // few sit at each earlier step so every status filter has rows. An
        // intermediate step has to be reachable, or a status in the middle of a
        // longer workflow — a certificate's ফি পরিশোধিত — never appears at all.
        final roll = rng.next();
        var reachedIndex = roll < 0.62
            ? stepKeys.length - 1
            : rng.int_(0, stepKeys.length - 2 < 0 ? 0 : stepKeys.length - 2);
        final isCancelled = rng.chance(0.04) && stepKeys.length > 1;
        if (isCancelled && reachedIndex > stepKeys.length - 2) {
          reachedIndex = stepKeys.length - 2;
        }

        final finished = reachedIndex == stepKeys.length - 1;
        final serviceKey = config.serviceKey ?? key;
        final createdAt = dailyBooks.contains(key)
            // The first few lines of a daily book are dated today, so the daily
            // card is never empty whenever the demo is shown.
            ? (i < 4 ? _pastDay(0, 0) : _pastDay(1, 25))
            : finished
                ? _pastDay(2, 400)
                : _openCreatedAt(serviceKey, 'entry');

        final fy = fiscalYearOf(createdAt);
        final ward = pickWardWithContrast(rng, key);
        final channel = config.citizenFacing && rng.chance(0.45)
            ? Channel.online
            : Channel.office;
        final applicantName =
            rng.chance(0.3) ? rng.pick(femaleNames) : rng.pick(maleNames);
        final applicantMobile = _mobile();

        final data = buildEntryData(
          rng,
          key,
          EntryContext(
            ward: ward,
            applicantName: applicantName,
            applicantMobile: applicantMobile,
            createdAt: createdAt,
          ),
        );

        final fee = fixedFeeOf(serviceKey);
        final feeLines =
            fee > 0 ? [FeeLine(label: 'সনদ ফি', amount: fee)] : null;

        final history = <HistoryStep>[];
        var cursor = createdAt;
        DateTime? paidAt;
        DateTime? closedAt;

        for (var s = 0; s <= reachedIndex; s++) {
          final step = config.steps[s];
          final actor =
              step.actors.isEmpty ? AppRole.operator : step.actors.first;
          if (s > 0) {
            cursor = _shift(cursor, rng.int_(0, 3), rng.int_(10, 16));
          }
          if (step.payment) paidAt = cursor;
          history.add(
            HistoryStep(
              status: step.key,
              at: cursor,
              byName: s == 0 && channel == Channel.online
                  ? '$applicantName (অনলাইন)'
                  : userFor(actor).name,
              byRole: actor,
              note: stepNote(rng, key, step.key),
              publicNote: true,
            ),
          );
          // Staff fields are only filled at the step that asks for them, the
          // way a column stays blank in the paper book until that day.
          for (final fieldKey in step.requiredFields) {
            data[fieldKey] ??= staffFieldValue(rng, fieldKey, cursor, data);
          }
        }
        if (finished) closedAt = cursor;

        Cancellation? cancelled;
        if (isCancelled) {
          final at = _shift(cursor, rng.int_(1, 4), 15);
          final by = userFor(
            config.cancelRoles.isEmpty ? AppRole.ceo : config.cancelRoles.first,
          );
          cancelled = Cancellation(
            at: at,
            by: by.name,
            reason: rng.pick(cancelReasons),
          );
          history.add(
            HistoryStep(
              status: 'cancelled',
              at: at,
              byName: by.name,
              byRole: by.role,
              note: cancelled.reason,
              publicNote: true,
            ),
          );
          closedAt = at;
        }

        var entry = RegisterEntry(
          id: '${config.serialPrefix.toLowerCase()}${_pad(index, 3)}',
          serviceKey: serviceKey,
          trackingNo: _trackingFor(createdAt),
          channel: channel,
          applicantName: applicantName,
          applicantMobile: applicantMobile,
          ward: ward,
          status: stepKeys[reachedIndex],
          history: history,
          createdAt: createdAt,
          dueAt: dueDate(createdAt, charterDaysOf(serviceKey)),
          closedAt: closedAt,
          fiscalYear: fy,
          cancelled: cancelled,
          registerKey: config.key,
          // An internal book promises a citizen nothing, so it is never
          // measured against the charter.
          slaExempt: !config.citizenFacing,
          serial: 0,
          serialNo: '',
          data: data,
          feeLines: feeLines,
          feeTotal: feeLines == null ? null : feeTotalOf(feeLines),
        );

        if (finished && config.printable) {
          entry = entry.copyWith(
            certificateNo: certificateNo(fy, _nextSeq(SeqKeys.certificate(fy))),
          );
        }
        if (config.citizenFacing && finished && !isCancelled && rng.chance(0.6)) {
          entry = entry.copyWith(
            feedback: _makeFeedback(_shift(closedAt ?? createdAt, 1, 20)),
          );
        }

        if (paidAt != null && feeLines != null) {
          final online = channel == Channel.online && rng.chance(0.7);
          final id = entry.id;
          payEvents.add(
            _PayEvent(
              at: paidAt,
              head: RevenueHead.certificate,
              channel: online ? Channel.online : Channel.office,
              purpose:
                  '${config.title.replaceAll(' রেজিস্টার', '')} ফি — $applicantName',
              payerName: applicantName,
              payerMobile: applicantMobile,
              feeLines: feeLines,
              total: feeTotalOf(feeLines),
              mode: online ? null : rng.pick(PaymentMode.values),
              method: online ? rng.pick(OnlineMethod.values) : null,
              target: PaymentTarget.registerEntry(
                id: id,
                registerKey: config.key,
              ),
              link: (paymentId, receiptId) {
                final i = entries.indexWhere((e) => e.id == id);
                if (i >= 0) {
                  entries[i] = entries[i]
                      .copyWith(paymentId: paymentId, receiptId: receiptId);
                }
              },
            ),
          );
        }

        drafts.add(_EntryDraft(entry, config));
      }
    }

    // Engine serials are written on creation, so they follow creation order
    // within each register and fiscal year — and never skip a number.
    for (final config in registers) {
      final ofRegister = drafts
          .where((d) => d.entry.registerKey == config.key)
          .toList()
        ..sort((a, b) => a.entry.createdAt.compareTo(b.entry.createdAt));
      for (final d in ofRegister) {
        final serial = _nextSeq(
          SeqKeys.register(config.serialPrefix, d.entry.fiscalYear),
        );
        d.entry = d.entry.copyWith(
          serial: serial,
          serialNo: registerSerialNo(
            config.serialPrefix,
            d.entry.fiscalYear,
            serial,
          ),
        );
      }
    }

    for (final d in drafts) {
      entries.add(d.entry);
    }

    for (final d in drafts) {
      final config = d.config;
      final entry = d.entry;
      for (final step in entry.history) {
        _log(
          at: step.at,
          userName: step.byName,
          role: step.byRole,
          action: step.status == 'cancelled'
              ? 'বাতিল'
              : config.stepOf(step.status)?.label ?? step.status,
          recordType: AuditRecordType.registerEntry,
          recordKey: config.key,
          recordId: entry.id,
          recordLabel: '${entryLabelOf(entry)} (${entry.serialNo})',
          note: step.note,
        );
        if (config.citizenFacing) {
          final label =
              config.stepOf(step.status)?.citizenLabel ?? 'অবস্থা পরিবর্তন';
          _sms(
            entry.applicantMobile,
            '${entry.trackingNo}: $label',
            step.at,
            entry.trackingNo,
          );
        }
      }
    }
  }

  /* ================= Holdings ================= */

  /// Quarterly demand from the annual valuation, at demo rates.
  HoldingBill _buildHoldingBill(String fiscalYear, int annualValuation) {
    final lines = [
      FeeLine(label: 'হোল্ডিং কর (৭%)', amount: (annualValuation * 0.07).round()),
      FeeLine(label: 'পরিচ্ছন্নতা রেট (৩%)', amount: (annualValuation * 0.03).round()),
      FeeLine(label: 'সড়কবাতি রেট (২%)', amount: (annualValuation * 0.02).round()),
    ];
    final total = lines.fold(0, (s, l) => s + l.amount);
    final quarter = (total / 4).round();
    return HoldingBill(
      fiscalYear: fiscalYear,
      lines: lines,
      total: total,
      instalments: [
        for (var no = 1; no <= 4; no++)
          HoldingInstalment(
            no: no,
            // The last instalment absorbs the rounding, so the four always add
            // up to the demand exactly.
            amount: no == 4 ? total - quarter * 3 : quarter,
          ),
      ],
    );
  }

  void _buildHoldings() {
    final currentFy = fiscalYearOf(today);
    final startYear = int.parse(currentFy.substring(0, 4));
    final previousFy =
        '${startYear - 1}-${_pad(startYear % 100)}';

    for (var i = 1; i <= 60; i++) {
      final ward = rng.pick(wards);
      final area = rng.pick(areas);
      final propertyType = rng.pick(PropertyType.values);
      final floors = propertyType == PropertyType.residential
          ? rng.int_(1, 3)
          : rng.int_(1, 5);
      final annualValuation = rng.int_(12, 90) * 5000;
      final ownerName =
          rng.chance(0.28) ? rng.pick(femaleNames) : rng.pick(maleNames);

      var bill = _buildHoldingBill(currentFy, annualValuation);
      final bills = <HoldingBill>[bill];

      // Some holdings carry unpaid demand from last year, which is what the
      // defaulter list and the arrears surcharge exist to show.
      if (rng.chance(0.35)) {
        final previous = _buildHoldingBill(
          previousFy,
          (annualValuation * 0.95).round(),
        );
        bill = bill.copyWith(
          arrears: previous.total,
          surcharge: (previous.total * 0.05).round(),
        );
        bills
          ..clear()
          ..addAll([previous, bill]);
      }

      final number = holdingNo(ward, i);
      final ownerMobile = _mobile();

      // How much of this year's demand has been collected so far.
      final paidCount = rng.chance(0.2) ? 0 : rng.int_(1, 4);
      for (var q = 0; q < paidCount; q++) {
        final instalment = bill.instalments[q];
        final at = _pastDay(1, 300);
        final online = rng.chance(0.35);
        payEvents.add(
          _PayEvent(
            at: at,
            head: RevenueHead.holdingTax,
            channel: online ? Channel.online : Channel.office,
            purpose: 'হোল্ডিং কর — $number, ${q + 1}ম কিস্তি',
            payerName: ownerName,
            payerMobile: ownerMobile,
            feeLines: [
              FeeLine(label: '${q + 1}ম কিস্তি', amount: instalment.amount),
            ],
            total: instalment.amount,
            mode: online ? null : rng.pick(PaymentMode.values),
            method: online ? rng.pick(OnlineMethod.values) : null,
            target: PaymentTarget.holding(
              holdingNo: number,
              fiscalYear: currentFy,
              instalment: instalment.no,
            ),
            link: (_, receiptId) {
              final hi = holdings.indexWhere((h) => h.holdingNo == number);
              if (hi < 0) return;
              final holding = holdings[hi];
              holdings[hi] = holding.copyWith(
                bills: [
                  for (final b in holding.bills)
                    if (b.fiscalYear != currentFy)
                      b
                    else
                      b.copyWith(
                        instalments: [
                          for (final inst in b.instalments)
                            if (inst.no != instalment.no)
                              inst
                            else
                              inst.copyWith(paidAt: at, receiptId: receiptId),
                        ],
                      ),
                ],
              );
            },
          ),
        );
      }

      holdings.add(
        Holding(
          holdingNo: number,
          ward: ward,
          ownerName: ownerName,
          ownerMobile: ownerMobile,
          address: '${rng.pick(roads)}, $area',
          area: area,
          propertyType: propertyType,
          floors: floors,
          annualValuation: annualValuation,
          bills: bills,
        ),
      );
    }
  }

  /* ========= Payments and receipts, numbered in collection order ========= */

  void _settlePayments() {
    // One counter, one receipt book: numbers run in the order money was taken,
    // across every revenue head, which is why nothing could be numbered until
    // now.
    payEvents.sort((a, b) => a.at.compareTo(b.at));

    for (var index = 0; index < payEvents.length; index++) {
      final event = payEvents[index];
      final fy = fiscalYearOf(event.at);
      final no = _nextSeq(SeqKeys.receipt(fy));
      final ref = receiptBookRef(no);
      final paymentId = 'pm${_pad(index + 1, 4)}';
      final receiptId = 'rc${_pad(index + 1, 4)}';
      final txnRef = event.channel == Channel.online ? txnId(rng.next) : null;

      payments.add(
        Payment(
          id: paymentId,
          status: PaymentStatus.paid,
          head: event.head,
          channel: event.channel,
          purpose: event.purpose,
          payerName: event.payerName,
          payerMobile: event.payerMobile,
          feeLines: event.feeLines,
          total: event.total,
          createdAt: event.at,
          paidAt: event.at,
          mode: event.mode,
          method: event.method,
          txnRef: txnRef,
          receiptId: receiptId,
          target: event.target,
        ),
      );

      final collectedBy = event.channel == Channel.online
          ? 'অনলাইন পেমেন্ট গেটওয়ে (ডেমো)'
          : userFor(AppRole.accounts).name;

      receipts.add(
        Receipt(
          id: receiptId,
          no: no,
          receiptNo: receiptNo(fy, no),
          bookNo: ref.bookNo,
          pageNo: ref.pageNo,
          fiscalYear: fy,
          head: event.head,
          channel: event.channel,
          paymentId: paymentId,
          payerName: event.payerName,
          purpose: event.purpose,
          feeLines: event.feeLines,
          total: event.total,
          mode: event.mode,
          method: event.method,
          txnRef: txnRef,
          collectedBy: collectedBy,
          collectedAt: event.at,
          source: event.target,
        ),
      );

      event.link(paymentId, receiptId);

      _log(
        at: event.at,
        userName: collectedBy,
        role: event.head == RevenueHead.holdingTax
            ? AppRole.revenueOfficer
            : AppRole.accounts,
        action: 'ফি আদায়',
        recordType: AuditRecordType.receipt,
        recordKey: event.head.name,
        recordId: receiptId,
        recordLabel: '${receiptNo(fy, no)} — ${event.payerName}',
        note: '${event.channel == Channel.online ? 'অনলাইনে' : '${event.mode?.label} মাধ্যমে'}'
            ' ${event.total} টাকা আদায়; বই নং ${ref.bookNo}, পাতা ${ref.pageNo}।',
      );
      _sms(
        event.payerMobile,
        'রসিদ ${receiptNo(fy, no)}: ${event.total} টাকা পরিশোধ সম্পন্ন। '
        'ধন্যবাদ, বগুড়া সিটি কর্পোরেশন।',
        event.at,
      );
    }
  }

  /* ================= Notices ================= */

  void _buildNotices() {
    for (var i = 0; i < noticeSeeds.length; i++) {
      final seed = noticeSeeds[i];
      final at = _pastDay(i * 6 + 1, i * 6 + 6);
      final author = switch (i % 3) {
        0 => userFor(AppRole.mayor),
        1 => userFor(AppRole.ceo),
        _ => userFor(AppRole.licenceOfficer),
      };
      final id = 'nt${_pad(i + 1, 3)}';
      notices.add(
        Notice(
          id: id,
          title: seed.title,
          body: seed.body,
          at: at,
          byName: author.name,
          byRole: author.role,
        ),
      );
      _log(
        at: at,
        userName: author.name,
        role: author.role,
        action: 'নোটিশ প্রকাশ',
        recordType: AuditRecordType.notice,
        recordKey: 'notice',
        recordId: id,
        recordLabel: seed.title,
      );
    }
  }

  /* ================= The presenter's demo citizen ================= */

  /// Four requests at different stages on one mobile number, so
  /// "আমার সব আবেদন" always has something worth showing without hunting for a
  /// tracking number mid-demo.
  void _assignDemoCitizen() {
    int? findEntry(bool Function(RegisterEntry e) test) {
      final i = entries.indexWhere(test);
      return i < 0 ? null : i;
    }

    final entryPicks = <int?>[
      findEntry((e) =>
          e.registerKey == 'streetlight' &&
          e.closedAt != null &&
          e.cancelled == null),
      findEntry((e) => e.registerKey == 'garbage' && e.closedAt == null),
      findEntry((e) => e.registerKey == 'cert-citizen' && e.status == 'paid') ??
          findEntry((e) => e.registerKey == 'cert-citizen' && e.closedAt == null),
    ];

    void retarget(String previousMobile, String trackingNo) {
      for (var i = 0; i < notifications.length; i++) {
        final n = notifications[i];
        if (n.mobile == previousMobile && n.trackingNo == trackingNo) {
          notifications[i] = n.copyWith(mobile: demoCitizenMobile);
        }
      }
    }

    for (final index in entryPicks) {
      if (index == null) continue;
      final entry = entries[index];
      final previous = entry.applicantMobile;
      entries[index] = entry.copyWith(
        applicantMobile: demoCitizenMobile,
        data: {
          ...entry.data,
          if (entry.data.containsKey('mobile')) 'mobile': demoCitizenMobile,
        },
      );
      retarget(previous, entry.trackingNo);
    }

    final li = licences
        .indexWhere((l) => l.licenceStatus == LicenceStatus.approved);
    if (li >= 0) {
      final licence = licences[li];
      final previous = licence.applicantMobile;
      licences[li] = licence.copyWith(
        applicantMobile: demoCitizenMobile,
        owner: licence.owner.copyWith(mobile: demoCitizenMobile),
      );
      retarget(previous, licence.trackingNo);
    }
  }
}

/// Short human label for a register entry, used in audit rows and search.
String entryLabelOf(RegisterEntry entry) {
  final config = getRegister(entry.registerKey);
  if (config == null) return entry.serialNo;
  final parts = config.fields
      .where(
        (f) =>
            f.showInBook &&
            f.type != FieldType.date &&
            f.type != FieldType.heirs &&
            f.type != FieldType.photo,
      )
      .take(2)
      .map((f) {
        final value = entry.data[f.key];
        return value is List ? '' : (value?.toString() ?? '');
      })
      .where((s) => s.isNotEmpty)
      .toList();
  return parts.isEmpty ? entry.serialNo : parts.join(' — ');
}
