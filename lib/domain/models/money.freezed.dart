// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'money.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
PaymentTarget _$PaymentTargetFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'tradeLicence':
          return TradeLicenceTarget.fromJson(
            json
          );
                case 'registerEntry':
          return RegisterEntryTarget.fromJson(
            json
          );
                case 'holding':
          return HoldingTarget.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'PaymentTarget',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$PaymentTarget {



  /// Serializes this PaymentTarget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentTarget);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaymentTarget()';
}


}

/// @nodoc
class $PaymentTargetCopyWith<$Res>  {
$PaymentTargetCopyWith(PaymentTarget _, $Res Function(PaymentTarget) __);
}


/// Adds pattern-matching-related methods to [PaymentTarget].
extension PaymentTargetPatterns on PaymentTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TradeLicenceTarget value)?  tradeLicence,TResult Function( RegisterEntryTarget value)?  registerEntry,TResult Function( HoldingTarget value)?  holding,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TradeLicenceTarget() when tradeLicence != null:
return tradeLicence(_that);case RegisterEntryTarget() when registerEntry != null:
return registerEntry(_that);case HoldingTarget() when holding != null:
return holding(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TradeLicenceTarget value)  tradeLicence,required TResult Function( RegisterEntryTarget value)  registerEntry,required TResult Function( HoldingTarget value)  holding,}){
final _that = this;
switch (_that) {
case TradeLicenceTarget():
return tradeLicence(_that);case RegisterEntryTarget():
return registerEntry(_that);case HoldingTarget():
return holding(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TradeLicenceTarget value)?  tradeLicence,TResult? Function( RegisterEntryTarget value)?  registerEntry,TResult? Function( HoldingTarget value)?  holding,}){
final _that = this;
switch (_that) {
case TradeLicenceTarget() when tradeLicence != null:
return tradeLicence(_that);case RegisterEntryTarget() when registerEntry != null:
return registerEntry(_that);case HoldingTarget() when holding != null:
return holding(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id)?  tradeLicence,TResult Function( String id,  String registerKey)?  registerEntry,TResult Function( String holdingNo,  String fiscalYear,  int instalment)?  holding,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TradeLicenceTarget() when tradeLicence != null:
return tradeLicence(_that.id);case RegisterEntryTarget() when registerEntry != null:
return registerEntry(_that.id,_that.registerKey);case HoldingTarget() when holding != null:
return holding(_that.holdingNo,_that.fiscalYear,_that.instalment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id)  tradeLicence,required TResult Function( String id,  String registerKey)  registerEntry,required TResult Function( String holdingNo,  String fiscalYear,  int instalment)  holding,}) {final _that = this;
switch (_that) {
case TradeLicenceTarget():
return tradeLicence(_that.id);case RegisterEntryTarget():
return registerEntry(_that.id,_that.registerKey);case HoldingTarget():
return holding(_that.holdingNo,_that.fiscalYear,_that.instalment);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id)?  tradeLicence,TResult? Function( String id,  String registerKey)?  registerEntry,TResult? Function( String holdingNo,  String fiscalYear,  int instalment)?  holding,}) {final _that = this;
switch (_that) {
case TradeLicenceTarget() when tradeLicence != null:
return tradeLicence(_that.id);case RegisterEntryTarget() when registerEntry != null:
return registerEntry(_that.id,_that.registerKey);case HoldingTarget() when holding != null:
return holding(_that.holdingNo,_that.fiscalYear,_that.instalment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class TradeLicenceTarget implements PaymentTarget {
  const TradeLicenceTarget({required this.id, final  String? $type}): $type = $type ?? 'tradeLicence';
  factory TradeLicenceTarget.fromJson(Map<String, dynamic> json) => _$TradeLicenceTargetFromJson(json);

 final  String id;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of PaymentTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TradeLicenceTargetCopyWith<TradeLicenceTarget> get copyWith => _$TradeLicenceTargetCopyWithImpl<TradeLicenceTarget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TradeLicenceTargetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TradeLicenceTarget&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'PaymentTarget.tradeLicence(id: $id)';
}


}

/// @nodoc
abstract mixin class $TradeLicenceTargetCopyWith<$Res> implements $PaymentTargetCopyWith<$Res> {
  factory $TradeLicenceTargetCopyWith(TradeLicenceTarget value, $Res Function(TradeLicenceTarget) _then) = _$TradeLicenceTargetCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$TradeLicenceTargetCopyWithImpl<$Res>
    implements $TradeLicenceTargetCopyWith<$Res> {
  _$TradeLicenceTargetCopyWithImpl(this._self, this._then);

  final TradeLicenceTarget _self;
  final $Res Function(TradeLicenceTarget) _then;

/// Create a copy of PaymentTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(TradeLicenceTarget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class RegisterEntryTarget implements PaymentTarget {
  const RegisterEntryTarget({required this.id, required this.registerKey, final  String? $type}): $type = $type ?? 'registerEntry';
  factory RegisterEntryTarget.fromJson(Map<String, dynamic> json) => _$RegisterEntryTargetFromJson(json);

 final  String id;
 final  String registerKey;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of PaymentTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterEntryTargetCopyWith<RegisterEntryTarget> get copyWith => _$RegisterEntryTargetCopyWithImpl<RegisterEntryTarget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterEntryTargetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterEntryTarget&&(identical(other.id, id) || other.id == id)&&(identical(other.registerKey, registerKey) || other.registerKey == registerKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,registerKey);

@override
String toString() {
  return 'PaymentTarget.registerEntry(id: $id, registerKey: $registerKey)';
}


}

/// @nodoc
abstract mixin class $RegisterEntryTargetCopyWith<$Res> implements $PaymentTargetCopyWith<$Res> {
  factory $RegisterEntryTargetCopyWith(RegisterEntryTarget value, $Res Function(RegisterEntryTarget) _then) = _$RegisterEntryTargetCopyWithImpl;
@useResult
$Res call({
 String id, String registerKey
});




}
/// @nodoc
class _$RegisterEntryTargetCopyWithImpl<$Res>
    implements $RegisterEntryTargetCopyWith<$Res> {
  _$RegisterEntryTargetCopyWithImpl(this._self, this._then);

  final RegisterEntryTarget _self;
  final $Res Function(RegisterEntryTarget) _then;

/// Create a copy of PaymentTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? registerKey = null,}) {
  return _then(RegisterEntryTarget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,registerKey: null == registerKey ? _self.registerKey : registerKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class HoldingTarget implements PaymentTarget {
  const HoldingTarget({required this.holdingNo, required this.fiscalYear, required this.instalment, final  String? $type}): $type = $type ?? 'holding';
  factory HoldingTarget.fromJson(Map<String, dynamic> json) => _$HoldingTargetFromJson(json);

 final  String holdingNo;
 final  String fiscalYear;
 final  int instalment;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of PaymentTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoldingTargetCopyWith<HoldingTarget> get copyWith => _$HoldingTargetCopyWithImpl<HoldingTarget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HoldingTargetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HoldingTarget&&(identical(other.holdingNo, holdingNo) || other.holdingNo == holdingNo)&&(identical(other.fiscalYear, fiscalYear) || other.fiscalYear == fiscalYear)&&(identical(other.instalment, instalment) || other.instalment == instalment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,holdingNo,fiscalYear,instalment);

@override
String toString() {
  return 'PaymentTarget.holding(holdingNo: $holdingNo, fiscalYear: $fiscalYear, instalment: $instalment)';
}


}

/// @nodoc
abstract mixin class $HoldingTargetCopyWith<$Res> implements $PaymentTargetCopyWith<$Res> {
  factory $HoldingTargetCopyWith(HoldingTarget value, $Res Function(HoldingTarget) _then) = _$HoldingTargetCopyWithImpl;
@useResult
$Res call({
 String holdingNo, String fiscalYear, int instalment
});




}
/// @nodoc
class _$HoldingTargetCopyWithImpl<$Res>
    implements $HoldingTargetCopyWith<$Res> {
  _$HoldingTargetCopyWithImpl(this._self, this._then);

  final HoldingTarget _self;
  final $Res Function(HoldingTarget) _then;

/// Create a copy of PaymentTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? holdingNo = null,Object? fiscalYear = null,Object? instalment = null,}) {
  return _then(HoldingTarget(
holdingNo: null == holdingNo ? _self.holdingNo : holdingNo // ignore: cast_nullable_to_non_nullable
as String,fiscalYear: null == fiscalYear ? _self.fiscalYear : fiscalYear // ignore: cast_nullable_to_non_nullable
as String,instalment: null == instalment ? _self.instalment : instalment // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Payment {

 String get id; PaymentStatus get status; RevenueHead get head; Channel get channel; String get purpose; String get payerName; String get payerMobile; List<FeeLine> get feeLines; int get total;@LocalIsoConverter() DateTime get createdAt;@LocalIsoNullableConverter() DateTime? get paidAt;/// Counter collections carry a mode; online payments a method and txn id.
 PaymentMode? get mode; OnlineMethod? get method; String? get txnRef; String? get receiptId; PaymentTarget get target;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.head, head) || other.head == head)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.payerName, payerName) || other.payerName == payerName)&&(identical(other.payerMobile, payerMobile) || other.payerMobile == payerMobile)&&const DeepCollectionEquality().equals(other.feeLines, feeLines)&&(identical(other.total, total) || other.total == total)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.method, method) || other.method == method)&&(identical(other.txnRef, txnRef) || other.txnRef == txnRef)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.target, target) || other.target == target));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,head,channel,purpose,payerName,payerMobile,const DeepCollectionEquality().hash(feeLines),total,createdAt,paidAt,mode,method,txnRef,receiptId,target);

