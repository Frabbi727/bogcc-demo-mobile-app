// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OfficeSession _$OfficeSessionFromJson(Map<String, dynamic> json) =>
    _OfficeSession(
      role: $enumDecode(_$AppRoleEnumMap, json['role']),
      name: json['name'] as String,
      since: const LocalIsoConverter().fromJson(json['since'] as String),
    );

Map<String, dynamic> _$OfficeSessionToJson(_OfficeSession instance) =>
    <String, dynamic>{
      'role': _$AppRoleEnumMap[instance.role]!,
      'name': instance.name,
      'since': const LocalIsoConverter().toJson(instance.since),
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

_CitizenSession _$CitizenSessionFromJson(Map<String, dynamic> json) =>
    _CitizenSession(
      mobile: json['mobile'] as String,
      since: const LocalIsoConverter().fromJson(json['since'] as String),
    );

Map<String, dynamic> _$CitizenSessionToJson(_CitizenSession instance) =>
    <String, dynamic>{
      'mobile': instance.mobile,
      'since': const LocalIsoConverter().toJson(instance.since),
    };
