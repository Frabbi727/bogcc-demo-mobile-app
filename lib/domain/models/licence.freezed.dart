// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'licence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Business {

 String get nameBn;/// The one place English survives in the domain: a signboard and a bank
/// account both carry the Latin name.
 String get nameEn; String get typeKey; BusinessNature get nature; String get address; String get area; int get ward; String get holdingNo;
/// Create a copy of Business
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessCopyWith<Business> get copyWith => _$BusinessCopyWithImpl<Business>(this as Business, _$identity);

  /// Serializes this Business to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Business&&(identical(other.nameBn, nameBn) || other.nameBn == nameBn)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.typeKey, typeKey) || other.typeKey == typeKey)&&(identical(other.nature, nature) || other.nature == nature)&&(identical(other.address, address) || other.address == address)&&(identical(other.area, area) || other.area == area)&&(identical(other.ward, ward) || other.ward == ward)&&(identical(other.holdingNo, holdingNo) || other.holdingNo == holdingNo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nameBn,nameEn,typeKey,nature,address,area,ward,holdingNo);

@override
String toString() {
  return 'Business(nameBn: $nameBn, nameEn: $nameEn, typeKey: $typeKey, nature: $nature, address: $address, area: $area, ward: $ward, holdingNo: $holdingNo)';
}


}