@override
String toString() {
  return 'Payment(id: $id, status: $status, head: $head, channel: $channel, purpose: $purpose, payerName: $payerName, payerMobile: $payerMobile, feeLines: $feeLines, total: $total, createdAt: $createdAt, paidAt: $paidAt, mode: $mode, method: $method, txnRef: $txnRef, receiptId: $receiptId, target: $target)';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
 String id, PaymentStatus status, RevenueHead head, Channel channel, String purpose, String payerName, String payerMobile, List<FeeLine> feeLines, int total,@LocalIsoConverter() DateTime createdAt,@LocalIsoNullableConverter() DateTime? paidAt, PaymentMode? mode, OnlineMethod? method, String? txnRef, String? receiptId, PaymentTarget target
});


$PaymentTargetCopyWith<$Res> get target;

}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? head = null,Object? channel = null,Object? purpose = null,Object? payerName = null,Object? payerMobile = null,Object? feeLines = null,Object? total = null,Object? createdAt = null,Object? paidAt = freezed,Object? mode = freezed,Object? method = freezed,Object? txnRef = freezed,Object? receiptId = freezed,Object? target = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,head: null == head ? _self.head : head // ignore: cast_nullable_to_non_nullable
as RevenueHead,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,payerName: null == payerName ? _self.payerName : payerName // ignore: cast_nullable_to_non_nullable
as String,payerMobile: null == payerMobile ? _self.payerMobile : payerMobile // ignore: cast_nullable_to_non_nullable
as String,feeLines: null == feeLines ? _self.feeLines : feeLines // ignore: cast_nullable_to_non_nullable
as List<FeeLine>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PaymentMode?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as OnlineMethod?,txnRef: freezed == txnRef ? _self.txnRef : txnRef // ignore: cast_nullable_to_non_nullable
as String?,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as PaymentTarget,
  ));
}
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentTargetCopyWith<$Res> get target {
  
  return $PaymentTargetCopyWith<$Res>(_self.target, (value) {
    return _then(_self.copyWith(target: value));
  });
}
}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  PaymentStatus status,  RevenueHead head,  Channel channel,  String purpose,  String payerName,  String payerMobile,  List<FeeLine> feeLines,  int total, @LocalIsoConverter()  DateTime createdAt, @LocalIsoNullableConverter()  DateTime? paidAt,  PaymentMode? mode,  OnlineMethod? method,  String? txnRef,  String? receiptId,  PaymentTarget target)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.status,_that.head,_that.channel,_that.purpose,_that.payerName,_that.payerMobile,_that.feeLines,_that.total,_that.createdAt,_that.paidAt,_that.mode,_that.method,_that.txnRef,_that.receiptId,_that.target);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  PaymentStatus status,  RevenueHead head,  Channel channel,  String purpose,  String payerName,  String payerMobile,  List<FeeLine> feeLines,  int total, @LocalIsoConverter()  DateTime createdAt, @LocalIsoNullableConverter()  DateTime? paidAt,  PaymentMode? mode,  OnlineMethod? method,  String? txnRef,  String? receiptId,  PaymentTarget target)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.status,_that.head,_that.channel,_that.purpose,_that.payerName,_that.payerMobile,_that.feeLines,_that.total,_that.createdAt,_that.paidAt,_that.mode,_that.method,_that.txnRef,_that.receiptId,_that.target);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  PaymentStatus status,  RevenueHead head,  Channel channel,  String purpose,  String payerName,  String payerMobile,  List<FeeLine> feeLines,  int total, @LocalIsoConverter()  DateTime createdAt, @LocalIsoNullableConverter()  DateTime? paidAt,  PaymentMode? mode,  OnlineMethod? method,  String? txnRef,  String? receiptId,  PaymentTarget target)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.status,_that.head,_that.channel,_that.purpose,_that.payerName,_that.payerMobile,_that.feeLines,_that.total,_that.createdAt,_that.paidAt,_that.mode,_that.method,_that.txnRef,_that.receiptId,_that.target);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payment implements Payment {
  const _Payment({required this.id, required this.status, required this.head, required this.channel, required this.purpose, required this.payerName, required this.payerMobile, final  List<FeeLine> feeLines = const <FeeLine>[], required this.total, @LocalIsoConverter() required this.createdAt, @LocalIsoNullableConverter() this.paidAt, this.mode, this.method, this.txnRef, this.receiptId, required this.target}): _feeLines = feeLines;
  factory _Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

@override final  String id;
@override final  PaymentStatus status;
@override final  RevenueHead head;
@override final  Channel channel;
@override final  String purpose;
@override final  String payerName;
@override final  String payerMobile;
 final  List<FeeLine> _feeLines;
@override@JsonKey() List<FeeLine> get feeLines {
  if (_feeLines is EqualUnmodifiableListView) return _feeLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feeLines);
}

