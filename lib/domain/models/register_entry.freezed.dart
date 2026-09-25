// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterEntry {

 String get id; String get serviceKey; String get trackingNo; Channel get channel; String get applicantName; String get applicantMobile; int get ward; String get status; List<HistoryStep> get history;@LocalIsoConverter() DateTime get createdAt;@LocalIsoConverter() DateTime get dueAt;@LocalIsoNullableConverter() DateTime? get closedAt; int? get serial; String? get registerNo; String get fiscalYear; Cancellation? get cancelled; Feedback? get feedback; List<PhotoRef> get photos; bool get slaExempt;// --- register-specific ---
 String get registerKey;/// Formatted serial, e.g. `SL/2026-27/007`. Assigned on creation, because
/// that is the moment the paper book would get its next line.
 String get serialNo;/// Values for the config's fields.
///
/// Kept as a plain JSON map rather than a sealed union: the config already
/// declares each field's type, so a union would force a custom converter on
/// every read for safety the config gives us anyway. Typed accessors below
/// do the narrowing at the point of use.
 Map<String, dynamic> get data;/// Certificates carry a fee; complaints do not.
 List<FeeLine>? get feeLines; int? get feeTotal; String? get paymentId; String? get receiptId;/// Assigned when the certificate is issued, not when it is applied for.
 String? get certificateNo;
/// Create a copy of RegisterEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterEntryCopyWith<RegisterEntry> get copyWith => _$RegisterEntryCopyWithImpl<RegisterEntry>(this as RegisterEntry, _$identity);

  /// Serializes this RegisterEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.serviceKey, serviceKey) || other.serviceKey == serviceKey)&&(identical(other.trackingNo, trackingNo) || other.trackingNo == trackingNo)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.applicantName, applicantName) || other.applicantName == applicantName)&&(identical(other.applicantMobile, applicantMobile) || other.applicantMobile == applicantMobile)&&(identical(other.ward, ward) || other.ward == ward)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.history, history)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.registerNo, registerNo) || other.registerNo == registerNo)&&(identical(other.fiscalYear, fiscalYear) || other.fiscalYear == fiscalYear)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.slaExempt, slaExempt) || other.slaExempt == slaExempt)&&(identical(other.registerKey, registerKey) || other.registerKey == registerKey)&&(identical(other.serialNo, serialNo) || other.serialNo == serialNo)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.feeLines, feeLines)&&(identical(other.feeTotal, feeTotal) || other.feeTotal == feeTotal)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.certificateNo, certificateNo) || other.certificateNo == certificateNo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,serviceKey,trackingNo,channel,applicantName,applicantMobile,ward,status,const DeepCollectionEquality().hash(history),createdAt,dueAt,closedAt,serial,registerNo,fiscalYear,cancelled,feedback,const DeepCollectionEquality().hash(photos),slaExempt,registerKey,serialNo,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(feeLines),feeTotal,paymentId,receiptId,certificateNo]);

@override
String toString() {
  return 'RegisterEntry(id: $id, serviceKey: $serviceKey, trackingNo: $trackingNo, channel: $channel, applicantName: $applicantName, applicantMobile: $applicantMobile, ward: $ward, status: $status, history: $history, createdAt: $createdAt, dueAt: $dueAt, closedAt: $closedAt, serial: $serial, registerNo: $registerNo, fiscalYear: $fiscalYear, cancelled: $cancelled, feedback: $feedback, photos: $photos, slaExempt: $slaExempt, registerKey: $registerKey, serialNo: $serialNo, data: $data, feeLines: $feeLines, feeTotal: $feeTotal, paymentId: $paymentId, receiptId: $receiptId, certificateNo: $certificateNo)';
}


}

