/// The shape every service request shares.
library;

import '../enums.dart';
import '../rules/sla.dart';
import 'shared.dart';

/// Licence, complaint, certificate — all of them carry these.
///
/// This is what lets tracking, SLA, search, dashboards and audit work across
/// every module without knowing what kind of record they are looking at, and it
/// is the reason a new register needs no new screens.
///
/// It extends [SlaSubject] so any record can be measured against the charter;
/// implementers get [cancelledAt] for free from [cancelled].
abstract interface class BaseRecord implements SlaSubject {
  String get id;

  /// Which entry in the service catalogue this is a request for.
  String get serviceKey;

  /// Shown to the citizen, e.g. `BOGCC-2026-000123`.
  String get trackingNo;

  /// Whether it came in at the counter or online.
  Channel get channel;

  String get applicantName;
  String get applicantMobile;
  int get ward;

  /// Internal status key. The citizen-facing label comes from the catalogue,
  /// so staff wording can change without changing what the applicant reads.
  String get status;

  List<HistoryStep> get history;

  DateTime get createdAt;

  /// Charter deadline, in working days from [createdAt].
  @override
  DateTime get dueAt;

  @override
  DateTime? get closedAt;

  /// Register serial and number, written only when the register line is
  /// created — which is the moment the paper book would get a new line.
  int? get serial;
  String? get registerNo;

  String get fiscalYear;

  Cancellation? get cancelled;

  Feedback? get feedback;

  List<PhotoRef> get photos;

  @override
  bool get slaExempt;
}

/// Shared behaviour for anything implementing [BaseRecord].
mixin BaseRecordMixin implements BaseRecord {
  @override
  DateTime? get cancelledAt => cancelled?.at;

  /// A record is open until it is closed or cancelled.
  bool get isOpen => closedAt == null && cancelled == null;

  /// The most recent step, which is what a timeline shows at the top.
  HistoryStep? get lastStep => history.isEmpty ? null : history.last;

  /// Steps a citizen is allowed to read: every status change, but only the
  /// notes staff marked public.
  List<HistoryStep> get publicHistory => [
        for (final step in history)
          if (step.publicNote) step else step.copyWith(note: null),
      ];
}