@override final  int total;
@override@LocalIsoConverter() final  DateTime createdAt;
@override@LocalIsoNullableConverter() final  DateTime? paidAt;
/// Counter collections carry a mode; online payments a method and txn id.
@override final  PaymentMode? mode;
@override final  OnlineMethod? method;
@override final  String? txnRef;
@override final  String? receiptId;
@override final  PaymentTarget target;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.head, head) || other.head == head)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.payerName, payerName) || other.payerName == payerName)&&(identical(other.payerMobile, payerMobile) || other.payerMobile == payerMobile)&&const DeepCollectionEquality().equals(other._feeLines, _feeLines)&&(identical(other.total, total) || other.total == total)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.method, method) || other.method == method)&&(identical(other.txnRef, txnRef) || other.txnRef == txnRef)&&(identical(other.receiptId, receiptId) || other.receiptId == receiptId)&&(identical(other.target, target) || other.target == target));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,head,channel,purpose,payerName,payerMobile,const DeepCollectionEquality().hash(_feeLines),total,createdAt,paidAt,mode,method,txnRef,receiptId,target);

@override
String toString() {
  return 'Payment(id: $id, status: $status, head: $head, channel: $channel, purpose: $purpose, payerName: $payerName, payerMobile: $payerMobile, feeLines: $feeLines, total: $total, createdAt: $createdAt, paidAt: $paidAt, mode: $mode, method: $method, txnRef: $txnRef, receiptId: $receiptId, target: $target)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, PaymentStatus status, RevenueHead head, Channel channel, String purpose, String payerName, String payerMobile, List<FeeLine> feeLines, int total,@LocalIsoConverter() DateTime createdAt,@LocalIsoNullableConverter() DateTime? paidAt, PaymentMode? mode, OnlineMethod? method, String? txnRef, String? receiptId, PaymentTarget target
});


