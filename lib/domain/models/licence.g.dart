// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'licence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Business _$BusinessFromJson(Map<String, dynamic> json) => _Business(
  nameBn: json['nameBn'] as String,
  nameEn: json['nameEn'] as String,
  typeKey: json['typeKey'] as String,
  nature: $enumDecode(_$BusinessNatureEnumMap, json['nature']),
  address: json['address'] as String,
  area: json['area'] as String,
  ward: (json['ward'] as num).toInt(),
  holdingNo: json['holdingNo'] as String,
);

Map<String, dynamic> _$BusinessToJson(_Business instance) => <String, dynamic>{
  'nameBn': instance.nameBn,
  'nameEn': instance.nameEn,
  'typeKey': instance.typeKey,
  'nature': _$BusinessNatureEnumMap[instance.nature]!,
  'address': instance.address,
  'area': instance.area,
  'ward': instance.ward,
  'holdingNo': instance.holdingNo,
};

const _$BusinessNatureEnumMap = {
  BusinessNature.single: 'single',
  BusinessNature.partnership: 'partnership',
  BusinessNature.company: 'company',
};

_Owner _$OwnerFromJson(Map<String, dynamic> json) => _Owner(
  name: json['name'] as String,
  fatherName: json['fatherName'] as String,
  motherName: json['motherName'] as String,
  nid: json['nid'] as String,
  mobile: json['mobile'] as String,
);

Map<String, dynamic> _$OwnerToJson(_Owner instance) => <String, dynamic>{
  'name': instance.name,
  'fatherName': instance.fatherName,
  'motherName': instance.motherName,
  'nid': instance.nid,
  'mobile': instance.mobile,
};

_Licence _$LicenceFromJson(Map<String, dynamic> json) => _Licence(
  id: json['id'] as String,
  serviceKey: json['serviceKey'] as String,
  trackingNo: json['trackingNo'] as String,
  channel: $enumDecode(_$ChannelEnumMap, json['channel']),
  applicantName: json['applicantName'] as String,
  applicantMobile: json['applicantMobile'] as String,
  ward: (json['ward'] as num).toInt(),
  licenceStatus: $enumDecode(_$LicenceStatusEnumMap, json['licenceStatus']),
  history:
      (json['history'] as List<dynamic>?)
          ?.map((e) => HistoryStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <HistoryStep>[],
  createdAt: const LocalIsoConverter().fromJson(json['createdAt'] as String),
  dueAt: const LocalIsoConverter().fromJson(json['dueAt'] as String),
  closedAt: const LocalIsoNullableConverter().fromJson(
    json['closedAt'] as String?,
  ),
  serial: (json['serial'] as num?)?.toInt(),
  registerNo: json['registerNo'] as String?,
  fiscalYear: json['fiscalYear'] as String,
  cancelled: json['cancelled'] == null
      ? null
      : Cancellation.fromJson(json['cancelled'] as Map<String, dynamic>),
  feedback: json['feedback'] == null
      ? null
      : Feedback.fromJson(json['feedback'] as Map<String, dynamic>),
  photos:
      (json['photos'] as List<dynamic>?)
          ?.map((e) => PhotoRef.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PhotoRef>[],
  slaExempt: json['slaExempt'] as bool? ?? false,
  appNo: json['appNo'] as String,
  kind: json['kind'] as String,
  renewalOf: json['renewalOf'] as String?,
  business: Business.fromJson(json['business'] as Map<String, dynamic>),
  owner: Owner.fromJson(json['owner'] as Map<String, dynamic>),
  feeLines:
      (json['feeLines'] as List<dynamic>?)
          ?.map((e) => FeeLine.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <FeeLine>[],
  feeTotal: (json['feeTotal'] as num?)?.toInt() ?? 0,
  verificationNote: json['verificationNote'] as String?,
  paymentId: json['paymentId'] as String?,
  receiptId: json['receiptId'] as String?,
);

Map<String, dynamic> _$LicenceToJson(_Licence instance) => <String, dynamic>{
  'id': instance.id,
  'serviceKey': instance.serviceKey,
  'trackingNo': instance.trackingNo,
  'channel': _$ChannelEnumMap[instance.channel]!,
  'applicantName': instance.applicantName,
  'applicantMobile': instance.applicantMobile,
  'ward': instance.ward,
  'licenceStatus': _$LicenceStatusEnumMap[instance.licenceStatus]!,
  'history': instance.history.map((e) => e.toJson()).toList(),
  'createdAt': const LocalIsoConverter().toJson(instance.createdAt),
  'dueAt': const LocalIsoConverter().toJson(instance.dueAt),
  'closedAt': const LocalIsoNullableConverter().toJson(instance.closedAt),
  'serial': instance.serial,
  'registerNo': instance.registerNo,
  'fiscalYear': instance.fiscalYear,
  'cancelled': instance.cancelled?.toJson(),
  'feedback': instance.feedback?.toJson(),
  'photos': instance.photos.map((e) => e.toJson()).toList(),
  'slaExempt': instance.slaExempt,
  'appNo': instance.appNo,
  'kind': instance.kind,
  'renewalOf': instance.renewalOf,
  'business': instance.business.toJson(),
  'owner': instance.owner.toJson(),
  'feeLines': instance.feeLines.map((e) => e.toJson()).toList(),
  'feeTotal': instance.feeTotal,
  'verificationNote': instance.verificationNote,
  'paymentId': instance.paymentId,
  'receiptId': instance.receiptId,
};

const _$ChannelEnumMap = {Channel.office: 'office', Channel.online: 'online'};

const _$LicenceStatusEnumMap = {
  LicenceStatus.submitted: 'submitted',
  LicenceStatus.verified: 'verified',
  LicenceStatus.approved: 'approved',
  LicenceStatus.issued: 'issued',
  LicenceStatus.cancelled: 'cancelled',
};
