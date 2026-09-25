// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TradeLicenceTarget _$TradeLicenceTargetFromJson(Map<String, dynamic> json) =>
    TradeLicenceTarget(
      id: json['id'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$TradeLicenceTargetToJson(TradeLicenceTarget instance) =>
    <String, dynamic>{'id': instance.id, 'runtimeType': instance.$type};

RegisterEntryTarget _$RegisterEntryTargetFromJson(Map<String, dynamic> json) =>
    RegisterEntryTarget(
      id: json['id'] as String,
      registerKey: json['registerKey'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$RegisterEntryTargetToJson(
  RegisterEntryTarget instance,
) => <String, dynamic>{
  'id': instance.id,
  'registerKey': instance.registerKey,
  'runtimeType': instance.$type,
};

HoldingTarget _$HoldingTargetFromJson(Map<String, dynamic> json) =>
    HoldingTarget(
      holdingNo: json['holdingNo'] as String,
      fiscalYear: json['fiscalYear'] as String,
      instalment: (json['instalment'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$HoldingTargetToJson(HoldingTarget instance) =>
    <String, dynamic>{
      'holdingNo': instance.holdingNo,
      'fiscalYear': instance.fiscalYear,
      'instalment': instance.instalment,
      'runtimeType': instance.$type,
    };

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: json['id'] as String,
  status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
  head: $enumDecode(_$RevenueHeadEnumMap, json['head']),
  channel: $enumDecode(_$ChannelEnumMap, json['channel']),
  purpose: json['purpose'] as String,
  payerName: json['payerName'] as String,
  payerMobile: json['payerMobile'] as String,
  feeLines:
      (json['feeLines'] as List<dynamic>?)
          ?.map((e) => FeeLine.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <FeeLine>[],
  total: (json['total'] as num).toInt(),
  createdAt: const LocalIsoConverter().fromJson(json['createdAt'] as String),
  paidAt: const LocalIsoNullableConverter().fromJson(json['paidAt'] as String?),
  mode: $enumDecodeNullable(_$PaymentModeEnumMap, json['mode']),
  method: $enumDecodeNullable(_$OnlineMethodEnumMap, json['method']),
  txnRef: json['txnRef'] as String?,
  receiptId: json['receiptId'] as String?,
  target: PaymentTarget.fromJson(json['target'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'status': _$PaymentStatusEnumMap[instance.status]!,
  'head': _$RevenueHeadEnumMap[instance.head]!,
  'channel': _$ChannelEnumMap[instance.channel]!,
  'purpose': instance.purpose,
  'payerName': instance.payerName,
  'payerMobile': instance.payerMobile,
  'feeLines': instance.feeLines.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'createdAt': const LocalIsoConverter().toJson(instance.createdAt),
  'paidAt': const LocalIsoNullableConverter().toJson(instance.paidAt),
  'mode': _$PaymentModeEnumMap[instance.mode],
  'method': _$OnlineMethodEnumMap[instance.method],
  'txnRef': instance.txnRef,
  'receiptId': instance.receiptId,
  'target': instance.target.toJson(),
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
};

const _$RevenueHeadEnumMap = {
  RevenueHead.tradeLicence: 'tradeLicence',
  RevenueHead.holdingTax: 'holdingTax',
  RevenueHead.certificate: 'certificate',
  RevenueHead.other: 'other',
};

const _$ChannelEnumMap = {Channel.office: 'office', Channel.online: 'online'};

const _$PaymentModeEnumMap = {
  PaymentMode.cash: 'cash',
  PaymentMode.bkash: 'bkash',
  PaymentMode.bank: 'bank',
};

const _$OnlineMethodEnumMap = {
  OnlineMethod.bkash: 'bkash',
  OnlineMethod.nagad: 'nagad',
  OnlineMethod.card: 'card',
};

_Receipt _$ReceiptFromJson(Map<String, dynamic> json) => _Receipt(
  id: json['id'] as String,
  no: (json['no'] as num).toInt(),
  receiptNo: json['receiptNo'] as String,
  bookNo: (json['bookNo'] as num).toInt(),
  pageNo: (json['pageNo'] as num).toInt(),
  fiscalYear: json['fiscalYear'] as String,
  head: $enumDecode(_$RevenueHeadEnumMap, json['head']),
  channel: $enumDecode(_$ChannelEnumMap, json['channel']),
  paymentId: json['paymentId'] as String,
  payerName: json['payerName'] as String,
  purpose: json['purpose'] as String,
  feeLines:
      (json['feeLines'] as List<dynamic>?)
          ?.map((e) => FeeLine.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <FeeLine>[],
  total: (json['total'] as num).toInt(),
  mode: $enumDecodeNullable(_$PaymentModeEnumMap, json['mode']),
  method: $enumDecodeNullable(_$OnlineMethodEnumMap, json['method']),
  txnRef: json['txnRef'] as String?,
  collectedBy: json['collectedBy'] as String,
  collectedAt: const LocalIsoConverter().fromJson(
    json['collectedAt'] as String,
  ),
  source: PaymentTarget.fromJson(json['source'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReceiptToJson(_Receipt instance) => <String, dynamic>{
  'id': instance.id,
  'no': instance.no,
  'receiptNo': instance.receiptNo,
  'bookNo': instance.bookNo,
  'pageNo': instance.pageNo,
  'fiscalYear': instance.fiscalYear,
  'head': _$RevenueHeadEnumMap[instance.head]!,
  'channel': _$ChannelEnumMap[instance.channel]!,
  'paymentId': instance.paymentId,
  'payerName': instance.payerName,
  'purpose': instance.purpose,
  'feeLines': instance.feeLines.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'mode': _$PaymentModeEnumMap[instance.mode],
  'method': _$OnlineMethodEnumMap[instance.method],
  'txnRef': instance.txnRef,
  'collectedBy': instance.collectedBy,
  'collectedAt': const LocalIsoConverter().toJson(instance.collectedAt),
  'source': instance.source.toJson(),
};
