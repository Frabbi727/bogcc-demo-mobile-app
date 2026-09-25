// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OfficeSession {

 AppRole get role; String get name;@LocalIsoConverter() DateTime get since;
/// Create a copy of OfficeSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfficeSessionCopyWith<OfficeSession> get copyWith => _$OfficeSessionCopyWithImpl<OfficeSession>(this as OfficeSession, _$identity);

  /// Serializes this OfficeSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfficeSession&&(identical(other.role, role) || other.role == role)&&(identical(other.name, name) || other.name == name)&&(identical(other.since, since) || other.since == since));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,name,since);

@override
String toString() {
  return 'OfficeSession(role: $role, name: $name, since: $since)';
}


}

/// @nodoc
abstract mixin class $OfficeSessionCopyWith<$Res>  {
  factory $OfficeSessionCopyWith(OfficeSession value, $Res Function(OfficeSession) _then) = _$OfficeSessionCopyWithImpl;
@useResult
$Res call({
 AppRole role, String name,@LocalIsoConverter() DateTime since
});




}
/// @nodoc
class _$OfficeSessionCopyWithImpl<$Res>
    implements $OfficeSessionCopyWith<$Res> {
  _$OfficeSessionCopyWithImpl(this._self, this._then);

  final OfficeSession _self;
  final $Res Function(OfficeSession) _then;

/// Create a copy of OfficeSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? name = null,Object? since = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AppRole,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,since: null == since ? _self.since : since // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [OfficeSession].
extension OfficeSessionPatterns on OfficeSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfficeSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfficeSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfficeSession value)  $default,){
final _that = this;
switch (_that) {
case _OfficeSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfficeSession value)?  $default,){
final _that = this;
switch (_that) {
case _OfficeSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppRole role,  String name, @LocalIsoConverter()  DateTime since)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfficeSession() when $default != null:
return $default(_that.role,_that.name,_that.since);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppRole role,  String name, @LocalIsoConverter()  DateTime since)  $default,) {final _that = this;
switch (_that) {
case _OfficeSession():
return $default(_that.role,_that.name,_that.since);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppRole role,  String name, @LocalIsoConverter()  DateTime since)?  $default,) {final _that = this;
switch (_that) {
case _OfficeSession() when $default != null:
return $default(_that.role,_that.name,_that.since);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfficeSession implements OfficeSession {
  const _OfficeSession({required this.role, required this.name, @LocalIsoConverter() required this.since});
  factory _OfficeSession.fromJson(Map<String, dynamic> json) => _$OfficeSessionFromJson(json);

@override final  AppRole role;
@override final  String name;
@override@LocalIsoConverter() final  DateTime since;

/// Create a copy of OfficeSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfficeSessionCopyWith<_OfficeSession> get copyWith => __$OfficeSessionCopyWithImpl<_OfficeSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfficeSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfficeSession&&(identical(other.role, role) || other.role == role)&&(identical(other.name, name) || other.name == name)&&(identical(other.since, since) || other.since == since));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,name,since);

@override
String toString() {
  return 'OfficeSession(role: $role, name: $name, since: $since)';
}


}

/// @nodoc
abstract mixin class _$OfficeSessionCopyWith<$Res> implements $OfficeSessionCopyWith<$Res> {
  factory _$OfficeSessionCopyWith(_OfficeSession value, $Res Function(_OfficeSession) _then) = __$OfficeSessionCopyWithImpl;
@override @useResult
$Res call({
 AppRole role, String name,@LocalIsoConverter() DateTime since
});




}
/// @nodoc
class __$OfficeSessionCopyWithImpl<$Res>
    implements _$OfficeSessionCopyWith<$Res> {
  __$OfficeSessionCopyWithImpl(this._self, this._then);

  final _OfficeSession _self;
  final $Res Function(_OfficeSession) _then;

/// Create a copy of OfficeSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? name = null,Object? since = null,}) {
  return _then(_OfficeSession(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AppRole,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,since: null == since ? _self.since : since // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CitizenSession {

 String get mobile;@LocalIsoConverter() DateTime get since;
/// Create a copy of CitizenSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CitizenSessionCopyWith<CitizenSession> get copyWith => _$CitizenSessionCopyWithImpl<CitizenSession>(this as CitizenSession, _$identity);

  /// Serializes this CitizenSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CitizenSession&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.since, since) || other.since == since));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mobile,since);

@override
String toString() {
  return 'CitizenSession(mobile: $mobile, since: $since)';
}


}

/// @nodoc
abstract mixin class $CitizenSessionCopyWith<$Res>  {
  factory $CitizenSessionCopyWith(CitizenSession value, $Res Function(CitizenSession) _then) = _$CitizenSessionCopyWithImpl;
@useResult
$Res call({
 String mobile,@LocalIsoConverter() DateTime since
});




}
/// @nodoc
class _$CitizenSessionCopyWithImpl<$Res>
    implements $CitizenSessionCopyWith<$Res> {
  _$CitizenSessionCopyWithImpl(this._self, this._then);

  final CitizenSession _self;
  final $Res Function(CitizenSession) _then;

/// Create a copy of CitizenSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mobile = null,Object? since = null,}) {
  return _then(_self.copyWith(
mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,since: null == since ? _self.since : since // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CitizenSession].
extension CitizenSessionPatterns on CitizenSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CitizenSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CitizenSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CitizenSession value)  $default,){
final _that = this;
switch (_that) {
case _CitizenSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CitizenSession value)?  $default,){
final _that = this;
switch (_that) {
case _CitizenSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mobile, @LocalIsoConverter()  DateTime since)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CitizenSession() when $default != null:
return $default(_that.mobile,_that.since);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mobile, @LocalIsoConverter()  DateTime since)  $default,) {final _that = this;
switch (_that) {
case _CitizenSession():
return $default(_that.mobile,_that.since);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mobile, @LocalIsoConverter()  DateTime since)?  $default,) {final _that = this;
switch (_that) {
case _CitizenSession() when $default != null:
return $default(_that.mobile,_that.since);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CitizenSession implements CitizenSession {
  const _CitizenSession({required this.mobile, @LocalIsoConverter() required this.since});
  factory _CitizenSession.fromJson(Map<String, dynamic> json) => _$CitizenSessionFromJson(json);

@override final  String mobile;
@override@LocalIsoConverter() final  DateTime since;

/// Create a copy of CitizenSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CitizenSessionCopyWith<_CitizenSession> get copyWith => __$CitizenSessionCopyWithImpl<_CitizenSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CitizenSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CitizenSession&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.since, since) || other.since == since));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mobile,since);

@override
String toString() {
  return 'CitizenSession(mobile: $mobile, since: $since)';
}


}

/// @nodoc
abstract mixin class _$CitizenSessionCopyWith<$Res> implements $CitizenSessionCopyWith<$Res> {
  factory _$CitizenSessionCopyWith(_CitizenSession value, $Res Function(_CitizenSession) _then) = __$CitizenSessionCopyWithImpl;
@override @useResult
$Res call({
 String mobile,@LocalIsoConverter() DateTime since
});




}
/// @nodoc
class __$CitizenSessionCopyWithImpl<$Res>
    implements _$CitizenSessionCopyWith<$Res> {
  __$CitizenSessionCopyWithImpl(this._self, this._then);

  final _CitizenSession _self;
  final $Res Function(_CitizenSession) _then;

/// Create a copy of CitizenSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mobile = null,Object? since = null,}) {
  return _then(_CitizenSession(
mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,since: null == since ? _self.since : since // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
