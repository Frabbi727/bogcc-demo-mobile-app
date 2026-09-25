/// Trade licence — the one module with a bespoke shape rather than a
/// config-driven register, because of its fee lines, renewal and printed form.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums.dart';
import 'base_record.dart';
import 'json.dart';
import 'shared.dart';

part 'licence.freezed.dart';
part 'licence.g.dart';

@freezed
abstract class Business with _$Business {
  const factory Business({
    required String nameBn,

    /// The one place English survives in the domain: a signboard and a bank
    /// account both carry the Latin name.
    required String nameEn,
    required String typeKey,
    required BusinessNature nature,
    required String address,
    required String area,
    required int ward,
    required String holdingNo,
  }) = _Business;

  factory Business.fromJson(Map<String, dynamic> json) =>
      _$BusinessFromJson(json);
}

@freezed
abstract class Owner with _$Owner {
  const factory Owner({
    required String name,
    required String fatherName,
    required String motherName,
    required String nid,
    required String mobile,
  }) = _Owner;

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
}

@freezed
abstract class Licence with _$Licence, BaseRecordMixin implements BaseRecord {
  const factory Licence({
    required String id,
    required String serviceKey,
    required String trackingNo,
    required Channel channel,
    required String applicantName,
    required String applicantMobile,
    required int ward,

    /// Typed, unlike a register entry's free-form status: the licence workflow
    /// is fixed and every screen switches on it exhaustively.
    required LicenceStatus licenceStatus,
    @Default(<HistoryStep>[]) List<HistoryStep> history,
    @LocalIsoConverter() required DateTime createdAt,
    @LocalIsoConverter() required DateTime dueAt,
    @LocalIsoNullableConverter() DateTime? closedAt,
    int? serial,
    String? registerNo,
    required String fiscalYear,
    Cancellation? cancelled,
    Feedback? feedback,
    @Default(<PhotoRef>[]) List<PhotoRef> photos,
    @Default(false) bool slaExempt,

    // --- licence-specific ---
    required String appNo,

    /// A renewal carries the licence number it renews.
    required String kind,
    String? renewalOf,
    required Business business,
    required Owner owner,
    @Default(<FeeLine>[]) List<FeeLine> feeLines,
    @Default(0) int feeTotal,
    String? verificationNote,
    String? paymentId,
    String? receiptId,
  }) = _Licence;

  const Licence._();

  factory Licence.fromJson(Map<String, dynamic> json) =>
      _$LicenceFromJson(json);

  /// [BaseRecord] carries a free-form status so the generic screens can treat
  /// every record alike; the licence keeps its typed one as the source of truth.
  @override
  String get status => licenceStatus.name;

  bool get isRenewal => kind == 'renewal';
}
