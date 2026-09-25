/// The append-only activity log.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums.dart';
import 'json.dart';

part 'audit_entry.freezed.dart';
part 'audit_entry.g.dart';

@freezed
abstract class FieldChange with _$FieldChange {
  const factory FieldChange({
    required String field,
    required String before,
    required String after,
  }) = _FieldChange;

  factory FieldChange.fromJson(Map<String, dynamic> json) =>
      _$FieldChangeFromJson(json);
}

/// One line of the audit log.
///
/// There is deliberately no action anywhere that edits or removes one of these,
/// and the repository that stores them exposes no update or delete method.
@freezed
abstract class AuditEntry with _$AuditEntry {
  const factory AuditEntry({
    required String id,
    @LocalIsoConverter() required DateTime at,
    required String userName,
    required AppRole role,
    required String action,
    required AuditRecordType recordType,
    required String recordKey,
    required String recordId,
    required String recordLabel,
    String? note,
    @Default(<FieldChange>[]) List<FieldChange> changes,
  }) = _AuditEntry;

  factory AuditEntry.fromJson(Map<String, dynamic> json) =>
      _$AuditEntryFromJson(json);
}
