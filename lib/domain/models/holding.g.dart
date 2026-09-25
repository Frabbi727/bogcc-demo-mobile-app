// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HoldingInstalment _$HoldingInstalmentFromJson(Map<String, dynamic> json) =>
    _HoldingInstalment(
      no: (json['no'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      paidAt: const LocalIsoNullableConverter().fromJson(
        json['paidAt'] as String?,
      ),
      receiptId: json['receiptId'] as String?,
    );

Map<String, dynamic> _$HoldingInstalmentToJson(_HoldingInstalment instance) =>
    <String, dynamic>{
      'no': instance.no,
      'amount': instance.amount,
      'paidAt': const LocalIsoNullableConverter().toJson(instance.paidAt),
      'receiptId': instance.receiptId,
    };

_HoldingBill _$HoldingBillFromJson(Map<String, dynamic> json) => _HoldingBill(
  fiscalYear: json['fiscalYear'] as String,
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => FeeLine.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <FeeLine>[],
  total: (json['total'] as num).toInt(),
  instalments:
      (json['instalments'] as List<dynamic>?)
          ?.map((e) => HoldingInstalment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <HoldingInstalment>[],
  arrears: (json['arrears'] as num?)?.toInt() ?? 0,
  surcharge: (json['surcharge'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$HoldingBillToJson(_HoldingBill instance) =>
    <String, dynamic>{
      'fiscalYear': instance.fiscalYear,
      'lines': instance.lines.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'instalments': instance.instalments.map((e) => e.toJson()).toList(),
      'arrears': instance.arrears,
      'surcharge': instance.surcharge,
    };

_Holding _$HoldingFromJson(Map<String, dynamic> json) => _Holding(
  holdingNo: json['holdingNo'] as String,
  ward: (json['ward'] as num).toInt(),
  ownerName: json['ownerName'] as String,
  ownerMobile: json['ownerMobile'] as String,
  address: json['address'] as String,
  area: json['area'] as String,
  propertyType: $enumDecode(_$PropertyTypeEnumMap, json['propertyType']),
  floors: (json['floors'] as num).toInt(),
  annualValuation: (json['annualValuation'] as num).toInt(),
  bills:
      (json['bills'] as List<dynamic>?)
          ?.map((e) => HoldingBill.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <HoldingBill>[],
);

Map<String, dynamic> _$HoldingToJson(_Holding instance) => <String, dynamic>{
  'holdingNo': instance.holdingNo,
  'ward': instance.ward,
  'ownerName': instance.ownerName,
  'ownerMobile': instance.ownerMobile,
  'address': instance.address,
  'area': instance.area,
  'propertyType': _$PropertyTypeEnumMap[instance.propertyType]!,
  'floors': instance.floors,
  'annualValuation': instance.annualValuation,
  'bills': instance.bills.map((e) => e.toJson()).toList(),
};

const _$PropertyTypeEnumMap = {
  PropertyType.residential: 'residential',
  PropertyType.commercial: 'commercial',
  PropertyType.mixed: 'mixed',
};
