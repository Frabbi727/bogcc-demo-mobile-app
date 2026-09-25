// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FieldChange _$FieldChangeFromJson(Map<String, dynamic> json) => _FieldChange(
  field: json['field'] as String,
  before: json['before'] as String,
  after: json['after'] as String,
);

Map<String, dynamic> _$FieldChangeToJson(_FieldChange instance) =>
    <String, dynamic>{
      'field': instance.field,
      'before': instance.before,
      'after': instance.after,
    };

_AuditEntry _$AuditEntryFromJson(Map<String, dynamic> json) => _AuditEntry(
  id: json['id'] as String,
  at: const LocalIsoConverter().fromJson(json['at'] as String),
  userName: json['userName'] as String,
  role: $enumDecode(_$AppRoleEnumMap, json['role']),
  action: json['action'] as String,
  recordType: $enumDecode(_$AuditRecordTypeEnumMap, json['recordType']),
  recordKey: json['recordKey'] as String,
  recordId: json['recordId'] as String,
  recordLabel: json['recordLabel'] as String,
  note: json['note'] as String?,
  changes:
      (json['changes'] as List<dynamic>?)
          ?.map((e) => FieldChange.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <FieldChange>[],
);

Map<String, dynamic> _$AuditEntryToJson(_AuditEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'at': const LocalIsoConverter().toJson(instance.at),
      'userName': instance.userName,
      'role': _$AppRoleEnumMap[instance.role]!,
      'action': instance.action,
      'recordType': _$AuditRecordTypeEnumMap[instance.recordType]!,
      'recordKey': instance.recordKey,
      'recordId': instance.recordId,
      'recordLabel': instance.recordLabel,
      'note': instance.note,
      'changes': instance.changes.map((e) => e.toJson()).toList(),
    };

const _$AppRoleEnumMap = {
  AppRole.citizen: 'citizen',
  AppRole.operator: 'operator',
  AppRole.inspector: 'inspector',
  AppRole.licenceOfficer: 'licenceOfficer',
  AppRole.accounts: 'accounts',
  AppRole.revenueOfficer: 'revenueOfficer',
  AppRole.electrician: 'electrician',
  AppRole.conservancy: 'conservancy',
  AppRole.councillor: 'councillor',
  AppRole.ceo: 'ceo',
  AppRole.mayor: 'mayor',
};

const _$AuditRecordTypeEnumMap = {
  AuditRecordType.tradeLicence: 'tradeLicence',
  AuditRecordType.registerEntry: 'registerEntry',
  AuditRecordType.receipt: 'receipt',
  AuditRecordType.payment: 'payment',
  AuditRecordType.holding: 'holding',
  AuditRecordType.notice: 'notice',
  AuditRecordType.system: 'system',
};