@override $PaymentTargetCopyWith<$Res> get target;

}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? head = null,Object? channel = null,Object? purpose = null,Object? payerName = null,Object? payerMobile = null,Object? feeLines = null,Object? total = null,Object? createdAt = null,Object? paidAt = freezed,Object? mode = freezed,Object? method = freezed,Object? txnRef = freezed,Object? receiptId = freezed,Object? target = null,}) {
  return _then(_Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,head: null == head ? _self.head : head // ignore: cast_nullable_to_non_nullable
as RevenueHead,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,payerName: null == payerName ? _self.payerName : payerName // ignore: cast_nullable_to_non_nullable
as String,payerMobile: null == payerMobile ? _self.payerMobile : payerMobile // ignore: cast_nullable_to_non_nullable
as String,feeLines: null == feeLines ? _self._feeLines : feeLines // ignore: cast_nullable_to_non_nullable
as List<FeeLine>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PaymentMode?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as OnlineMethod?,txnRef: freezed == txnRef ? _self.txnRef : txnRef // ignore: cast_nullable_to_non_nullable
as String?,receiptId: freezed == receiptId ? _self.receiptId : receiptId // ignore: cast_nullable_to_non_nullable
as String?,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as PaymentTarget,
  ));
}

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentTargetCopyWith<$Res> get target {
  
  return $PaymentTargetCopyWith<$Res>(_self.target, (value) {
    return _then(_self.copyWith(target: value));
  });
}
}