/// @nodoc
abstract mixin class $RegisterEntryCopyWith<$Res>  {
  factory $RegisterEntryCopyWith(RegisterEntry value, $Res Function(RegisterEntry) _then) = _$RegisterEntryCopyWithImpl;
@useResult
$Res call({
 String id, String serviceKey, String trackingNo, Channel channel, String applicantName, String applicantMobile, int ward, String status, List<HistoryStep> history,@LocalIsoConverter() DateTime createdAt,@LocalIsoConverter() DateTime dueAt,@LocalIsoNullableConverter() DateTime? closedAt, int? serial, String? registerNo, String fiscalYear, Cancellation? cancelled, Feedback? feedback, List<PhotoRef> photos, bool slaExempt, String registerKey, String serialNo, Map<String, dynamic> data, List<FeeLine>? feeLines, int? feeTotal, String? paymentId, String? receiptId, String? certificateNo
});


$CancellationCopyWith<$Res>? get cancelled;$FeedbackCopyWith<$Res>? get feedback;

}
/// @nodoc
class _$RegisterEntryCopyWithImpl<$Res>
    implements $RegisterEntryCopyWith<$Res> {
  _$RegisterEntryCopyWithImpl(this._self, this._then);

  final RegisterEntry _self;
  final $Res Function(RegisterEntry) _then;

/// Create a copy of RegisterEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? serviceKey = null,Object? trackingNo = null,Object? channel = null,Object? applicantName = null,Object? applicantMobile = null,Object? ward = null,Object? status = null,Object? history = null,Object? createdAt = null,Object? dueAt = null,Object? closedAt = freezed,Object? serial = freezed,Object? registerNo = freezed,Object? fiscalYear = null,Object? cancelled = freezed,Object? feedback = freezed,Object? photos = null,Object? slaExempt = null,Object? registerKey = null,Object? serialNo = null,Object? data = null,Object? feeLines = freezed,Object? feeTotal = freezed,Object? paymentId = freezed,Object? receiptId = freezed,Object? certificateNo = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serviceKey: null == serviceKey ? _self.serviceKey : serviceKey // ignore: cast_nullable_to_non_nullable
as String,trackingNo: null == trackingNo ? _self.trackingNo : trackingNo // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel,applicantName: null == applicantName ? _self.applicantName : applicantName // ignore: cast_nullable_to_non_nullable
as String,applicantMobile: null == applicantMobile ? _self.applicantMobile : applicantMobile // ignore: cast_nullable_to_non_nullable
as String,ward: null == ward ? _self.ward : ward // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<HistoryStep>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serial: freezed == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as int?,registerNo: freezed == registerNo ? _self.registerNo : registerNo // ignore: cast_nullable_to_non_nullable
as String?,fiscalYear: null == fiscalYear ? _self.fiscalYear : fiscalYear // ignore: cast_nullable_to_non_nullable
as String,cancelled: freezed == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as Cancellation?,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as Feedback?,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<PhotoRef>,slaExempt: null == slaExempt ? _self.slaExempt : slaExempt // ignore: cast_nullable_to_non_nullable
as bool,registerKey: null == registerKey ? _self.registerKey : registerKey // ignore: cast_nullable_to_non_nullable
as String,serialNo: null == serialNo ? _self.serialNo : serialNo // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,feeLines: freezed == feeLines ? _self.feeLines : feeLines // ignore: cast_nullable_to_non_nullable
as List<FeeLine>?,feeTotal: freezed == feeTotal ? _self.feeTotal : feeTotal // ignore: cast_nullable_to_non_nullable
as int?,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,certificateNo: freezed == certificateNo ? _self.certificateNo : certificateNo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of RegisterEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CancellationCopyWith<$Res>? get cancelled {
    if (_self.cancelled == null) {
    return null;
  }

  return $CancellationCopyWith<$Res>(_self.cancelled!, (value) {
    return _then(_self.copyWith(cancelled: value));
  });
}/// Create a copy of RegisterEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedbackCopyWith<$Res>? get feedback {
    if (_self.feedback == null) {
    return null;
  }

  return $FeedbackCopyWith<$Res>(_self.feedback!, (value) {
    return _then(_self.copyWith(feedback: value));
  });
}
}


