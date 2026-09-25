// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisterEntry _$RegisterEntryFromJson(Map<String, dynamic> json) =>
    _RegisterEntry(
      id: json['id'] as String,
      serviceKey: json['serviceKey'] as String,
      trackingNo: json['trackingNo'] as String,
      channel: $enumDecode(_$ChannelEnumMap, json['channel']),
      applicantName: json['applicantName'] as String,
      applicantMobile: json['applicantMobile'] as String,
      ward: (json['ward'] as num).toInt(),
      status: json['status'] as String,
      history:
          (json['history'] as List<dynamic>?)
              ?.map((e) => HistoryStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <HistoryStep>[],
      createdAt: const LocalIsoConverter().fromJson(
        json['createdAt'] as String,
      ),
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
      registerKey: json['registerKey'] as String,
      serialNo: json['serialNo'] as String,
      data: json['data'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      feeLines: (json['feeLines'] as List<dynamic>?)
          ?.map((e) => FeeLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      feeTotal: (json['feeTotal'] as num?)?.toInt(),
      paymentId: json['paymentId'] as String?,
      receiptId: json['receiptId'] as String?,
      certificateNo: json['certificateNo'] as String?,
    );

Map<String, dynamic> _$RegisterEntryToJson(_RegisterEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceKey': instance.serviceKey,
      'trackingNo': instance.trackingNo,
      'channel': _$ChannelEnumMap[instance.channel]!,
      'applicantName': instance.applicantName,
      'applicantMobile': instance.applicantMobile,
      'ward': instance.ward,
      'status': instance.status,
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
      'registerKey': instance.registerKey,
      'serialNo': instance.serialNo,
      'data': instance.data,
      'feeLines': instance.feeLines?.map((e) => e.toJson()).toList(),
      'feeTotal': instance.feeTotal,
      'paymentId': instance.paymentId,
      'receiptId': instance.receiptId,
      'certificateNo': instance.certificateNo,
    };

const _$ChannelEnumMap = {Channel.office: 'office', Channel.online: 'online'};
