/// One line in a config-driven register book.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums.dart';
import 'base_record.dart';
import 'json.dart';
import 'shared.dart';

part 'register_entry.freezed.dart';
part 'register_entry.g.dart';

@freezed
abstract class RegisterEntry
    with _$RegisterEntry, BaseRecordMixin
    implements BaseRecord {
  const factory RegisterEntry({
    required String id,
    required String serviceKey,
    required String trackingNo,
    required Channel channel,
    required String applicantName,
    required String applicantMobile,
    required int ward,
    required String status,
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

    // --- register-specific ---
    required String registerKey,

    /// Formatted serial, e.g. `SL/2026-27/007`. Assigned on creation, because
    /// that is the moment the paper book would get its next line.
    required String serialNo,

    /// Values for the config's fields.
    ///
    /// Kept as a plain JSON map rather than a sealed union: the config already
    /// declares each field's type, so a union would force a custom converter on
    /// every read for safety the config gives us anyway. Typed accessors below
    /// do the narrowing at the point of use.
    @Default(<String, dynamic>{}) Map<String, dynamic> data,

    /// Certificates carry a fee; complaints do not.
    List<FeeLine>? feeLines,
    int? feeTotal,
    String? paymentId,
    String? receiptId,

    /// Assigned when the certificate is issued, not when it is applied for.
    String? certificateNo,
  }) = _RegisterEntry;

  const RegisterEntry._();

  factory RegisterEntry.fromJson(Map<String, dynamic> json) =>
      _$RegisterEntryFromJson(json);

  /* ---- typed accessors over `data` ---- */

  String? text(String key) => data[key]?.toString();

  num? number(String key) {
    final v = data[key];
    if (v is num) return v;
    return v == null ? null : num.tryParse(v.toString());
  }

  DateTime? date(String key) {
    final v = data[key];
    return v is String ? DateTime.tryParse(v) : null;
  }

  int? wardValue(String key) => number(key)?.toInt();

  List<Heir> heirs(String key) {
    final v = data[key];
    if (v is! List) return const [];
    return [
      for (final row in v)
        if (row is Map) Heir.fromJson(asJsonMap(row)),
    ];
  }

  List<PhotoRef> photoRefs(String key) {
    final v = data[key];
    if (v is! List) return const [];
    return [
      for (final row in v)
        if (row is Map) PhotoRef.fromJson(asJsonMap(row)),
    ];
  }
}