/// Adds pattern-matching-related methods to [RegisterEntry].
extension RegisterEntryPatterns on RegisterEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterEntry value)  $default,){
final _that = this;
switch (_that) {
case _RegisterEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterEntry value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String serviceKey,  String trackingNo,  Channel channel,  String applicantName,  String applicantMobile,  int ward,  String status,  List<HistoryStep> history, @LocalIsoConverter()  DateTime createdAt, @LocalIsoConverter()  DateTime dueAt, @LocalIsoNullableConverter()  DateTime? closedAt,  int? serial,  String? registerNo,  String fiscalYear,  Cancellation? cancelled,  Feedback? feedback,  List<PhotoRef> photos,  bool slaExempt,  String registerKey,  String serialNo,  Map<String, dynamic> data,  List<FeeLine>? feeLines,  int? feeTotal,  String? paymentId,  String? receiptId,  String? certificateNo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterEntry() when $default != null:
return $default(_that.id,_that.serviceKey,_that.trackingNo,_that.channel,_that.applicantName,_that.applicantMobile,_that.ward,_that.status,_that.history,_that.createdAt,_that.dueAt,_that.closedAt,_that.serial,_that.registerNo,_that.fiscalYear,_that.cancelled,_that.feedback,_that.photos,_that.slaExempt,_that.registerKey,_that.serialNo,_that.data,_that.feeLines,_that.feeTotal,_that.paymentId,_that.receiptId,_that.certificateNo);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String serviceKey,  String trackingNo,  Channel channel,  String applicantName,  String applicantMobile,  int ward,  String status,  List<HistoryStep> history, @LocalIsoConverter()  DateTime createdAt, @LocalIsoConverter()  DateTime dueAt, @LocalIsoNullableConverter()  DateTime? closedAt,  int? serial,  String? registerNo,  String fiscalYear,  Cancellation? cancelled,  Feedback? feedback,  List<PhotoRef> photos,  bool slaExempt,  String registerKey,  String serialNo,  Map<String, dynamic> data,  List<FeeLine>? feeLines,  int? feeTotal,  String? paymentId,  String? receiptId,  String? certificateNo)  $default,) {final _that = this;
switch (_that) {
case _RegisterEntry():
return $default(_that.id,_that.serviceKey,_that.trackingNo,_that.channel,_that.applicantName,_that.applicantMobile,_that.ward,_that.status,_that.history,_that.createdAt,_that.dueAt,_that.closedAt,_that.serial,_that.registerNo,_that.fiscalYear,_that.cancelled,_that.feedback,_that.photos,_that.slaExempt,_that.registerKey,_that.serialNo,_that.data,_that.feeLines,_that.feeTotal,_that.paymentId,_that.receiptId,_that.certificateNo);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String serviceKey,  String trackingNo,  Channel channel,  String applicantName,  String applicantMobile,  int ward,  String status,  List<HistoryStep> history, @LocalIsoConverter()  DateTime createdAt, @LocalIsoConverter()  DateTime dueAt, @LocalIsoNullableConverter()  DateTime? closedAt,  int? serial,  String? registerNo,  String fiscalYear,  Cancellation? cancelled,  Feedback? feedback,  List<PhotoRef> photos,  bool slaExempt,  String registerKey,  String serialNo,  Map<String, dynamic> data,  List<FeeLine>? feeLines,  int? feeTotal,  String? paymentId,  String? receiptId,  String? certificateNo)?  $default,) {final _that = this;
switch (_that) {
case _RegisterEntry() when $default != null:
return $default(_that.id,_that.serviceKey,_that.trackingNo,_that.channel,_that.applicantName,_that.applicantMobile,_that.ward,_that.status,_that.history,_that.createdAt,_that.dueAt,_that.closedAt,_that.serial,_that.registerNo,_that.fiscalYear,_that.cancelled,_that.feedback,_that.photos,_that.slaExempt,_that.registerKey,_that.serialNo,_that.data,_that.feeLines,_that.feeTotal,_that.paymentId,_that.receiptId,_that.certificateNo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterEntry extends RegisterEntry {
  const _RegisterEntry({required this.id, required this.serviceKey, required this.trackingNo, required this.channel, required this.applicantName, required this.applicantMobile, required this.ward, required this.status, final  List<HistoryStep> history = const <HistoryStep>[], @LocalIsoConverter() required this.createdAt, @LocalIsoConverter() required this.dueAt, @LocalIsoNullableConverter() this.closedAt, this.serial, this.registerNo, required this.fiscalYear, this.cancelled, this.feedback, final  List<PhotoRef> photos = const <PhotoRef>[], this.slaExempt = false, required this.registerKey, required this.serialNo, final  Map<String, dynamic> data = const <String, dynamic>{}, final  List<FeeLine>? feeLines, this.feeTotal, this.paymentId, this.receiptId, this.certificateNo}): _history = history,_photos = photos,_data = data,_feeLines = feeLines,super._();
  factory _RegisterEntry.fromJson(Map<String, dynamic> json) => _$RegisterEntryFromJson(json);

@override final  String id;
@override final  String serviceKey;
@override final  String trackingNo;
@override final  Channel channel;
@override final  String applicantName;
@override final  String applicantMobile;
@override final  int ward;
@override final  String status;
 final  List<HistoryStep> _history;
@override@JsonKey() List<HistoryStep> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

@override@LocalIsoConverter() final  DateTime createdAt;
@override@LocalIsoConverter() final  DateTime dueAt;
@override@LocalIsoNullableConverter() final  DateTime? closedAt;
@override final  int? serial;
@override final  String? registerNo;
@override final  String fiscalYear;
@override final  Cancellation? cancelled;
@override final  Feedback? feedback;
 final  List<PhotoRef> _photos;
@override@JsonKey() List<PhotoRef> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override@JsonKey() final  bool slaExempt;
// --- register-specific ---
@override final  String registerKey;
/// Formatted serial, e.g. `SL/2026-27/007`. Assigned on creation, because
/// that is the moment the paper book would get its next line.
@override final  String serialNo;
/// Values for the config's fields.
///
/// Kept as a plain JSON map rather than a sealed union: the config already
/// declares each field's type, so a union would force a custom converter on
/// every read for safety the config gives us anyway. Typed accessors below
/// do the narrowing at the point of use.
 final  Map<String, dynamic> _data;
/// Values for the config's fields.
///
/// Kept as a plain JSON map rather than a sealed union: the config already
/// declares each field's type, so a union would force a custom converter on
/// every read for safety the config gives us anyway. Typed accessors below
/// do the narrowing at the point of use.
@override@JsonKey() Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}

/// Certificates carry a fee; complaints do not.
 final  List<FeeLine>? _feeLines;
/// Certificates carry a fee; complaints do not.
@override List<FeeLine>? get feeLines {
  final value = _feeLines;
  if (value == null) return null;
  if (_feeLines is EqualUnmodifiableListView) return _feeLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? feeTotal;
@override final  String? paymentId;
@override final  String? receiptId;
/// Assigned when the certificate is issued, not when it is applied for.
@override final  String? certificateNo;

/// Create a copy of RegisterEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterEntryCopyWith<_RegisterEntry> get copyWith => __$RegisterEntryCopyWithImpl<_RegisterEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.serviceKey, serviceKey) || other.serviceKey == serviceKey)&&(identical(other.trackingNo, trackingNo) || other.trackingNo == trackingNo)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.applicantName, applicantName) || other.applicantName == applicantName)&&(identical(other.applicantMobile, applicantMobile) || other.applicantMobile == applicantMobile)&&(identical(other.ward, ward) || other.ward == ward)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.registerNo, registerNo) || other.registerNo == registerNo)&&(identical(other.fiscalYear, fiscalYear) || other.fiscalYear == fiscalYear)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.slaExempt, slaExempt) || other.slaExempt == slaExempt)&&(identical(other.registerKey, registerKey) || other.registerKey == registerKey)&&(identical(other.serialNo, serialNo) || other.serialNo == serialNo)&&const DeepCollectionEquality().equals(other._data, _data)&&const DeepCollectionEquality().equals(other._feeLines, _feeLines)&&(identical(other.feeTotal, feeTotal) || other.feeTotal == feeTotal)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.certificateNo, certificateNo) || other.certificateNo == certificateNo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,serviceKey,trackingNo,channel,applicantName,applicantMobile,ward,status,const DeepCollectionEquality().hash(_history),createdAt,dueAt,closedAt,serial,registerNo,fiscalYear,cancelled,feedback,const DeepCollectionEquality().hash(_photos),slaExempt,registerKey,serialNo,const DeepCollectionEquality().hash(_data),const DeepCollectionEquality().hash(_feeLines),feeTotal,paymentId,receiptId,certificateNo]);

@override
String toString() {
  return 'RegisterEntry(id: $id, serviceKey: $serviceKey, trackingNo: $trackingNo, channel: $channel, applicantName: $applicantName, applicantMobile: $applicantMobile, ward: $ward, status: $status, history: $history, createdAt: $createdAt, dueAt: $dueAt, closedAt: $closedAt, serial: $serial, registerNo: $registerNo, fiscalYear: $fiscalYear, cancelled: $cancelled, feedback: $feedback, photos: $photos, slaExempt: $slaExempt, registerKey: $registerKey, serialNo: $serialNo, data: $data, feeLines: $feeLines, feeTotal: $feeTotal, paymentId: $paymentId, receiptId: $receiptId, certificateNo: $certificateNo)';
}


}

/// @nodoc
abstract mixin class _$RegisterEntryCopyWith<$Res> implements $RegisterEntryCopyWith<$Res> {
  factory _$RegisterEntryCopyWith(_RegisterEntry value, $Res Function(_RegisterEntry) _then) = __$RegisterEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String serviceKey, String trackingNo, Channel channel, String applicantName, String applicantMobile, int ward, String status, List<HistoryStep> history,@LocalIsoConverter() DateTime createdAt,@LocalIsoConverter() DateTime dueAt,@LocalIsoNullableConverter() DateTime? closedAt, int? serial, String? registerNo, String fiscalYear, Cancellation? cancelled, Feedback? feedback, List<PhotoRef> photos, bool slaExempt, String registerKey, String serialNo, Map<String, dynamic> data, List<FeeLine>? feeLines, int? feeTotal, String? paymentId, String? receiptId, String? certificateNo
});


@override $CancellationCopyWith<$Res>? get cancelled;@override $FeedbackCopyWith<$Res>? get feedback;

}
/// @nodoc
class __$RegisterEntryCopyWithImpl<$Res>
    implements _$RegisterEntryCopyWith<$Res> {
  __$RegisterEntryCopyWithImpl(this._self, this._then);

  final _RegisterEntry _self;
  final $Res Function(_RegisterEntry) _then;

/// Create a copy of RegisterEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? serviceKey = null,Object? trackingNo = null,Object? channel = null,Object? applicantName = null,Object? applicantMobile = null,Object? ward = null,Object? status = null,Object? history = null,Object? createdAt = null,Object? dueAt = null,Object? closedAt = freezed,Object? serial = freezed,Object? registerNo = freezed,Object? fiscalYear = null,Object? cancelled = freezed,Object? feedback = freezed,Object? photos = null,Object? slaExempt = null,Object? registerKey = null,Object? serialNo = null,Object? data = null,Object? feeLines = freezed,Object? feeTotal = freezed,Object? paymentId = freezed,Object? receiptId = freezed,Object? certificateNo = freezed,}) {
  return _then(_RegisterEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serviceKey: null == serviceKey ? _self.serviceKey : serviceKey // ignore: cast_nullable_to_non_nullable
as String,trackingNo: null == trackingNo ? _self.trackingNo : trackingNo // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel,applicantName: null == applicantName ? _self.applicantName : applicantName // ignore: cast_nullable_to_non_nullable
as String,applicantMobile: null == applicantMobile ? _self.applicantMobile : applicantMobile // ignore: cast_nullable_to_non_nullable
as String,ward: null == ward ? _self.ward : ward // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<HistoryStep>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serial: freezed == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as int?,registerNo: freezed == registerNo ? _self.registerNo : registerNo // ignore: cast_nullable_to_non_nullable
as String?,fiscalYear: null == fiscalYear ? _self.fiscalYear : fiscalYear // ignore: cast_nullable_to_non_nullable
as String,cancelled: freezed == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as Cancellation?,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as Feedback?,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<PhotoRef>,slaExempt: null == slaExempt ? _self.slaExempt : slaExempt // ignore: cast_nullable_to_non_nullable
as bool,registerKey: null == registerKey ? _self.registerKey : registerKey // ignore: cast_nullable_to_non_nullable
as String,serialNo: null == serialNo ? _self.serialNo : serialNo // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,feeLines: freezed == feeLines ? _self._feeLines : feeLines // ignore: cast_nullable_to_non_nullable
as List<FeeLine>?,feeTotal: freezed == feeTotal ? _self.feeTotal : feeTotal // ignore: cast_nullable_to_non_nullable
as int?,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,certificateNo: freezed == certificateNo ? _self.certificateNo : certificateNo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of RegisterEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CancellationCopyWith<$Res>? get cancelled {
    if (_self.cancelled == null) {
    return null;
  }

  return $CancellationCopyWith<$Res>(_self.cancelled!, (value) {
    return _then(_self.copyWith(cancelled: value));
  });
}/// Create a copy of RegisterEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedbackCopyWith<$Res>? get feedback {
    if (_self.feedback == null) {
    return null;
  }

  return $FeedbackCopyWith<$Res>(_self.feedback!, (value) {
    return _then(_self.copyWith(feedback: value));
  });
}
}

// dart format on
