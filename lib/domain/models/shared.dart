/// Value objects shared by every kind of record.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums.dart';
import 'json.dart';

part 'shared.freezed.dart';
part 'shared.g.dart';

/// One completed step, in the order it happened.
///
/// The web replaced per-status timestamps with this list, which is what lets a
/// record be re-read as a story rather than a row of columns — and what lets the
/// citizen view show only the steps and notes meant for them.
@freezed
abstract class HistoryStep with _$HistoryStep {
  const factory HistoryStep({
    required String status,
    @LocalIsoConverter() required DateTime at,
    required String byName,
    required AppRole byRole,
    String? note,

    /// Staff decide per note whether the citizen may read it. Defaults to
    /// private: an internal remark leaking to an applicant is the worse failure.
    @Default(false) bool publicNote,
  }) = _HistoryStep;

  factory HistoryStep.fromJson(Map<String, dynamic> json) =>
      _$HistoryStepFromJson(json);
}

/// Records are never deleted, only cancelled — and never without a reason.
@freezed
abstract class Cancellation with _$Cancellation {
  const factory Cancellation({
    @LocalIsoConverter() required DateTime at,
    required String by,
    required String reason,
  }) = _Cancellation;

  factory Cancellation.fromJson(Map<String, dynamic> json) =>
      _$CancellationFromJson(json);
}

@freezed
abstract class Feedback with _$Feedback {
  const factory Feedback({
    required int rating,
    String? comment,
    @LocalIsoConverter() required DateTime at,
  }) = _Feedback;

  factory Feedback.fromJson(Map<String, dynamic> json) =>
      _$FeedbackFromJson(json);
}

/// One row of the ওয়ারিশ certificate's heirs table.
@freezed
abstract class Heir with _$Heir {
  const factory Heir({
    required String name,
    required String relation,
    required int age,
  }) = _Heir;

  factory Heir.fromJson(Map<String, dynamic> json) => _$HeirFromJson(json);
}

/// A photo attached to a record.
///
/// Unlike the web, which stores a compressed data URL inline, this holds only a
/// reference: real photos are JPEG files under the app documents directory, and
/// seeded ones point at a bundled asset. Putting image bytes in the record would
/// bloat every read of every list.
@freezed
abstract class PhotoRef with _$PhotoRef {
  const factory PhotoRef({
    /// File name under the photos directory, or the asset path when [isAsset].
    required String id,
    @LocalIsoConverter() required DateTime at,
    required PhotoKind kind,
    String? caption,

    /// Seeded photos are bundled assets and must never be deleted on cleanup.
    @Default(false) bool isAsset,
  }) = _PhotoRef;

  factory PhotoRef.fromJson(Map<String, dynamic> json) =>
      _$PhotoRefFromJson(json);
}

/// One line of a fee breakdown, e.g. `লাইসেন্স ফি — ৳১,২০০`.
@freezed
abstract class FeeLine with _$FeeLine {
  const factory FeeLine({
    required String label,
    required int amount,
  }) = _FeeLine;

  factory FeeLine.fromJson(Map<String, dynamic> json) =>
      _$FeeLineFromJson(json);
}