/// @nodoc
mixin _$Receipt {

 String get id;/// Sequential within the fiscal year, and gapless: a missing receipt number
/// is what an auditor looks for first.
 int get no; String get receiptNo;/// Where this would sit in the paper receipt book.
 int get bookNo; int get pageNo; String get fiscalYear; RevenueHead get head; Channel get channel; String get paymentId; String get payerName; String get purpose; List<FeeLine> get feeLines; int get total; PaymentMode? get mode; OnlineMethod? get method; String? get txnRef; String get collectedBy;@LocalIsoConverter() DateTime get collectedAt; PaymentTarget get source;
/// Create a copy of Receipt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptCopyWith<Receipt> get copyWith => _$ReceiptCopyWithImpl<Receipt>(this as Receipt, _$identity);

  /// Serializes this Receipt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Receipt&&(identical(other.id, id) || other.id == id)&&(identical(other.no, no) || other.no == no)&&(identical(other.receiptNo, receiptNo) || other.receiptNo == receiptNo)&&(identical(other.bookNo, bookNo) || other.bookNo == bookNo)&&(identical(other.pageNo, pageNo) || other.pageNo == pageNo)&&(identical(other.fiscalYear, fiscalYear) || other.fiscalYear == fiscalYear)&&(identical(other.head, head) || other.head == head)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.payerName, payerName) || other.payerName == payerName)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&const DeepCollectionEquality().equals(other.feeLines, feeLines)&&(identical(other.total, total) || other.total == total)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.method, method) || other.method == method)&&(identical(other.txnRef, txnRef) || other.txnRef == txnRef)&&(identical(other.collectedBy, collectedBy) || other.collectedBy == collectedBy)&&(identical(other.collectedAt, collectedAt) || other.collectedAt == collectedAt)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,no,receiptNo,bookNo,pageNo,fiscalYear,head,channel,paymentId,payerName,purpose,const DeepCollectionEquality().hash(feeLines),total,mode,method,txnRef,collectedBy,collectedAt,source]);

@override
String toString() {
  return 'Receipt(id: $id, no: $no, receiptNo: $receiptNo, bookNo: $bookNo, pageNo: $pageNo, fiscalYear: $fiscalYear, head: $head, channel: $channel, paymentId: $paymentId, payerName: $payerName, purpose: $purpose, feeLines: $feeLines, total: $total, mode: $mode, method: $method, txnRef: $txnRef, collectedBy: $collectedBy, collectedAt: $collectedAt, source: $source)';
}


}

