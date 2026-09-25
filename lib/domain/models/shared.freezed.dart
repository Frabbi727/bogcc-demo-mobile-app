// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistoryStep {

 String get status;@LocalIsoConverter() DateTime get at; String get byName; AppRole get byRole; String? get note;/// Staff decide per note whether the citizen may read it. Defaults to
/// private: an internal remark leaking to an applicant is the worse failure.
 bool get publicNote;
/// Create a copy of HistoryStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryStepCopyWith<HistoryStep> get copyWith => _$HistoryStepCopyWithImpl<HistoryStep>(this as HistoryStep, _$identity);

  /// Serializes this HistoryStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryStep&&(identical(other.status, status) || other.status == status)&&(identical(other.at, at) || other.at == at)&&(identical(other.byName, byName) || other.byName == byName)&&(identical(other.byRole, byRole) || other.byRole == byRole)&&(identical(other.note, note) || other.note == note)&&(identical(other.publicNote, publicNote) || other.publicNote == publicNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,at,byName,byRole,note,publicNote);

@override
String toString() {
  return 'HistoryStep(status: $status, at: $at, byName: $byName, byRole: $byRole, note: $note, publicNote: $publicNote)';
}


}

/// @nodoc
abstract mixin class $HistoryStepCopyWith<$Res>  {
  factory $HistoryStepCopyWith(HistoryStep value, $Res Function(HistoryStep) _then) = _$HistoryStepCopyWithImpl;
@useResult
$Res call({
 String status,@LocalIsoConverter() DateTime at, String byName, AppRole byRole, String? note, bool publicNote
});




}
/// @nodoc
class _$HistoryStepCopyWithImpl<$Res>
    implements $HistoryStepCopyWith<$Res> {
  _$HistoryStepCopyWithImpl(this._self, this._then);

  final HistoryStep _self;
  final $Res Function(HistoryStep) _then;

/// Create a copy of HistoryStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? at = null,Object? byName = null,Object? byRole = null,Object? note = freezed,Object? publicNote = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,byName: null == byName ? _self.byName : byName // ignore: cast_nullable_to_non_nullable
as String,byRole: null == byRole ? _self.byRole : byRole // ignore: cast_nullable_to_non_nullable
as AppRole,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,publicNote: null == publicNote ? _self.publicNote : publicNote // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryStep].
extension HistoryStepPatterns on HistoryStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryStep value)  $default,){
final _that = this;
switch (_that) {
case _HistoryStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryStep value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status, @LocalIsoConverter()  DateTime at,  String byName,  AppRole byRole,  String? note,  bool publicNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryStep() when $default != null:
return $default(_that.status,_that.at,_that.byName,_that.byRole,_that.note,_that.publicNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status, @LocalIsoConverter()  DateTime at,  String byName,  AppRole byRole,  String? note,  bool publicNote)  $default,) {final _that = this;
switch (_that) {
case _HistoryStep():
return $default(_that.status,_that.at,_that.byName,_that.byRole,_that.note,_that.publicNote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status, @LocalIsoConverter()  DateTime at,  String byName,  AppRole byRole,  String? note,  bool publicNote)?  $default,) {final _that = this;
switch (_that) {
case _HistoryStep() when $default != null:
return $default(_that.status,_that.at,_that.byName,_that.byRole,_that.note,_that.publicNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryStep implements HistoryStep {
  const _HistoryStep({required this.status, @LocalIsoConverter() required this.at, required this.byName, required this.byRole, this.note, this.publicNote = false});
  factory _HistoryStep.fromJson(Map<String, dynamic> json) => _$HistoryStepFromJson(json);

@override final  String status;
@override@LocalIsoConverter() final  DateTime at;
@override final  String byName;
@override final  AppRole byRole;
@override final  String? note;
/// Staff decide per note whether the citizen may read it. Defaults to
/// private: an internal remark leaking to an applicant is the worse failure.
@override@JsonKey() final  bool publicNote;

/// Create a copy of HistoryStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryStepCopyWith<_HistoryStep> get copyWith => __$HistoryStepCopyWithImpl<_HistoryStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryStep&&(identical(other.status, status) || other.status == status)&&(identical(other.at, at) || other.at == at)&&(identical(other.byName, byName) || other.byName == byName)&&(identical(other.byRole, byRole) || other.byRole == byRole)&&(identical(other.note, note) || other.note == note)&&(identical(other.publicNote, publicNote) || other.publicNote == publicNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,at,byName,byRole,note,publicNote);

@override
String toString() {
  return 'HistoryStep(status: $status, at: $at, byName: $byName, byRole: $byRole, note: $note, publicNote: $publicNote)';
}


}

/// @nodoc
abstract mixin class _$HistoryStepCopyWith<$Res> implements $HistoryStepCopyWith<$Res> {
  factory _$HistoryStepCopyWith(_HistoryStep value, $Res Function(_HistoryStep) _then) = __$HistoryStepCopyWithImpl;
@override @useResult
$Res call({
 String status,@LocalIsoConverter() DateTime at, String byName, AppRole byRole, String? note, bool publicNote
});




}
/// @nodoc
class __$HistoryStepCopyWithImpl<$Res>
    implements _$HistoryStepCopyWith<$Res> {
  __$HistoryStepCopyWithImpl(this._self, this._then);

  final _HistoryStep _self;
  final $Res Function(_HistoryStep) _then;

/// Create a copy of HistoryStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? at = null,Object? byName = null,Object? byRole = null,Object? note = freezed,Object? publicNote = null,}) {
  return _then(_HistoryStep(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,byName: null == byName ? _self.byName : byName // ignore: cast_nullable_to_non_nullable
as String,byRole: null == byRole ? _self.byRole : byRole // ignore: cast_nullable_to_non_nullable
as AppRole,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,publicNote: null == publicNote ? _self.publicNote : publicNote // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Cancellation {

@LocalIsoConverter() DateTime get at; String get by; String get reason;
/// Create a copy of Cancellation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CancellationCopyWith<Cancellation> get copyWith => _$CancellationCopyWithImpl<Cancellation>(this as Cancellation, _$identity);

  /// Serializes this Cancellation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cancellation&&(identical(other.at, at) || other.at == at)&&(identical(other.by, by) || other.by == by)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,at,by,reason);

@override
String toString() {
  return 'Cancellation(at: $at, by: $by, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $CancellationCopyWith<$Res>  {
  factory $CancellationCopyWith(Cancellation value, $Res Function(Cancellation) _then) = _$CancellationCopyWithImpl;
@useResult
$Res call({
@LocalIsoConverter() DateTime at, String by, String reason
});




}
/// @nodoc
class _$CancellationCopyWithImpl<$Res>
    implements $CancellationCopyWith<$Res> {
  _$CancellationCopyWithImpl(this._self, this._then);

  final Cancellation _self;
  final $Res Function(Cancellation) _then;

/// Create a copy of Cancellation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? at = null,Object? by = null,Object? reason = null,}) {
  return _then(_self.copyWith(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,by: null == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Cancellation].
extension CancellationPatterns on Cancellation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cancellation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cancellation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cancellation value)  $default,){
final _that = this;
switch (_that) {
case _Cancellation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cancellation value)?  $default,){
final _that = this;
switch (_that) {
case _Cancellation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@LocalIsoConverter()  DateTime at,  String by,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cancellation() when $default != null:
return $default(_that.at,_that.by,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@LocalIsoConverter()  DateTime at,  String by,  String reason)  $default,) {final _that = this;
switch (_that) {
case _Cancellation():
return $default(_that.at,_that.by,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@LocalIsoConverter()  DateTime at,  String by,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _Cancellation() when $default != null:
return $default(_that.at,_that.by,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Cancellation implements Cancellation {
  const _Cancellation({@LocalIsoConverter() required this.at, required this.by, required this.reason});
  factory _Cancellation.fromJson(Map<String, dynamic> json) => _$CancellationFromJson(json);

@override@LocalIsoConverter() final  DateTime at;
@override final  String by;
@override final  String reason;

/// Create a copy of Cancellation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CancellationCopyWith<_Cancellation> get copyWith => __$CancellationCopyWithImpl<_Cancellation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CancellationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cancellation&&(identical(other.at, at) || other.at == at)&&(identical(other.by, by) || other.by == by)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,at,by,reason);

@override
String toString() {
  return 'Cancellation(at: $at, by: $by, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$CancellationCopyWith<$Res> implements $CancellationCopyWith<$Res> {
  factory _$CancellationCopyWith(_Cancellation value, $Res Function(_Cancellation) _then) = __$CancellationCopyWithImpl;
@override @useResult
$Res call({
@LocalIsoConverter() DateTime at, String by, String reason
});




}
/// @nodoc
class __$CancellationCopyWithImpl<$Res>
    implements _$CancellationCopyWith<$Res> {
  __$CancellationCopyWithImpl(this._self, this._then);

  final _Cancellation _self;
  final $Res Function(_Cancellation) _then;

/// Create a copy of Cancellation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = null,Object? by = null,Object? reason = null,}) {
  return _then(_Cancellation(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,by: null == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Feedback {

 int get rating; String? get comment;@LocalIsoConverter() DateTime get at;
/// Create a copy of Feedback
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedbackCopyWith<Feedback> get copyWith => _$FeedbackCopyWithImpl<Feedback>(this as Feedback, _$identity);

  /// Serializes this Feedback to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Feedback&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rating,comment,at);

@override
String toString() {
  return 'Feedback(rating: $rating, comment: $comment, at: $at)';
}


}

/// @nodoc
abstract mixin class $FeedbackCopyWith<$Res>  {
  factory $FeedbackCopyWith(Feedback value, $Res Function(Feedback) _then) = _$FeedbackCopyWithImpl;
@useResult
$Res call({
 int rating, String? comment,@LocalIsoConverter() DateTime at
});




}
/// @nodoc
class _$FeedbackCopyWithImpl<$Res>
    implements $FeedbackCopyWith<$Res> {
  _$FeedbackCopyWithImpl(this._self, this._then);

  final Feedback _self;
  final $Res Function(Feedback) _then;

/// Create a copy of Feedback
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rating = null,Object? comment = freezed,Object? at = null,}) {
  return _then(_self.copyWith(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Feedback].
extension FeedbackPatterns on Feedback {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Feedback value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Feedback() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Feedback value)  $default,){
final _that = this;
switch (_that) {
case _Feedback():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Feedback value)?  $default,){
final _that = this;
switch (_that) {
case _Feedback() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rating,  String? comment, @LocalIsoConverter()  DateTime at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Feedback() when $default != null:
return $default(_that.rating,_that.comment,_that.at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rating,  String? comment, @LocalIsoConverter()  DateTime at)  $default,) {final _that = this;
switch (_that) {
case _Feedback():
return $default(_that.rating,_that.comment,_that.at);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rating,  String? comment, @LocalIsoConverter()  DateTime at)?  $default,) {final _that = this;
switch (_that) {
case _Feedback() when $default != null:
return $default(_that.rating,_that.comment,_that.at);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Feedback implements Feedback {
  const _Feedback({required this.rating, this.comment, @LocalIsoConverter() required this.at});
  factory _Feedback.fromJson(Map<String, dynamic> json) => _$FeedbackFromJson(json);

@override final  int rating;
@override final  String? comment;
@override@LocalIsoConverter() final  DateTime at;

/// Create a copy of Feedback
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedbackCopyWith<_Feedback> get copyWith => __$FeedbackCopyWithImpl<_Feedback>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedbackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Feedback&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rating,comment,at);

@override
String toString() {
  return 'Feedback(rating: $rating, comment: $comment, at: $at)';
}


}

/// @nodoc
abstract mixin class _$FeedbackCopyWith<$Res> implements $FeedbackCopyWith<$Res> {
  factory _$FeedbackCopyWith(_Feedback value, $Res Function(_Feedback) _then) = __$FeedbackCopyWithImpl;
@override @useResult
$Res call({
 int rating, String? comment,@LocalIsoConverter() DateTime at
});




}
/// @nodoc
class __$FeedbackCopyWithImpl<$Res>
    implements _$FeedbackCopyWith<$Res> {
  __$FeedbackCopyWithImpl(this._self, this._then);

  final _Feedback _self;
  final $Res Function(_Feedback) _then;

/// Create a copy of Feedback
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rating = null,Object? comment = freezed,Object? at = null,}) {
  return _then(_Feedback(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Heir {

 String get name; String get relation; int get age;
/// Create a copy of Heir
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeirCopyWith<Heir> get copyWith => _$HeirCopyWithImpl<Heir>(this as Heir, _$identity);

  /// Serializes this Heir to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Heir&&(identical(other.name, name) || other.name == name)&&(identical(other.relation, relation) || other.relation == relation)&&(identical(other.age, age) || other.age == age));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,relation,age);

@override
String toString() {
  return 'Heir(name: $name, relation: $relation, age: $age)';
}


}

/// @nodoc
abstract mixin class $HeirCopyWith<$Res>  {
  factory $HeirCopyWith(Heir value, $Res Function(Heir) _then) = _$HeirCopyWithImpl;
@useResult
$Res call({
 String name, String relation, int age
});




}
/// @nodoc
class _$HeirCopyWithImpl<$Res>
    implements $HeirCopyWith<$Res> {
  _$HeirCopyWithImpl(this._self, this._then);

  final Heir _self;
  final $Res Function(Heir) _then;

/// Create a copy of Heir
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? relation = null,Object? age = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,relation: null == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Heir].
extension HeirPatterns on Heir {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Heir value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Heir() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Heir value)  $default,){
final _that = this;
switch (_that) {
case _Heir():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Heir value)?  $default,){
final _that = this;
switch (_that) {
case _Heir() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String relation,  int age)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Heir() when $default != null:
return $default(_that.name,_that.relation,_that.age);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String relation,  int age)  $default,) {final _that = this;
switch (_that) {
case _Heir():
return $default(_that.name,_that.relation,_that.age);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String relation,  int age)?  $default,) {final _that = this;
switch (_that) {
case _Heir() when $default != null:
return $default(_that.name,_that.relation,_that.age);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Heir implements Heir {
  const _Heir({required this.name, required this.relation, required this.age});
  factory _Heir.fromJson(Map<String, dynamic> json) => _$HeirFromJson(json);

@override final  String name;
@override final  String relation;
@override final  int age;

/// Create a copy of Heir
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeirCopyWith<_Heir> get copyWith => __$HeirCopyWithImpl<_Heir>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeirToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Heir&&(identical(other.name, name) || other.name == name)&&(identical(other.relation, relation) || other.relation == relation)&&(identical(other.age, age) || other.age == age));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,relation,age);

@override
String toString() {
  return 'Heir(name: $name, relation: $relation, age: $age)';
}


}

/// @nodoc
abstract mixin class _$HeirCopyWith<$Res> implements $HeirCopyWith<$Res> {
  factory _$HeirCopyWith(_Heir value, $Res Function(_Heir) _then) = __$HeirCopyWithImpl;
@override @useResult
$Res call({
 String name, String relation, int age
});




}
/// @nodoc
class __$HeirCopyWithImpl<$Res>
    implements _$HeirCopyWith<$Res> {
  __$HeirCopyWithImpl(this._self, this._then);

  final _Heir _self;
  final $Res Function(_Heir) _then;

/// Create a copy of Heir
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? relation = null,Object? age = null,}) {
  return _then(_Heir(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,relation: null == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PhotoRef {

/// File name under the photos directory, or the asset path when [isAsset].
 String get id;@LocalIsoConverter() DateTime get at; PhotoKind get kind; String? get caption;/// Seeded photos are bundled assets and must never be deleted on cleanup.
 bool get isAsset;
/// Create a copy of PhotoRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotoRefCopyWith<PhotoRef> get copyWith => _$PhotoRefCopyWithImpl<PhotoRef>(this as PhotoRef, _$identity);

  /// Serializes this PhotoRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotoRef&&(identical(other.id, id) || other.id == id)&&(identical(other.at, at) || other.at == at)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.isAsset, isAsset) || other.isAsset == isAsset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,at,kind,caption,isAsset);

@override
String toString() {
  return 'PhotoRef(id: $id, at: $at, kind: $kind, caption: $caption, isAsset: $isAsset)';
}


}

/// @nodoc
abstract mixin class $PhotoRefCopyWith<$Res>  {
  factory $PhotoRefCopyWith(PhotoRef value, $Res Function(PhotoRef) _then) = _$PhotoRefCopyWithImpl;
@useResult
$Res call({
 String id,@LocalIsoConverter() DateTime at, PhotoKind kind, String? caption, bool isAsset
});




}
/// @nodoc
class _$PhotoRefCopyWithImpl<$Res>
    implements $PhotoRefCopyWith<$Res> {
  _$PhotoRefCopyWithImpl(this._self, this._then);

  final PhotoRef _self;
  final $Res Function(PhotoRef) _then;

/// Create a copy of PhotoRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? at = null,Object? kind = null,Object? caption = freezed,Object? isAsset = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PhotoKind,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,isAsset: null == isAsset ? _self.isAsset : isAsset // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PhotoRef].
extension PhotoRefPatterns on PhotoRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhotoRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhotoRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhotoRef value)  $default,){
final _that = this;
switch (_that) {
case _PhotoRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhotoRef value)?  $default,){
final _that = this;
switch (_that) {
case _PhotoRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @LocalIsoConverter()  DateTime at,  PhotoKind kind,  String? caption,  bool isAsset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhotoRef() when $default != null:
return $default(_that.id,_that.at,_that.kind,_that.caption,_that.isAsset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @LocalIsoConverter()  DateTime at,  PhotoKind kind,  String? caption,  bool isAsset)  $default,) {final _that = this;
switch (_that) {
case _PhotoRef():
return $default(_that.id,_that.at,_that.kind,_that.caption,_that.isAsset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @LocalIsoConverter()  DateTime at,  PhotoKind kind,  String? caption,  bool isAsset)?  $default,) {final _that = this;
switch (_that) {
case _PhotoRef() when $default != null:
return $default(_that.id,_that.at,_that.kind,_that.caption,_that.isAsset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhotoRef implements PhotoRef {
  const _PhotoRef({required this.id, @LocalIsoConverter() required this.at, required this.kind, this.caption, this.isAsset = false});
  factory _PhotoRef.fromJson(Map<String, dynamic> json) => _$PhotoRefFromJson(json);

/// File name under the photos directory, or the asset path when [isAsset].
@override final  String id;
@override@LocalIsoConverter() final  DateTime at;
@override final  PhotoKind kind;
@override final  String? caption;
/// Seeded photos are bundled assets and must never be deleted on cleanup.
@override@JsonKey() final  bool isAsset;

/// Create a copy of PhotoRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoRefCopyWith<_PhotoRef> get copyWith => __$PhotoRefCopyWithImpl<_PhotoRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhotoRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoRef&&(identical(other.id, id) || other.id == id)&&(identical(other.at, at) || other.at == at)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.isAsset, isAsset) || other.isAsset == isAsset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,at,kind,caption,isAsset);

@override
String toString() {
  return 'PhotoRef(id: $id, at: $at, kind: $kind, caption: $caption, isAsset: $isAsset)';
}


}

/// @nodoc
abstract mixin class _$PhotoRefCopyWith<$Res> implements $PhotoRefCopyWith<$Res> {
  factory _$PhotoRefCopyWith(_PhotoRef value, $Res Function(_PhotoRef) _then) = __$PhotoRefCopyWithImpl;
@override @useResult
$Res call({
 String id,@LocalIsoConverter() DateTime at, PhotoKind kind, String? caption, bool isAsset
});




}
/// @nodoc
class __$PhotoRefCopyWithImpl<$Res>
    implements _$PhotoRefCopyWith<$Res> {
  __$PhotoRefCopyWithImpl(this._self, this._then);

  final _PhotoRef _self;
  final $Res Function(_PhotoRef) _then;

/// Create a copy of PhotoRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? at = null,Object? kind = null,Object? caption = freezed,Object? isAsset = null,}) {
  return _then(_PhotoRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PhotoKind,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,isAsset: null == isAsset ? _self.isAsset : isAsset // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$FeeLine {

 String get label; int get amount;
/// Create a copy of FeeLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeeLineCopyWith<FeeLine> get copyWith => _$FeeLineCopyWithImpl<FeeLine>(this as FeeLine, _$identity);

  /// Serializes this FeeLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeeLine&&(identical(other.label, label) || other.label == label)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,amount);

@override
String toString() {
  return 'FeeLine(label: $label, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $FeeLineCopyWith<$Res>  {
  factory $FeeLineCopyWith(FeeLine value, $Res Function(FeeLine) _then) = _$FeeLineCopyWithImpl;
@useResult
$Res call({
 String label, int amount
});




}
/// @nodoc
class _$FeeLineCopyWithImpl<$Res>
    implements $FeeLineCopyWith<$Res> {
  _$FeeLineCopyWithImpl(this._self, this._then);

  final FeeLine _self;
  final $Res Function(FeeLine) _then;

/// Create a copy of FeeLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? amount = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FeeLine].
extension FeeLinePatterns on FeeLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeeLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeeLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeeLine value)  $default,){
final _that = this;
switch (_that) {
case _FeeLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeeLine value)?  $default,){
final _that = this;
switch (_that) {
case _FeeLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  int amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeeLine() when $default != null:
return $default(_that.label,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  int amount)  $default,) {final _that = this;
switch (_that) {
case _FeeLine():
return $default(_that.label,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  int amount)?  $default,) {final _that = this;
switch (_that) {
case _FeeLine() when $default != null:
return $default(_that.label,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeeLine implements FeeLine {
  const _FeeLine({required this.label, required this.amount});
  factory _FeeLine.fromJson(Map<String, dynamic> json) => _$FeeLineFromJson(json);

@override final  String label;
@override final  int amount;

/// Create a copy of FeeLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeeLineCopyWith<_FeeLine> get copyWith => __$FeeLineCopyWithImpl<_FeeLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeeLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeeLine&&(identical(other.label, label) || other.label == label)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,amount);

@override
String toString() {
  return 'FeeLine(label: $label, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$FeeLineCopyWith<$Res> implements $FeeLineCopyWith<$Res> {
  factory _$FeeLineCopyWith(_FeeLine value, $Res Function(_FeeLine) _then) = __$FeeLineCopyWithImpl;
@override @useResult
$Res call({
 String label, int amount
});




}
/// @nodoc
class __$FeeLineCopyWithImpl<$Res>
    implements _$FeeLineCopyWith<$Res> {
  __$FeeLineCopyWithImpl(this._self, this._then);

  final _FeeLine _self;
  final $Res Function(_FeeLine) _then;

/// Create a copy of FeeLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? amount = null,}) {
  return _then(_FeeLine(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
