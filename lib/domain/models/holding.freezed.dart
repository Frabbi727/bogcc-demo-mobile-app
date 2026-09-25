// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'holding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HoldingInstalment {

/// Quarter, 1-4.
 int get no; int get amount;@LocalIsoNullableConverter() DateTime? get paidAt; String? get receiptId;
/// Create a copy of HoldingInstalment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoldingInstalmentCopyWith<HoldingInstalment> get copyWith => _$HoldingInstalmentCopyWithImpl<HoldingInstalment>(this as HoldingInstalment, _$identity);

  /// Serializes this HoldingInstalment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HoldingInstalment&&(identical(other.no, no) || other.no == no)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,no,amount,paidAt,receiptId);

@override
String toString() {
  return 'HoldingInstalment(no: $no, amount: $amount, paidAt: $paidAt, receiptId: $receiptId)';
}


}

/// @nodoc
abstract mixin class $HoldingInstalmentCopyWith<$Res>  {
  factory $HoldingInstalmentCopyWith(HoldingInstalment value, $Res Function(HoldingInstalment) _then) = _$HoldingInstalmentCopyWithImpl;
@useResult
$Res call({
 int no, int amount,@LocalIsoNullableConverter() DateTime? paidAt, String? receiptId
});




}
/// @nodoc
class _$HoldingInstalmentCopyWithImpl<$Res>
    implements $HoldingInstalmentCopyWith<$Res> {
  _$HoldingInstalmentCopyWithImpl(this._self, this._then);

  final HoldingInstalment _self;
  final $Res Function(HoldingInstalment) _then;

/// Create a copy of HoldingInstalment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? no = null,Object? amount = null,Object? paidAt = freezed,Object? receiptId = freezed,}) {
  return _then(_self.copyWith(
no: null == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HoldingInstalment].
extension HoldingInstalmentPatterns on HoldingInstalment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HoldingInstalment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HoldingInstalment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HoldingInstalment value)  $default,){
final _that = this;
switch (_that) {
case _HoldingInstalment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HoldingInstalment value)?  $default,){
final _that = this;
switch (_that) {
case _HoldingInstalment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int no,  int amount, @LocalIsoNullableConverter()  DateTime? paidAt,  String? receiptId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HoldingInstalment() when $default != null:
return $default(_that.no,_that.amount,_that.paidAt,_that.receiptId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int no,  int amount, @LocalIsoNullableConverter()  DateTime? paidAt,  String? receiptId)  $default,) {final _that = this;
switch (_that) {
case _HoldingInstalment():
return $default(_that.no,_that.amount,_that.paidAt,_that.receiptId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int no,  int amount, @LocalIsoNullableConverter()  DateTime? paidAt,  String? receiptId)?  $default,) {final _that = this;
switch (_that) {
case _HoldingInstalment() when $default != null:
return $default(_that.no,_that.amount,_that.paidAt,_that.receiptId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HoldingInstalment implements HoldingInstalment {
  const _HoldingInstalment({required this.no, required this.amount, @LocalIsoNullableConverter() this.paidAt, this.receiptId});
  factory _HoldingInstalment.fromJson(Map<String, dynamic> json) => _$HoldingInstalmentFromJson(json);

/// Quarter, 1-4.
@override final  int no;
@override final  int amount;
@override@LocalIsoNullableConverter() final  DateTime? paidAt;
@override final  String? receiptId;

/// Create a copy of HoldingInstalment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HoldingInstalmentCopyWith<_HoldingInstalment> get copyWith => __$HoldingInstalmentCopyWithImpl<_HoldingInstalment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HoldingInstalmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HoldingInstalment&&(identical(other.no, no) || other.no == no)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,no,amount,paidAt,receiptId);

@override
String toString() {
  return 'HoldingInstalment(no: $no, amount: $amount, paidAt: $paidAt, receiptId: $receiptId)';
}


}

/// @nodoc
abstract mixin class _$HoldingInstalmentCopyWith<$Res> implements $HoldingInstalmentCopyWith<$Res> {
  factory _$HoldingInstalmentCopyWith(_HoldingInstalment value, $Res Function(_HoldingInstalment) _then) = __$HoldingInstalmentCopyWithImpl;
@override @useResult
$Res call({
 int no, int amount,@LocalIsoNullableConverter() DateTime? paidAt, String? receiptId
});




}
/// @nodoc
class __$HoldingInstalmentCopyWithImpl<$Res>
    implements _$HoldingInstalmentCopyWith<$Res> {
  __$HoldingInstalmentCopyWithImpl(this._self, this._then);

  final _HoldingInstalment _self;
  final $Res Function(_HoldingInstalment) _then;

/// Create a copy of HoldingInstalment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? no = null,Object? amount = null,Object? paidAt = freezed,Object? receiptId = freezed,}) {
  return _then(_HoldingInstalment(
no: null == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HoldingBill {

 String get fiscalYear; List<FeeLine> get lines;/// Current year demand, before arrears.
 int get total; List<HoldingInstalment> get instalments;/// Unpaid amount carried over from earlier years.
 int get arrears;/// Demo surcharge on arrears.
 int get surcharge;
/// Create a copy of HoldingBill
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoldingBillCopyWith<HoldingBill> get copyWith => _$HoldingBillCopyWithImpl<HoldingBill>(this as HoldingBill, _$identity);

  /// Serializes this HoldingBill to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HoldingBill&&(identical(other.fiscalYear, fiscalYear) || other.fiscalYear == fiscalYear)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.instalments, instalments)&&(identical(other.arrears, arrears) || other.arrears == arrears)&&(identical(other.surcharge, surcharge) || other.surcharge == surcharge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fiscalYear,const DeepCollectionEquality().hash(lines),total,const DeepCollectionEquality().hash(instalments),arrears,surcharge);

@override
String toString() {
  return 'HoldingBill(fiscalYear: $fiscalYear, lines: $lines, total: $total, instalments: $instalments, arrears: $arrears, surcharge: $surcharge)';
}


}

/// @nodoc
abstract mixin class $HoldingBillCopyWith<$Res>  {
  factory $HoldingBillCopyWith(HoldingBill value, $Res Function(HoldingBill) _then) = _$HoldingBillCopyWithImpl;
@useResult
$Res call({
 String fiscalYear, List<FeeLine> lines, int total, List<HoldingInstalment> instalments, int arrears, int surcharge
});




}
/// @nodoc
class _$HoldingBillCopyWithImpl<$Res>
    implements $HoldingBillCopyWith<$Res> {
  _$HoldingBillCopyWithImpl(this._self, this._then);

  final HoldingBill _self;
  final $Res Function(HoldingBill) _then;

/// Create a copy of HoldingBill
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fiscalYear = null,Object? lines = null,Object? total = null,Object? instalments = null,Object? arrears = null,Object? surcharge = null,}) {
  return _then(_self.copyWith(
fiscalYear: null == fiscalYear ? _self.fiscalYear : fiscalYear // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<FeeLine>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,instalments: null == instalments ? _self.instalments : instalments // ignore: cast_nullable_to_non_nullable
as List<HoldingInstalment>,arrears: null == arrears ? _self.arrears : arrears // ignore: cast_nullable_to_non_nullable
as int,surcharge: null == surcharge ? _self.surcharge : surcharge // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HoldingBill].
extension HoldingBillPatterns on HoldingBill {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HoldingBill value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HoldingBill() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HoldingBill value)  $default,){
final _that = this;
switch (_that) {
case _HoldingBill():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HoldingBill value)?  $default,){
final _that = this;
switch (_that) {
case _HoldingBill() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fiscalYear,  List<FeeLine> lines,  int total,  List<HoldingInstalment> instalments,  int arrears,  int surcharge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HoldingBill() when $default != null:
return $default(_that.fiscalYear,_that.lines,_that.total,_that.instalments,_that.arrears,_that.surcharge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fiscalYear,  List<FeeLine> lines,  int total,  List<HoldingInstalment> instalments,  int arrears,  int surcharge)  $default,) {final _that = this;
switch (_that) {
case _HoldingBill():
return $default(_that.fiscalYear,_that.lines,_that.total,_that.instalments,_that.arrears,_that.surcharge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fiscalYear,  List<FeeLine> lines,  int total,  List<HoldingInstalment> instalments,  int arrears,  int surcharge)?  $default,) {final _that = this;
switch (_that) {
case _HoldingBill() when $default != null:
return $default(_that.fiscalYear,_that.lines,_that.total,_that.instalments,_that.arrears,_that.surcharge);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HoldingBill extends HoldingBill {
  const _HoldingBill({required this.fiscalYear, final  List<FeeLine> lines = const <FeeLine>[], required this.total, final  List<HoldingInstalment> instalments = const <HoldingInstalment>[], this.arrears = 0, this.surcharge = 0}): _lines = lines,_instalments = instalments,super._();
  factory _HoldingBill.fromJson(Map<String, dynamic> json) => _$HoldingBillFromJson(json);

@override final  String fiscalYear;
 final  List<FeeLine> _lines;
@override@JsonKey() List<FeeLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

/// Current year demand, before arrears.
@override final  int total;
 final  List<HoldingInstalment> _instalments;
@override@JsonKey() List<HoldingInstalment> get instalments {
  if (_instalments is EqualUnmodifiableListView) return _instalments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_instalments);
}

/// Unpaid amount carried over from earlier years.
@override@JsonKey() final  int arrears;
/// Demo surcharge on arrears.
@override@JsonKey() final  int surcharge;

/// Create a copy of HoldingBill
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HoldingBillCopyWith<_HoldingBill> get copyWith => __$HoldingBillCopyWithImpl<_HoldingBill>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HoldingBillToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HoldingBill&&(identical(other.fiscalYear, fiscalYear) || other.fiscalYear == fiscalYear)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._instalments, _instalments)&&(identical(other.arrears, arrears) || other.arrears == arrears)&&(identical(other.surcharge, surcharge) || other.surcharge == surcharge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fiscalYear,const DeepCollectionEquality().hash(_lines),total,const DeepCollectionEquality().hash(_instalments),arrears,surcharge);

@override
String toString() {
  return 'HoldingBill(fiscalYear: $fiscalYear, lines: $lines, total: $total, instalments: $instalments, arrears: $arrears, surcharge: $surcharge)';
}


}

/// @nodoc
abstract mixin class _$HoldingBillCopyWith<$Res> implements $HoldingBillCopyWith<$Res> {
  factory _$HoldingBillCopyWith(_HoldingBill value, $Res Function(_HoldingBill) _then) = __$HoldingBillCopyWithImpl;
@override @useResult
$Res call({
 String fiscalYear, List<FeeLine> lines, int total, List<HoldingInstalment> instalments, int arrears, int surcharge
});




}
/// @nodoc
class __$HoldingBillCopyWithImpl<$Res>
    implements _$HoldingBillCopyWith<$Res> {
  __$HoldingBillCopyWithImpl(this._self, this._then);

  final _HoldingBill _self;
  final $Res Function(_HoldingBill) _then;

/// Create a copy of HoldingBill
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fiscalYear = null,Object? lines = null,Object? total = null,Object? instalments = null,Object? arrears = null,Object? surcharge = null,}) {
  return _then(_HoldingBill(
fiscalYear: null == fiscalYear ? _self.fiscalYear : fiscalYear // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<FeeLine>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,instalments: null == instalments ? _self._instalments : instalments // ignore: cast_nullable_to_non_nullable
as List<HoldingInstalment>,arrears: null == arrears ? _self.arrears : arrears // ignore: cast_nullable_to_non_nullable
as int,surcharge: null == surcharge ? _self.surcharge : surcharge // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Holding {

 String get holdingNo; int get ward; String get ownerName; String get ownerMobile; String get address; String get area; PropertyType get propertyType; int get floors; int get annualValuation; List<HoldingBill> get bills;
/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoldingCopyWith<Holding> get copyWith => _$HoldingCopyWithImpl<Holding>(this as Holding, _$identity);

  /// Serializes this Holding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Holding&&(identical(other.holdingNo, holdingNo) || other.holdingNo == holdingNo)&&(identical(other.ward, ward) || other.ward == ward)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.ownerMobile, ownerMobile) || other.ownerMobile == ownerMobile)&&(identical(other.address, address) || other.address == address)&&(identical(other.area, area) || other.area == area)&&(identical(other.propertyType, propertyType) || other.propertyType == propertyType)&&(identical(other.floors, floors) || other.floors == floors)&&(identical(other.annualValuation, annualValuation) || other.annualValuation == annualValuation)&&const DeepCollectionEquality().equals(other.bills, bills));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,holdingNo,ward,ownerName,ownerMobile,address,area,propertyType,floors,annualValuation,const DeepCollectionEquality().hash(bills));

@override
String toString() {
  return 'Holding(holdingNo: $holdingNo, ward: $ward, ownerName: $ownerName, ownerMobile: $ownerMobile, address: $address, area: $area, propertyType: $propertyType, floors: $floors, annualValuation: $annualValuation, bills: $bills)';
}


}

/// @nodoc
abstract mixin class $HoldingCopyWith<$Res>  {
  factory $HoldingCopyWith(Holding value, $Res Function(Holding) _then) = _$HoldingCopyWithImpl;
@useResult
$Res call({
 String holdingNo, int ward, String ownerName, String ownerMobile, String address, String area, PropertyType propertyType, int floors, int annualValuation, List<HoldingBill> bills
});




}
/// @nodoc
class _$HoldingCopyWithImpl<$Res>
    implements $HoldingCopyWith<$Res> {
  _$HoldingCopyWithImpl(this._self, this._then);

  final Holding _self;
  final $Res Function(Holding) _then;

/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? holdingNo = null,Object? ward = null,Object? ownerName = null,Object? ownerMobile = null,Object? address = null,Object? area = null,Object? propertyType = null,Object? floors = null,Object? annualValuation = null,Object? bills = null,}) {
  return _then(_self.copyWith(
holdingNo: null == holdingNo ? _self.holdingNo : holdingNo // ignore: cast_nullable_to_non_nullable
as String,ward: null == ward ? _self.ward : ward // ignore: cast_nullable_to_non_nullable
as int,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,ownerMobile: null == ownerMobile ? _self.ownerMobile : ownerMobile // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,propertyType: null == propertyType ? _self.propertyType : propertyType // ignore: cast_nullable_to_non_nullable
as PropertyType,floors: null == floors ? _self.floors : floors // ignore: cast_nullable_to_non_nullable
as int,annualValuation: null == annualValuation ? _self.annualValuation : annualValuation // ignore: cast_nullable_to_non_nullable
as int,bills: null == bills ? _self.bills : bills // ignore: cast_nullable_to_non_nullable
as List<HoldingBill>,
  ));
}

}


/// Adds pattern-matching-related methods to [Holding].
extension HoldingPatterns on Holding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Holding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Holding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Holding value)  $default,){
final _that = this;
switch (_that) {
case _Holding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Holding value)?  $default,){
final _that = this;
switch (_that) {
case _Holding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String holdingNo,  int ward,  String ownerName,  String ownerMobile,  String address,  String area,  PropertyType propertyType,  int floors,  int annualValuation,  List<HoldingBill> bills)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Holding() when $default != null:
return $default(_that.holdingNo,_that.ward,_that.ownerName,_that.ownerMobile,_that.address,_that.area,_that.propertyType,_that.floors,_that.annualValuation,_that.bills);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String holdingNo,  int ward,  String ownerName,  String ownerMobile,  String address,  String area,  PropertyType propertyType,  int floors,  int annualValuation,  List<HoldingBill> bills)  $default,) {final _that = this;
switch (_that) {
case _Holding():
return $default(_that.holdingNo,_that.ward,_that.ownerName,_that.ownerMobile,_that.address,_that.area,_that.propertyType,_that.floors,_that.annualValuation,_that.bills);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String holdingNo,  int ward,  String ownerName,  String ownerMobile,  String address,  String area,  PropertyType propertyType,  int floors,  int annualValuation,  List<HoldingBill> bills)?  $default,) {final _that = this;
switch (_that) {
case _Holding() when $default != null:
return $default(_that.holdingNo,_that.ward,_that.ownerName,_that.ownerMobile,_that.address,_that.area,_that.propertyType,_that.floors,_that.annualValuation,_that.bills);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Holding extends Holding {
  const _Holding({required this.holdingNo, required this.ward, required this.ownerName, required this.ownerMobile, required this.address, required this.area, required this.propertyType, required this.floors, required this.annualValuation, final  List<HoldingBill> bills = const <HoldingBill>[]}): _bills = bills,super._();
  factory _Holding.fromJson(Map<String, dynamic> json) => _$HoldingFromJson(json);

@override final  String holdingNo;
@override final  int ward;
@override final  String ownerName;
@override final  String ownerMobile;
@override final  String address;
@override final  String area;
@override final  PropertyType propertyType;
@override final  int floors;
@override final  int annualValuation;
 final  List<HoldingBill> _bills;
@override@JsonKey() List<HoldingBill> get bills {
  if (_bills is EqualUnmodifiableListView) return _bills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bills);
}


/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HoldingCopyWith<_Holding> get copyWith => __$HoldingCopyWithImpl<_Holding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HoldingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Holding&&(identical(other.holdingNo, holdingNo) || other.holdingNo == holdingNo)&&(identical(other.ward, ward) || other.ward == ward)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.ownerMobile, ownerMobile) || other.ownerMobile == ownerMobile)&&(identical(other.address, address) || other.address == address)&&(identical(other.area, area) || other.area == area)&&(identical(other.propertyType, propertyType) || other.propertyType == propertyType)&&(identical(other.floors, floors) || other.floors == floors)&&(identical(other.annualValuation, annualValuation) || other.annualValuation == annualValuation)&&const DeepCollectionEquality().equals(other._bills, _bills));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,holdingNo,ward,ownerName,ownerMobile,address,area,propertyType,floors,annualValuation,const DeepCollectionEquality().hash(_bills));

@override
String toString() {
  return 'Holding(holdingNo: $holdingNo, ward: $ward, ownerName: $ownerName, ownerMobile: $ownerMobile, address: $address, area: $area, propertyType: $propertyType, floors: $floors, annualValuation: $annualValuation, bills: $bills)';
}


}

/// @nodoc
abstract mixin class _$HoldingCopyWith<$Res> implements $HoldingCopyWith<$Res> {
  factory _$HoldingCopyWith(_Holding value, $Res Function(_Holding) _then) = __$HoldingCopyWithImpl;
@override @useResult
$Res call({
 String holdingNo, int ward, String ownerName, String ownerMobile, String address, String area, PropertyType propertyType, int floors, int annualValuation, List<HoldingBill> bills
});




}
/// @nodoc
class __$HoldingCopyWithImpl<$Res>
    implements _$HoldingCopyWith<$Res> {
  __$HoldingCopyWithImpl(this._self, this._then);

  final _Holding _self;
  final $Res Function(_Holding) _then;

/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? holdingNo = null,Object? ward = null,Object? ownerName = null,Object? ownerMobile = null,Object? address = null,Object? area = null,Object? propertyType = null,Object? floors = null,Object? annualValuation = null,Object? bills = null,}) {
  return _then(_Holding(
holdingNo: null == holdingNo ? _self.holdingNo : holdingNo // ignore: cast_nullable_to_non_nullable
as String,ward: null == ward ? _self.ward : ward // ignore: cast_nullable_to_non_nullable
as int,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,ownerMobile: null == ownerMobile ? _self.ownerMobile : ownerMobile // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,propertyType: null == propertyType ? _self.propertyType : propertyType // ignore: cast_nullable_to_non_nullable
as PropertyType,floors: null == floors ? _self.floors : floors // ignore: cast_nullable_to_non_nullable
as int,annualValuation: null == annualValuation ? _self.annualValuation : annualValuation // ignore: cast_nullable_to_non_nullable
as int,bills: null == bills ? _self._bills : bills // ignore: cast_nullable_to_non_nullable
as List<HoldingBill>,
  ));
}


}

// dart format on