/// @nodoc
abstract mixin class $ReceiptCopyWith<$Res>  {
  factory $ReceiptCopyWith(Receipt value, $Res Function(Receipt) _then) = _$ReceiptCopyWithImpl;
@useResult
$Res call({
 String id, int no, String receiptNo, int bookNo, int pageNo, String fiscalYear, RevenueHead head, Channel channel, String paymentId, String payerName, String purpose, List<FeeLine> feeLines, int total, PaymentMode? mode, OnlineMethod? method, String? txnRef, String collectedBy,@LocalIsoConverter() DateTime collectedAt, PaymentTarget source
});


$PaymentTargetCopyWith<$Res> get source;

}
/// @nodoc
class _$ReceiptCopyWithImpl<$Res>
    implements $ReceiptCopyWith<$Res> {
  _$ReceiptCopyWithImpl(this._self, this._then);

  final Receipt _self;
  final $Res Function(Receipt) _then;

/// Create a copy of Receipt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? no = null,Object? receiptNo = null,Object? bookNo = null,Object? pageNo = null,Object? fiscalYear = null,Object? head = null,Object? channel = null,Object? paymentId = null,Object? payerName = null,Object? purpose = null,Object? feeLines = null,Object? total = null,Object? mode = freezed,Object? method = freezed,Object? txnRef = freezed,Object? collectedBy = null,Object? collectedAt = null,Object? source = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,no: null == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as int,receiptNo: null == receiptNo ? _self.receiptNo : receiptNo // ignore: cast_nullable_to_non_nullable
as String,bookNo: null == bookNo ? _self.bookNo : bookNo // ignore: cast_nullable_to_non_nullable
as int,pageNo: null == pageNo ? _self.pageNo : pageNo // ignore: cast_nullable_to_non_nullable
as int,fiscalYear: null == fiscalYear ? _self.fiscalYear : fiscalYear // ignore: cast_nullable_to_non_nullable
as String,head: null == head ? _self.head : head // ignore: cast_nullable_to_non_nullable
as RevenueHead,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,payerName: null == payerName ? _self.payerName : payerName // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,feeLines: null == feeLines ? _self.feeLines : feeLines // ignore: cast_nullable_to_non_nullable
as List<FeeLine>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PaymentMode?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as OnlineMethod?,txnRef: freezed == txnRef ? _self.txnRef : txnRef // ignore: cast_nullable_to_non_nullable
as String?,collectedBy: null == collectedBy ? _self.collectedBy : collectedBy // ignore: cast_nullable_to_non_nullable
as String,collectedAt: null == collectedAt ? _self.collectedAt : collectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as PaymentTarget,
  ));
}
/// Create a copy of Receipt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentTargetCopyWith<$Res> get source {
  
  return $PaymentTargetCopyWith<$Res>(_self.source, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}


