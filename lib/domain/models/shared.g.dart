// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HistoryStep _$HistoryStepFromJson(Map<String, dynamic> json) => _HistoryStep(
  status: json['status'] as String,
  at: const LocalIsoConverter().fromJson(json['at'] as String),
  byName: json['byName'] as String,
  byRole: $enumDecode(_$AppRoleEnumMap, json['byRole']),
  note: json['note'] as String?,
  publicNote: json['publicNote'] as bool? ?? false,
);

Map<String, dynamic> _$HistoryStepToJson(_HistoryStep instance) =>
    <String, dynamic>{
      'status': instance.status,
      'at': const LocalIsoConverter().toJson(instance.at),
      'byName': instance.byName,
      'byRole': _$AppRoleEnumMap[instance.byRole]!,
      'note': instance.note,
      'publicNote': instance.publicNote,
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

_Cancellation _$CancellationFromJson(Map<String, dynamic> json) =>
    _Cancellation(
      at: const LocalIsoConverter().fromJson(json['at'] as String),
      by: json['by'] as String,
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$CancellationToJson(_Cancellation instance) =>
    <String, dynamic>{
      'at': const LocalIsoConverter().toJson(instance.at),
      'by': instance.by,
      'reason': instance.reason,
    };

_Feedback _$FeedbackFromJson(Map<String, dynamic> json) => _Feedback(
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
  at: const LocalIsoConverter().fromJson(json['at'] as String),
);

Map<String, dynamic> _$FeedbackToJson(_Feedback instance) => <String, dynamic>{
  'rating': instance.rating,
  'comment': instance.comment,
  'at': const LocalIsoConverter().toJson(instance.at),
};

_Heir _$HeirFromJson(Map<String, dynamic> json) => _Heir(
  name: json['name'] as String,
  relation: json['relation'] as String,
  age: (json['age'] as num).toInt(),
);

Map<String, dynamic> _$HeirToJson(_Heir instance) => <String, dynamic>{
  'name': instance.name,
  'relation': instance.relation,
  'age': instance.age,
};

_PhotoRef _$PhotoRefFromJson(Map<String, dynamic> json) => _PhotoRef(
  id: json['id'] as String,
  at: const LocalIsoConverter().fromJson(json['at'] as String),
  kind: $enumDecode(_$PhotoKindEnumMap, json['kind']),
  caption: json['caption'] as String?,
  isAsset: json['isAsset'] as bool? ?? false,
);

Map<String, dynamic> _$PhotoRefToJson(_PhotoRef instance) => <String, dynamic>{
  'id': instance.id,
  'at': const LocalIsoConverter().toJson(instance.at),
  'kind': _$PhotoKindEnumMap[instance.kind]!,
  'caption': instance.caption,
  'isAsset': instance.isAsset,
};

const _$PhotoKindEnumMap = {
  PhotoKind.before: 'before',
  PhotoKind.after: 'after',
};

_FeeLine _$FeeLineFromJson(Map<String, dynamic> json) => _FeeLine(
  label: json['label'] as String,
  amount: (json['amount'] as num).toInt(),
);

Map<String, dynamic> _$FeeLineToJson(_FeeLine instance) => <String, dynamic>{
  'label': instance.label,
  'amount': instance.amount,
};