/// @nodoc
abstract mixin class $BusinessCopyWith<$Res>  {
  factory $BusinessCopyWith(Business value, $Res Function(Business) _then) = _$BusinessCopyWithImpl;
@useResult
$Res call({
 String nameBn, String nameEn, String typeKey, BusinessNature nature, String address, String area, int ward, String holdingNo
});




}
/// @nodoc
class _$BusinessCopyWithImpl<$Res>
    implements $BusinessCopyWith<$Res> {
  _$BusinessCopyWithImpl(this._self, this._then);

  final Business _self;
  final $Res Function(Business) _then;

/// Create a copy of Business
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nameBn = null,Object? nameEn = null,Object? typeKey = null,Object? nature = null,Object? address = null,Object? area = null,Object? ward = null,Object? holdingNo = null,}) {
  return _then(_self.copyWith(
nameBn: null == nameBn ? _self.nameBn : nameBn // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,typeKey: null == typeKey ? _self.typeKey : typeKey // ignore: cast_nullable_to_non_nullable
as String,nature: null == nature ? _self.nature : nature // ignore: cast_nullable_to_non_nullable
as BusinessNature,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,ward: null == ward ? _self.ward : ward // ignore: cast_nullable_to_non_nullable
as int,holdingNo: null == holdingNo ? _self.holdingNo : holdingNo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Business].
extension BusinessPatterns on Business {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Business value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Business() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Business value)  $default,){
final _that = this;
switch (_that) {
case _Business():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Business value)?  $default,){
final _that = this;
switch (_that) {
case _Business() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nameBn,  String nameEn,  String typeKey,  BusinessNature nature,  String address,  String area,  int ward,  String holdingNo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Business() when $default != null:
return $default(_that.nameBn,_that.nameEn,_that.typeKey,_that.nature,_that.address,_that.area,_that.ward,_that.holdingNo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nameBn,  String nameEn,  String typeKey,  BusinessNature nature,  String address,  String area,  int ward,  String holdingNo)  $default,) {final _that = this;
switch (_that) {
case _Business():
return $default(_that.nameBn,_that.nameEn,_that.typeKey,_that.nature,_that.address,_that.area,_that.ward,_that.holdingNo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nameBn,  String nameEn,  String typeKey,  BusinessNature nature,  String address,  String area,  int ward,  String holdingNo)?  $default,) {final _that = this;
switch (_that) {
case _Business() when $default != null:
return $default(_that.nameBn,_that.nameEn,_that.typeKey,_that.nature,_that.address,_that.area,_that.ward,_that.holdingNo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Business implements Business {
  const _Business({required this.nameBn, required this.nameEn, required this.typeKey, required this.nature, required this.address, required this.area, required this.ward, required this.holdingNo});
  factory _Business.fromJson(Map<String, dynamic> json) => _$BusinessFromJson(json);

@override final  String nameBn;
/// The one place English survives in the domain: a signboard and a bank
/// account both carry the Latin name.
@override final  String nameEn;
@override final  String typeKey;
@override final  BusinessNature nature;
@override final  String address;
@override final  String area;
@override final  int ward;
@override final  String holdingNo;

/// Create a copy of Business
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessCopyWith<_Business> get copyWith => __$BusinessCopyWithImpl<_Business>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Business&&(identical(other.nameBn, nameBn) || other.nameBn == nameBn)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.typeKey, typeKey) || other.typeKey == typeKey)&&(identical(other.nature, nature) || other.nature == nature)&&(identical(other.address, address) || other.address == address)&&(identical(other.area, area) || other.area == area)&&(identical(other.ward, ward) || other.ward == ward)&&(identical(other.holdingNo, holdingNo) || other.holdingNo == holdingNo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nameBn,nameEn,typeKey,nature,address,area,ward,holdingNo);

@override
String toString() {
  return 'Business(nameBn: $nameBn, nameEn: $nameEn, typeKey: $typeKey, nature: $nature, address: $address, area: $area, ward: $ward, holdingNo: $holdingNo)';
}


}

/// @nodoc
abstract mixin class _$BusinessCopyWith<$Res> implements $BusinessCopyWith<$Res> {
  factory _$BusinessCopyWith(_Business value, $Res Function(_Business) _then) = __$BusinessCopyWithImpl;
@override @useResult
$Res call({
 String nameBn, String nameEn, String typeKey, BusinessNature nature, String address, String area, int ward, String holdingNo
});




}
/// @nodoc
class __$BusinessCopyWithImpl<$Res>
    implements _$BusinessCopyWith<$Res> {
  __$BusinessCopyWithImpl(this._self, this._then);

  final _Business _self;
  final $Res Function(_Business) _then;

/// Create a copy of Business
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nameBn = null,Object? nameEn = null,Object? typeKey = null,Object? nature = null,Object? address = null,Object? area = null,Object? ward = null,Object? holdingNo = null,}) {
  return _then(_Business(
nameBn: null == nameBn ? _self.nameBn : nameBn // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,typeKey: null == typeKey ? _self.typeKey : typeKey // ignore: cast_nullable_to_non_nullable
as String,nature: null == nature ? _self.nature : nature // ignore: cast_nullable_to_non_nullable
as BusinessNature,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,ward: null == ward ? _self.ward : ward // ignore: cast_nullable_to_non_nullable
as int,holdingNo: null == holdingNo ? _self.holdingNo : holdingNo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Owner {

 String get name; String get fatherName; String get motherName; String get nid; String get mobile;
/// Create a copy of Owner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerCopyWith<Owner> get copyWith => _$OwnerCopyWithImpl<Owner>(this as Owner, _$identity);

  /// Serializes this Owner to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Owner&&(identical(other.name, name) || other.name == name)&&(identical(other.fatherName, fatherName) || other.fatherName == fatherName)&&(identical(other.motherName, motherName) || other.motherName == motherName)&&(identical(other.nid, nid) || other.nid == nid)&&(identical(other.mobile, mobile) || other.mobile == mobile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,fatherName,motherName,nid,mobile);

@override
String toString() {
  return 'Owner(name: $name, fatherName: $fatherName, motherName: $motherName, nid: $nid, mobile: $mobile)';
}


}

/// @nodoc
abstract mixin class $OwnerCopyWith<$Res>  {
  factory $OwnerCopyWith(Owner value, $Res Function(Owner) _then) = _$OwnerCopyWithImpl;
@useResult
$Res call({
 String name, String fatherName, String motherName, String nid, String mobile
});




}
/// @nodoc
class _$OwnerCopyWithImpl<$Res>
    implements $OwnerCopyWith<$Res> {
  _$OwnerCopyWithImpl(this._self, this._then);

  final Owner _self;
  final $Res Function(Owner) _then;

/// Create a copy of Owner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? fatherName = null,Object? motherName = null,Object? nid = null,Object? mobile = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fatherName: null == fatherName ? _self.fatherName : fatherName // ignore: cast_nullable_to_non_nullable
as String,motherName: null == motherName ? _self.motherName : motherName // ignore: cast_nullable_to_non_nullable
as String,nid: null == nid ? _self.nid : nid // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Owner].
extension OwnerPatterns on Owner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Owner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Owner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Owner value)  $default,){
final _that = this;
switch (_that) {
case _Owner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Owner value)?  $default,){
final _that = this;
switch (_that) {
case _Owner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String fatherName,  String motherName,  String nid,  String mobile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Owner() when $default != null:
return $default(_that.name,_that.fatherName,_that.motherName,_that.nid,_that.mobile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String fatherName,  String motherName,  String nid,  String mobile)  $default,) {final _that = this;
switch (_that) {
case _Owner():
return $default(_that.name,_that.fatherName,_that.motherName,_that.nid,_that.mobile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String fatherName,  String motherName,  String nid,  String mobile)?  $default,) {final _that = this;
switch (_that) {
case _Owner() when $default != null:
return $default(_that.name,_that.fatherName,_that.motherName,_that.nid,_that.mobile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Owner implements Owner {
  const _Owner({required this.name, required this.fatherName, required this.motherName, required this.nid, required this.mobile});
  factory _Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);

@override final  String name;
@override final  String fatherName;
@override final  String motherName;
@override final  String nid;
@override final  String mobile;

/// Create a copy of Owner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerCopyWith<_Owner> get copyWith => __$OwnerCopyWithImpl<_Owner>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Owner&&(identical(other.name, name) || other.name == name)&&(identical(other.fatherName, fatherName) || other.fatherName == fatherName)&&(identical(other.motherName, motherName) || other.motherName == motherName)&&(identical(other.nid, nid) || other.nid == nid)&&(identical(other.mobile, mobile) || other.mobile == mobile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,fatherName,motherName,nid,mobile);

@override
String toString() {
  return 'Owner(name: $name, fatherName: $fatherName, motherName: $motherName, nid: $nid, mobile: $mobile)';
}


}

/// @nodoc
abstract mixin class _$OwnerCopyWith<$Res> implements $OwnerCopyWith<$Res> {
  factory _$OwnerCopyWith(_Owner value, $Res Function(_Owner) _then) = __$OwnerCopyWithImpl;
@override @useResult
$Res call({
 String name, String fatherName, String motherName, String nid, String mobile
});




}
/// @nodoc
class __$OwnerCopyWithImpl<$Res>
    implements _$OwnerCopyWith<$Res> {
  __$OwnerCopyWithImpl(this._self, this._then);

  final _Owner _self;
  final $Res Function(_Owner) _then;

/// Create a copy of Owner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? fatherName = null,Object? motherName = null,Object? nid = null,Object? mobile = null,}) {
  return _then(_Owner(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fatherName: null == fatherName ? _self.fatherName : fatherName // ignore: cast_nullable_to_non_nullable
as String,motherName: null == motherName ? _self.motherName : motherName // ignore: cast_nullable_to_non_nullable
as String,nid: null == nid ? _self.nid : nid // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Licence {

 String get id; String get serviceKey; String get trackingNo; Channel get channel; String get applicantName; String get applicantMobile; int get ward;/// Typed, unlike a register entry's free-form status: the licence workflow
/// is fixed and every screen switches on it exhaustively.
 LicenceStatus get licenceStatus; List<HistoryStep> get history;@LocalIsoConverter() DateTime get createdAt;@LocalIsoConverter() DateTime get dueAt;@LocalIsoNullableConverter() DateTime? get closedAt; int? get serial; String? get registerNo; String get fiscalYear; Cancellation? get cancelled; Feedback? get feedback; List<PhotoRef> get photos; bool get slaExempt;// --- licence-specific ---
 String get appNo;/// A renewal carries the licence number it renews.
 String get kind; String? get renewalOf; Business get business; Owner get owner; List<FeeLine> get feeLines; int get feeTotal; String? get verificationNote; String? get paymentId; String? get receiptId;
/// Create a copy of Licence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LicenceCopyWith<Licence> get copyWith => _$LicenceCopyWithImpl<Licence>(this as Licence, _$identity);

  /// Serializes this Licence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Licence&&(identical(other.id, id) || other.id == id)&&(identical(other.serviceKey, serviceKey) || other.serviceKey == serviceKey)&&(identical(other.trackingNo, trackingNo) || other.trackingNo == trackingNo)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.applicantName, applicantName) || other.applicantName == applicantName)&&(identical(other.applicantMobile, applicantMobile) || other.applicantMobile == applicantMobile)&&(identical(other.ward, ward) || other.ward == ward)&&(identical(other.licenceStatus, licenceStatus) || other.licenceStatus == licenceStatus)&&const DeepCollectionEquality().equals(other.history, history)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.registerNo, registerNo) || other.registerNo == registerNo)&&(identical(other.fiscalYear, fiscalYear) || other.fiscalYear == fiscalYear)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.slaExempt, slaExempt) || other.slaExempt == slaExempt)&&(identical(other.appNo, appNo) || other.appNo == appNo)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.renewalOf, renewalOf) || other.renewalOf == renewalOf)&&(identical(other.business, business) || other.business == business)&&(identical(other.owner, owner) || other.owner == owner)&&const DeepCollectionEquality().equals(other.feeLines, feeLines)&&(identical(other.feeTotal, feeTotal) || other.feeTotal == feeTotal)&&(identical(other.verificationNote, verificationNote) || other.verificationNote == verificationNote)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,serviceKey,trackingNo,channel,applicantName,applicantMobile,ward,licenceStatus,const DeepCollectionEquality().hash(history),createdAt,dueAt,closedAt,serial,registerNo,fiscalYear,cancelled,feedback,const DeepCollectionEquality().hash(photos),slaExempt,appNo,kind,renewalOf,business,owner,const DeepCollectionEquality().hash(feeLines),feeTotal,verificationNote,paymentId,receiptId]);

@override
String toString() {
  return 'Licence(id: $id, serviceKey: $serviceKey, trackingNo: $trackingNo, channel: $channel, applicantName: $applicantName, applicantMobile: $applicantMobile, ward: $ward, licenceStatus: $licenceStatus, history: $history, createdAt: $createdAt, dueAt: $dueAt, closedAt: $closedAt, serial: $serial, registerNo: $registerNo, fiscalYear: $fiscalYear, cancelled: $cancelled, feedback: $feedback, photos: $photos, slaExempt: $slaExempt, appNo: $appNo, kind: $kind, renewalOf: $renewalOf, business: $business, owner: $owner, feeLines: $feeLines, feeTotal: $feeTotal, verificationNote: $verificationNote, paymentId: $paymentId, receiptId: $receiptId)';
}


}

/// @nodoc
abstract mixin class $LicenceCopyWith<$Res>  {
  factory $LicenceCopyWith(Licence value, $Res Function(Licence) _then) = _$LicenceCopyWithImpl;
@useResult
$Res call({
 String id, String serviceKey, String trackingNo, Channel channel, String applicantName, String applicantMobile, int ward, LicenceStatus licenceStatus, List<HistoryStep> history,@LocalIsoConverter() DateTime createdAt,@LocalIsoConverter() DateTime dueAt,@LocalIsoNullableConverter() DateTime? closedAt, int? serial, String? registerNo, String fiscalYear, Cancellation? cancelled, Feedback? feedback, List<PhotoRef> photos, bool slaExempt, String appNo, String kind, String? renewalOf, Business business, Owner owner, List<FeeLine> feeLines, int feeTotal, String? verificationNote, String? paymentId, String? receiptId
});


$CancellationCopyWith<$Res>? get cancelled;$FeedbackCopyWith<$Res>? get feedback;$BusinessCopyWith<$Res> get business;$OwnerCopyWith<$Res> get owner;

}
/// @nodoc
class _$LicenceCopyWithImpl<$Res>
    implements $LicenceCopyWith<$Res> {
  _$LicenceCopyWithImpl(this._self, this._then);

  final Licence _self;
  final $Res Function(Licence) _then;

/// Create a copy of Licence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? serviceKey = null,Object? trackingNo = null,Object? channel = null,Object? applicantName = null,Object? applicantMobile = null,Object? ward = null,Object? licenceStatus = null,Object? history = null,Object? createdAt = null,Object? dueAt = null,Object? closedAt = freezed,Object? serial = freezed,Object? registerNo = freezed,Object? fiscalYear = null,Object? cancelled = freezed,Object? feedback = freezed,Object? photos = null,Object? slaExempt = null,Object? appNo = null,Object? kind = null,Object? renewalOf = freezed,Object? business = null,Object? owner = null,Object? feeLines = null,Object? feeTotal = null,Object? verificationNote = freezed,Object? paymentId = freezed,Object? receiptId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serviceKey: null == serviceKey ? _self.serviceKey : serviceKey // ignore: cast_nullable_to_non_nullable
as String,trackingNo: null == trackingNo ? _self.trackingNo : trackingNo // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel,applicantName: null == applicantName ? _self.applicantName : applicantName // ignore: cast_nullable_to_non_nullable
as String,applicantMobile: null == applicantMobile ? _self.applicantMobile : applicantMobile // ignore: cast_nullable_to_non_nullable
as String,ward: null == ward ? _self.ward : ward // ignore: cast_nullable_to_non_nullable
as int,licenceStatus: null == licenceStatus ? _self.licenceStatus : licenceStatus // ignore: cast_nullable_to_non_nullable
as LicenceStatus,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
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
as bool,appNo: null == appNo ? _self.appNo : appNo // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,renewalOf: freezed == renewalOf ? _self.renewalOf : renewalOf // ignore: cast_nullable_to_non_nullable
as String?,business: null == business ? _self.business : business // ignore: cast_nullable_to_non_nullable
as Business,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as Owner,feeLines: null == feeLines ? _self.feeLines : feeLines // ignore: cast_nullable_to_non_nullable
as List<FeeLine>,feeTotal: null == feeTotal ? _self.feeTotal : feeTotal // ignore: cast_nullable_to_non_nullable
as int,verificationNote: freezed == verificationNote ? _self.verificationNote : verificationNote // ignore: cast_nullable_to_non_nullable
as String?,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Licence
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
}/// Create a copy of Licence
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
}/// Create a copy of Licence
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessCopyWith<$Res> get business {
  
  return $BusinessCopyWith<$Res>(_self.business, (value) {
    return _then(_self.copyWith(business: value));
  });
}/// Create a copy of Licence
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerCopyWith<$Res> get owner {
  
  return $OwnerCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// Adds pattern-matching-related methods to [Licence].
extension LicencePatterns on Licence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Licence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Licence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Licence value)  $default,){
final _that = this;
switch (_that) {
case _Licence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Licence value)?  $default,){
final _that = this;
switch (_that) {
case _Licence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String serviceKey,  String trackingNo,  Channel channel,  String applicantName,  String applicantMobile,  int ward,  LicenceStatus licenceStatus,  List<HistoryStep> history, @LocalIsoConverter()  DateTime createdAt, @LocalIsoConverter()  DateTime dueAt, @LocalIsoNullableConverter()  DateTime? closedAt,  int? serial,  String? registerNo,  String fiscalYear,  Cancellation? cancelled,  Feedback? feedback,  List<PhotoRef> photos,  bool slaExempt,  String appNo,  String kind,  String? renewalOf,  Business business,  Owner owner,  List<FeeLine> feeLines,  int feeTotal,  String? verificationNote,  String? paymentId,  String? receiptId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Licence() when $default != null:
return $default(_that.id,_that.serviceKey,_that.trackingNo,_that.channel,_that.applicantName,_that.applicantMobile,_that.ward,_that.licenceStatus,_that.history,_that.createdAt,_that.dueAt,_that.closedAt,_that.serial,_that.registerNo,_that.fiscalYear,_that.cancelled,_that.feedback,_that.photos,_that.slaExempt,_that.appNo,_that.kind,_that.renewalOf,_that.business,_that.owner,_that.feeLines,_that.feeTotal,_that.verificationNote,_that.paymentId,_that.receiptId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String serviceKey,  String trackingNo,  Channel channel,  String applicantName,  String applicantMobile,  int ward,  LicenceStatus licenceStatus,  List<HistoryStep> history, @LocalIsoConverter()  DateTime createdAt, @LocalIsoConverter()  DateTime dueAt, @LocalIsoNullableConverter()  DateTime? closedAt,  int? serial,  String? registerNo,  String fiscalYear,  Cancellation? cancelled,  Feedback? feedback,  List<PhotoRef> photos,  bool slaExempt,  String appNo,  String kind,  String? renewalOf,  Business business,  Owner owner,  List<FeeLine> feeLines,  int feeTotal,  String? verificationNote,  String? paymentId,  String? receiptId)  $default,) {final _that = this;
switch (_that) {
case _Licence():
return $default(_that.id,_that.serviceKey,_that.trackingNo,_that.channel,_that.applicantName,_that.applicantMobile,_that.ward,_that.licenceStatus,_that.history,_that.createdAt,_that.dueAt,_that.closedAt,_that.serial,_that.registerNo,_that.fiscalYear,_that.cancelled,_that.feedback,_that.photos,_that.slaExempt,_that.appNo,_that.kind,_that.renewalOf,_that.business,_that.owner,_that.feeLines,_that.feeTotal,_that.verificationNote,_that.paymentId,_that.receiptId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String serviceKey,  String trackingNo,  Channel channel,  String applicantName,  String applicantMobile,  int ward,  LicenceStatus licenceStatus,  List<HistoryStep> history, @LocalIsoConverter()  DateTime createdAt, @LocalIsoConverter()  DateTime dueAt, @LocalIsoNullableConverter()  DateTime? closedAt,  int? serial,  String? registerNo,  String fiscalYear,  Cancellation? cancelled,  Feedback? feedback,  List<PhotoRef> photos,  bool slaExempt,  String appNo,  String kind,  String? renewalOf,  Business business,  Owner owner,  List<FeeLine> feeLines,  int feeTotal,  String? verificationNote,  String? paymentId,  String? receiptId)?  $default,) {final _that = this;
switch (_that) {
case _Licence() when $default != null:
return $default(_that.id,_that.serviceKey,_that.trackingNo,_that.channel,_that.applicantName,_that.applicantMobile,_that.ward,_that.licenceStatus,_that.history,_that.createdAt,_that.dueAt,_that.closedAt,_that.serial,_that.registerNo,_that.fiscalYear,_that.cancelled,_that.feedback,_that.photos,_that.slaExempt,_that.appNo,_that.kind,_that.renewalOf,_that.business,_that.owner,_that.feeLines,_that.feeTotal,_that.verificationNote,_that.paymentId,_that.receiptId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Licence extends Licence {
  const _Licence({required this.id, required this.serviceKey, required this.trackingNo, required this.channel, required this.applicantName, required this.applicantMobile, required this.ward, required this.licenceStatus, final  List<HistoryStep> history = const <HistoryStep>[], @LocalIsoConverter() required this.createdAt, @LocalIsoConverter() required this.dueAt, @LocalIsoNullableConverter() this.closedAt, this.serial, this.registerNo, required this.fiscalYear, this.cancelled, this.feedback, final  List<PhotoRef> photos = const <PhotoRef>[], this.slaExempt = false, required this.appNo, required this.kind, this.renewalOf, required this.business, required this.owner, final  List<FeeLine> feeLines = const <FeeLine>[], this.feeTotal = 0, this.verificationNote, this.paymentId, this.receiptId}): _history = history,_photos = photos,_feeLines = feeLines,super._();
  factory _Licence.fromJson(Map<String, dynamic> json) => _$LicenceFromJson(json);

@override final  String id;
@override final  String serviceKey;
@override final  String trackingNo;
@override final  Channel channel;
@override final  String applicantName;
@override final  String applicantMobile;
@override final  int ward;
/// Typed, unlike a register entry's free-form status: the licence workflow
/// is fixed and every screen switches on it exhaustively.
@override final  LicenceStatus licenceStatus;
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
// --- licence-specific ---
@override final  String appNo;
/// A renewal carries the licence number it renews.
@override final  String kind;
@override final  String? renewalOf;
@override final  Business business;
@override final  Owner owner;
 final  List<FeeLine> _feeLines;
@override@JsonKey() List<FeeLine> get feeLines {
  if (_feeLines is EqualUnmodifiableListView) return _feeLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feeLines);
}

@override@JsonKey() final  int feeTotal;
@override final  String? verificationNote;
@override final  String? paymentId;
@override final  String? receiptId;

/// Create a copy of Licence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LicenceCopyWith<_Licence> get copyWith => __$LicenceCopyWithImpl<_Licence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LicenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Licence&&(identical(other.id, id) || other.id == id)&&(identical(other.serviceKey, serviceKey) || other.serviceKey == serviceKey)&&(identical(other.trackingNo, trackingNo) || other.trackingNo == trackingNo)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.applicantName, applicantName) || other.applicantName == applicantName)&&(identical(other.applicantMobile, applicantMobile) || other.applicantMobile == applicantMobile)&&(identical(other.ward, ward) || other.ward == ward)&&(identical(other.licenceStatus, licenceStatus) || other.licenceStatus == licenceStatus)&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.registerNo, registerNo) || other.registerNo == registerNo)&&(identical(other.fiscalYear, fiscalYear) || other.fiscalYear == fiscalYear)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.slaExempt, slaExempt) || other.slaExempt == slaExempt)&&(identical(other.appNo, appNo) || other.appNo == appNo)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.renewalOf, renewalOf) || other.renewalOf == renewalOf)&&(identical(other.business, business) || other.business == business)&&(identical(other.owner, owner) || other.owner == owner)&&const DeepCollectionEquality().equals(other._feeLines, _feeLines)&&(identical(other.feeTotal, feeTotal) || other.feeTotal == feeTotal)&&(identical(other.verificationNote, verificationNote) || other.verificationNote == verificationNote)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,serviceKey,trackingNo,channel,applicantName,applicantMobile,ward,licenceStatus,const DeepCollectionEquality().hash(_history),createdAt,dueAt,closedAt,serial,registerNo,fiscalYear,cancelled,feedback,const DeepCollectionEquality().hash(_photos),slaExempt,appNo,kind,renewalOf,business,owner,const DeepCollectionEquality().hash(_feeLines),feeTotal,verificationNote,paymentId,receiptId]);

@override
String toString() {
  return 'Licence(id: $id, serviceKey: $serviceKey, trackingNo: $trackingNo, channel: $channel, applicantName: $applicantName, applicantMobile: $applicantMobile, ward: $ward, licenceStatus: $licenceStatus, history: $history, createdAt: $createdAt, dueAt: $dueAt, closedAt: $closedAt, serial: $serial, registerNo: $registerNo, fiscalYear: $fiscalYear, cancelled: $cancelled, feedback: $feedback, photos: $photos, slaExempt: $slaExempt, appNo: $appNo, kind: $kind, renewalOf: $renewalOf, business: $business, owner: $owner, feeLines: $feeLines, feeTotal: $feeTotal, verificationNote: $verificationNote, paymentId: $paymentId, receiptId: $receiptId)';
}


}

/// @nodoc
abstract mixin class _$LicenceCopyWith<$Res> implements $LicenceCopyWith<$Res> {
  factory _$LicenceCopyWith(_Licence value, $Res Function(_Licence) _then) = __$LicenceCopyWithImpl;
@override @useResult
$Res call({
 String id, String serviceKey, String trackingNo, Channel channel, String applicantName, String applicantMobile, int ward, LicenceStatus licenceStatus, List<HistoryStep> history,@LocalIsoConverter() DateTime createdAt,@LocalIsoConverter() DateTime dueAt,@LocalIsoNullableConverter() DateTime? closedAt, int? serial, String? registerNo, String fiscalYear, Cancellation? cancelled, Feedback? feedback, List<PhotoRef> photos, bool slaExempt, String appNo, String kind, String? renewalOf, Business business, Owner owner, List<FeeLine> feeLines, int feeTotal, String? verificationNote, String? paymentId, String? receiptId
});


@override $CancellationCopyWith<$Res>? get cancelled;@override $FeedbackCopyWith<$Res>? get feedback;@override $BusinessCopyWith<$Res> get business;@override $OwnerCopyWith<$Res> get owner;

}
/// @nodoc
class __$LicenceCopyWithImpl<$Res>
    implements _$LicenceCopyWith<$Res> {
  __$LicenceCopyWithImpl(this._self, this._then);

  final _Licence _self;
  final $Res Function(_Licence) _then;

/// Create a copy of Licence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? serviceKey = null,Object? trackingNo = null,Object? channel = null,Object? applicantName = null,Object? applicantMobile = null,Object? ward = null,Object? licenceStatus = null,Object? history = null,Object? createdAt = null,Object? dueAt = null,Object? closedAt = freezed,Object? serial = freezed,Object? registerNo = freezed,Object? fiscalYear = null,Object? cancelled = freezed,Object? feedback = freezed,Object? photos = null,Object? slaExempt = null,Object? appNo = null,Object? kind = null,Object? renewalOf = freezed,Object? business = null,Object? owner = null,Object? feeLines = null,Object? feeTotal = null,Object? verificationNote = freezed,Object? paymentId = freezed,Object? receiptId = freezed,}) {
  return _then(_Licence(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serviceKey: null == serviceKey ? _self.serviceKey : serviceKey // ignore: cast_nullable_to_non_nullable
as String,trackingNo: null == trackingNo ? _self.trackingNo : trackingNo // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel,applicantName: null == applicantName ? _self.applicantName : applicantName // ignore: cast_nullable_to_non_nullable
as String,applicantMobile: null == applicantMobile ? _self.applicantMobile : applicantMobile // ignore: cast_nullable_to_non_nullable
as String,ward: null == ward ? _self.ward : ward // ignore: cast_nullable_to_non_nullable
as int,licenceStatus: null == licenceStatus ? _self.licenceStatus : licenceStatus // ignore: cast_nullable_to_non_nullable
as LicenceStatus,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
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
as bool,appNo: null == appNo ? _self.appNo : appNo // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,renewalOf: freezed == renewalOf ? _self.renewalOf : renewalOf // ignore: cast_nullable_to_non_nullable
as String?,business: null == business ? _self.business : business // ignore: cast_nullable_to_non_nullable
as Business,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as Owner,feeLines: null == feeLines ? _self._feeLines : feeLines // ignore: cast_nullable_to_non_nullable
as List<FeeLine>,feeTotal: null == feeTotal ? _self.feeTotal : feeTotal // ignore: cast_nullable_to_non_nullable
as int,verificationNote: freezed == verificationNote ? _self.verificationNote : verificationNote // ignore: cast_nullable_to_non_nullable
as String?,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Licence
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
}/// Create a copy of Licence
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
}/// Create a copy of Licence
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessCopyWith<$Res> get business {
  
  return $BusinessCopyWith<$Res>(_self.business, (value) {
    return _then(_self.copyWith(business: value));
  });
}/// Create a copy of Licence
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerCopyWith<$Res> get owner {
  
  return $OwnerCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}

// dart format on
