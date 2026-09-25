// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messaging.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      mobile: json['mobile'] as String,
      text: json['text'] as String,
      at: const LocalIsoConverter().fromJson(json['at'] as String),
      trackingNo: json['trackingNo'] as String?,
      read: json['read'] as bool? ?? false,
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mobile': instance.mobile,
      'text': instance.text,
      'at': const LocalIsoConverter().toJson(instance.at),
      'trackingNo': instance.trackingNo,
      'read': instance.read,
    };

_Notice _$NoticeFromJson(Map<String, dynamic> json) => _Notice(
  id: json['id'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  at: const LocalIsoConverter().fromJson(json['at'] as String),
  byName: json['byName'] as String,
  byRole: $enumDecode(_$AppRoleEnumMap, json['byRole']),
);

Map<String, dynamic> _$NoticeToJson(_Notice instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'at': const LocalIsoConverter().toJson(instance.at),
  'byName': instance.byName,
  'byRole': _$AppRoleEnumMap[instance.byRole]!,
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