/// Adds pattern-matching-related methods to [Receipt].
extension ReceiptPatterns on Receipt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Receipt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Receipt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Receipt value)  $default,){
final _that = this;
switch (_that) {
case _Receipt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Receipt value)?  $default,){
final _that = this;
switch (_that) {
case _Receipt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int no,  String receiptNo,  int bookNo,  int pageNo,  String fiscalYear,  RevenueHead head,  Channel channel,  String paymentId,  String payerName,  String purpose,  List<FeeLine> feeLines,  int total,  PaymentMode? mode,  OnlineMethod? method,  String? txnRef,  String collectedBy, @LocalIsoConverter()  DateTime collectedAt,  PaymentTarget source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Receipt() when $default != null:
return $default(_that.id,_that.no,_that.receiptNo,_that.bookNo,_that.pageNo,_that.fiscalYear,_that.head,_that.channel,_that.paymentId,_that.payerName,_that.purpose,_that.feeLines,_that.total,_that.mode,_that.method,_that.txnRef,_that.collectedBy,_that.collectedAt,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int no,  String receiptNo,  int bookNo,  int pageNo,  String fiscalYear,  RevenueHead head,  Channel channel,  String paymentId,  String payerName,  String purpose,  List<FeeLine> feeLines,  int total,  PaymentMode? mode,  OnlineMethod? method,  String? txnRef,  String collectedBy, @LocalIsoConverter()  DateTime collectedAt,  PaymentTarget source)  $default,) {final _that = this;
switch (_that) {
case _Receipt():
return $default(_that.id,_that.no,_that.receiptNo,_that.bookNo,_that.pageNo,_that.fiscalYear,_that.head,_that.channel,_that.paymentId,_that.payerName,_that.purpose,_that.feeLines,_that.total,_that.mode,_that.method,_that.txnRef,_that.collectedBy,_that.collectedAt,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int no,  String receiptNo,  int bookNo,  int pageNo,  String fiscalYear,  RevenueHead head,  Channel channel,  String paymentId,  String payerName,  String purpose,  List<FeeLine> feeLines,  int total,  PaymentMode? mode,  OnlineMethod? method,  String? txnRef,  String collectedBy, @LocalIsoConverter()  DateTime collectedAt,  PaymentTarget source)?  $default,) {final _that = this;
switch (_that) {
case _Receipt() when $default != null:
return $default(_that.id,_that.no,_that.receiptNo,_that.bookNo,_that.pageNo,_that.fiscalYear,_that.head,_that.channel,_that.paymentId,_that.payerName,_that.purpose,_that.feeLines,_that.total,_that.mode,_that.method,_that.txnRef,_that.collectedBy,_that.collectedAt,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Receipt implements Receipt {
  const _Receipt({required this.id, required this.no, required this.receiptNo, required this.bookNo, required this.pageNo, required this.fiscalYear, required this.head, required this.channel, required this.paymentId, required this.payerName, required this.purpose, final  List<FeeLine> feeLines = const <FeeLine>[], required this.total, this.mode, this.method, this.txnRef, required this.collectedBy, @LocalIsoConverter() required this.collectedAt, required this.source}): _feeLines = feeLines;
  factory _Receipt.fromJson(Map<String, dynamic> json) => _$ReceiptFromJson(json);

@override final  String id;
/// Sequential within the fiscal year, and gapless: a missing receipt number
/// is what an auditor looks for first.
@override final  int no;
@override final  String receiptNo;
/// Where this would sit in the paper receipt book.
@override final  int bookNo;
@override final  int pageNo;
@override final  String fiscalYear;
@override final  RevenueHead head;
@override final  Channel channel;
@override final  String paymentId;
@override final  String payerName;
@override final  String purpose;
 final  List<FeeLine> _feeLines;
@override@JsonKey() List<FeeLine> get feeLines {
  if (_feeLines is EqualUnmodifiableListView) return _feeLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feeLines);
}

@override final  int total;
@override final  PaymentMode? mode;
@override final  OnlineMethod? method;
@override final  String? txnRef;
@override final  String collectedBy;
@override@LocalIsoConverter() final  DateTime collectedAt;
@override final  PaymentTarget source;

/// Create a copy of Receipt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptCopyWith<_Receipt> get copyWith => __$ReceiptCopyWithImpl<_Receipt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Receipt&&(identical(other.id, id) || other.id == id)&&(identical(other.no, no) || other.no == no)&&(identical(other.receiptNo, receiptNo) || other.receiptNo == receiptNo)&&(identical(other.bookNo, bookNo) || other.bookNo == bookNo)&&(identical(other.pageNo, pageNo) || other.pageNo == pageNo)&&(identical(other.fiscalYear, fiscalYear) || other.fiscalYear == fiscalYear)&&(identical(other.head, head) || other.head == head)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.payerName, payerName) || other.payerName == payerName)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&const DeepCollectionEquality().equals(other._feeLines, _feeLines)&&(identical(other.total, total) || other.total == total)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.method, method) || other.method == method)&&(identical(other.txnRef, txnRef) || other.txnRef == txnRef)&&(identical(other.collectedBy, collectedBy) || other.collectedBy == collectedBy)&&(identical(other.collectedAt, collectedAt) || other.collectedAt == collectedAt)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,no,receiptNo,bookNo,pageNo,fiscalYear,head,channel,paymentId,payerName,purpose,const DeepCollectionEquality().hash(_feeLines),total,mode,method,txnRef,collectedBy,collectedAt,source]);

@override
String toString() {
  return 'Receipt(id: $id, no: $no, receiptNo: $receiptNo, bookNo: $bookNo, pageNo: $pageNo, fiscalYear: $fiscalYear, head: $head, channel: $channel, paymentId: $paymentId, payerName: $payerName, purpose: $purpose, feeLines: $feeLines, total: $total, mode: $mode, method: $method, txnRef: $txnRef, collectedBy: $collectedBy, collectedAt: $collectedAt, source: $source)';
}


}

/// @nodoc
abstract mixin class _$ReceiptCopyWith<$Res> implements $ReceiptCopyWith<$Res> {
  factory _$ReceiptCopyWith(_Receipt value, $Res Function(_Receipt) _then) = __$ReceiptCopyWithImpl;
@override @useResult
$Res call({
 String id, int no, String receiptNo, int bookNo, int pageNo, String fiscalYear, RevenueHead head, Channel channel, String paymentId, String payerName, String purpose, List<FeeLine> feeLines, int total, PaymentMode? mode, OnlineMethod? method, String? txnRef, String collectedBy,@LocalIsoConverter() DateTime collectedAt, PaymentTarget source
});


@override $PaymentTargetCopyWith<$Res> get source;

}
/// @nodoc
class __$ReceiptCopyWithImpl<$Res>
    implements _$ReceiptCopyWith<$Res> {
  __$ReceiptCopyWithImpl(this._self, this._then);

  final _Receipt _self;
  final $Res Function(_Receipt) _then;

/// Create a copy of Receipt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? no = null,Object? receiptNo = null,Object? bookNo = null,Object? pageNo = null,Object? fiscalYear = null,Object? head = null,Object? channel = null,Object? paymentId = null,Object? payerName = null,Object? purpose = null,Object? feeLines = null,Object? total = null,Object? mode = freezed,Object? method = freezed,Object? txnRef = freezed,Object? collectedBy = null,Object? collectedAt = null,Object? source = null,}) {
  return _then(_Receipt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,no: null == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as int,receiptNo: null == receiptNo ? _self.receiptNo : receiptNo // ignore: cast_nullable_to_non_nullable
as String,bookNo: null == bookNo ? _self.bookNo : bookNo // ignore: cast_nullable_to_non_nullable
as int,pageNo: null == pageNo ? _self.pageNo : pageNo // ignore: cast_nullable_to_non_nullable
as int,fiscalYear: null == fiscalYear ? _self.fiscalYear : fiscalYear // ignore: cast_nullable_to_non_nullable
as String,head: null == head ? _self.head : head // ignore: cast_nullable_to_non_nullable
as RevenueHead,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,payerName: null == payerName ? _self.payerName : payerName // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,feeLines: null == feeLines ? _self._feeLines : feeLines // ignore: cast_nullable_to_non_nullable
as List<FeeLine>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PaymentMode?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as OnlineMethod?,txnRef: freezed == txnRef ? _self.txnRef : txnRef // ignore: cast_nullable_to_non_nullable
as String?,collectedBy: null == collectedBy ? _self.collectedBy : collectedBy // ignore: cast_nullable_to_non_nullable
as String,collectedAt: null == collectedAt ? _self.collectedAt : collectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as PaymentTarget,
  ));
}

/// Create a copy of Receipt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentTargetCopyWith<$Res> get source {
  
  return $PaymentTargetCopyWith<$Res>(_self.source, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}

// dart format on
