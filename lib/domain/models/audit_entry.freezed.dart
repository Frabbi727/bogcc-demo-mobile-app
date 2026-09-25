// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FieldChange {

 String get field; String get before; String get after;
/// Create a copy of FieldChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldChangeCopyWith<FieldChange> get copyWith => _$FieldChangeCopyWithImpl<FieldChange>(this as FieldChange, _$identity);

  /// Serializes this FieldChange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FieldChange&&(identical(other.field, field) || other.field == field)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,before,after);

@override
String toString() {
  return 'FieldChange(field: $field, before: $before, after: $after)';
}


}

/// @nodoc
abstract mixin class $FieldChangeCopyWith<$Res>  {
  factory $FieldChangeCopyWith(FieldChange value, $Res Function(FieldChange) _then) = _$FieldChangeCopyWithImpl;
@useResult
$Res call({
 String field, String before, String after
});




}
/// @nodoc
class _$FieldChangeCopyWithImpl<$Res>
    implements $FieldChangeCopyWith<$Res> {
  _$FieldChangeCopyWithImpl(this._self, this._then);

  final FieldChange _self;
  final $Res Function(FieldChange) _then;

/// Create a copy of FieldChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field = null,Object? before = null,Object? after = null,}) {
  return _then(_self.copyWith(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,before: null == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as String,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FieldChange].
extension FieldChangePatterns on FieldChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FieldChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FieldChange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FieldChange value)  $default,){
final _that = this;
switch (_that) {
case _FieldChange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FieldChange value)?  $default,){
final _that = this;
switch (_that) {
case _FieldChange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String field,  String before,  String after)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FieldChange() when $default != null:
return $default(_that.field,_that.before,_that.after);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String field,  String before,  String after)  $default,) {final _that = this;
switch (_that) {
case _FieldChange():
return $default(_that.field,_that.before,_that.after);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String field,  String before,  String after)?  $default,) {final _that = this;
switch (_that) {
case _FieldChange() when $default != null:
return $default(_that.field,_that.before,_that.after);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FieldChange implements FieldChange {
  const _FieldChange({required this.field, required this.before, required this.after});
  factory _FieldChange.fromJson(Map<String, dynamic> json) => _$FieldChangeFromJson(json);

@override final  String field;
@override final  String before;
@override final  String after;

/// Create a copy of FieldChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldChangeCopyWith<_FieldChange> get copyWith => __$FieldChangeCopyWithImpl<_FieldChange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FieldChangeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FieldChange&&(identical(other.field, field) || other.field == field)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,before,after);

@override
String toString() {
  return 'FieldChange(field: $field, before: $before, after: $after)';
}


}

/// @nodoc
abstract mixin class _$FieldChangeCopyWith<$Res> implements $FieldChangeCopyWith<$Res> {
  factory _$FieldChangeCopyWith(_FieldChange value, $Res Function(_FieldChange) _then) = __$FieldChangeCopyWithImpl;
@override @useResult
$Res call({
 String field, String before, String after
});




}
/// @nodoc
class __$FieldChangeCopyWithImpl<$Res>
    implements _$FieldChangeCopyWith<$Res> {
  __$FieldChangeCopyWithImpl(this._self, this._then);

  final _FieldChange _self;
  final $Res Function(_FieldChange) _then;

/// Create a copy of FieldChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? before = null,Object? after = null,}) {
  return _then(_FieldChange(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,before: null == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as String,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AuditEntry {

 String get id;@LocalIsoConverter() DateTime get at; String get userName; AppRole get role; String get action; AuditRecordType get recordType; String get recordKey; String get recordId; String get recordLabel; String? get note; List<FieldChange> get changes;
/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditEntryCopyWith<AuditEntry> get copyWith => _$AuditEntryCopyWithImpl<AuditEntry>(this as AuditEntry, _$identity);

  /// Serializes this AuditEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.at, at) || other.at == at)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.role, role) || other.role == role)&&(identical(other.action, action) || other.action == action)&&(identical(other.recordType, recordType) || other.recordType == recordType)&&(identical(other.recordKey, recordKey) || other.recordKey == recordKey)&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.recordLabel, recordLabel) || other.recordLabel == recordLabel)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other.changes, changes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,at,userName,role,action,recordType,recordKey,recordId,recordLabel,note,const DeepCollectionEquality().hash(changes));

@override
String toString() {
  return 'AuditEntry(id: $id, at: $at, userName: $userName, role: $role, action: $action, recordType: $recordType, recordKey: $recordKey, recordId: $recordId, recordLabel: $recordLabel, note: $note, changes: $changes)';
}


}

/// @nodoc
abstract mixin class $AuditEntryCopyWith<$Res>  {
  factory $AuditEntryCopyWith(AuditEntry value, $Res Function(AuditEntry) _then) = _$AuditEntryCopyWithImpl;
@useResult
$Res call({
 String id,@LocalIsoConverter() DateTime at, String userName, AppRole role, String action, AuditRecordType recordType, String recordKey, String recordId, String recordLabel, String? note, List<FieldChange> changes
});




}
/// @nodoc
class _$AuditEntryCopyWithImpl<$Res>
    implements $AuditEntryCopyWith<$Res> {
  _$AuditEntryCopyWithImpl(this._self, this._then);

  final AuditEntry _self;
  final $Res Function(AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? at = null,Object? userName = null,Object? role = null,Object? action = null,Object? recordType = null,Object? recordKey = null,Object? recordId = null,Object? recordLabel = null,Object? note = freezed,Object? changes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AppRole,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,recordType: null == recordType ? _self.recordType : recordType // ignore: cast_nullable_to_non_nullable
as AuditRecordType,recordKey: null == recordKey ? _self.recordKey : recordKey // ignore: cast_nullable_to_non_nullable
as String,recordId: null == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String,recordLabel: null == recordLabel ? _self.recordLabel : recordLabel // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,changes: null == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as List<FieldChange>,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditEntry].
extension AuditEntryPatterns on AuditEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditEntry value)  $default,){
final _that = this;
switch (_that) {
case _AuditEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @LocalIsoConverter()  DateTime at,  String userName,  AppRole role,  String action,  AuditRecordType recordType,  String recordKey,  String recordId,  String recordLabel,  String? note,  List<FieldChange> changes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
return $default(_that.id,_that.at,_that.userName,_that.role,_that.action,_that.recordType,_that.recordKey,_that.recordId,_that.recordLabel,_that.note,_that.changes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @LocalIsoConverter()  DateTime at,  String userName,  AppRole role,  String action,  AuditRecordType recordType,  String recordKey,  String recordId,  String recordLabel,  String? note,  List<FieldChange> changes)  $default,) {final _that = this;
switch (_that) {
case _AuditEntry():
return $default(_that.id,_that.at,_that.userName,_that.role,_that.action,_that.recordType,_that.recordKey,_that.recordId,_that.recordLabel,_that.note,_that.changes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @LocalIsoConverter()  DateTime at,  String userName,  AppRole role,  String action,  AuditRecordType recordType,  String recordKey,  String recordId,  String recordLabel,  String? note,  List<FieldChange> changes)?  $default,) {final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
return $default(_that.id,_that.at,_that.userName,_that.role,_that.action,_that.recordType,_that.recordKey,_that.recordId,_that.recordLabel,_that.note,_that.changes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditEntry implements AuditEntry {
  const _AuditEntry({required this.id, @LocalIsoConverter() required this.at, required this.userName, required this.role, required this.action, required this.recordType, required this.recordKey, required this.recordId, required this.recordLabel, this.note, final  List<FieldChange> changes = const <FieldChange>[]}): _changes = changes;
  factory _AuditEntry.fromJson(Map<String, dynamic> json) => _$AuditEntryFromJson(json);

@override final  String id;
@override@LocalIsoConverter() final  DateTime at;
@override final  String userName;
@override final  AppRole role;
@override final  String action;
@override final  AuditRecordType recordType;
@override final  String recordKey;
@override final  String recordId;
@override final  String recordLabel;
@override final  String? note;
 final  List<FieldChange> _changes;
@override@JsonKey() List<FieldChange> get changes {
  if (_changes is EqualUnmodifiableListView) return _changes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_changes);
}


/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditEntryCopyWith<_AuditEntry> get copyWith => __$AuditEntryCopyWithImpl<_AuditEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.at, at) || other.at == at)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.role, role) || other.role == role)&&(identical(other.action, action) || other.action == action)&&(identical(other.recordType, recordType) || other.recordType == recordType)&&(identical(other.recordKey, recordKey) || other.recordKey == recordKey)&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.recordLabel, recordLabel) || other.recordLabel == recordLabel)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other._changes, _changes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,at,userName,role,action,recordType,recordKey,recordId,recordLabel,note,const DeepCollectionEquality().hash(_changes));

@override
String toString() {
  return 'AuditEntry(id: $id, at: $at, userName: $userName, role: $role, action: $action, recordType: $recordType, recordKey: $recordKey, recordId: $recordId, recordLabel: $recordLabel, note: $note, changes: $changes)';
}


}

/// @nodoc
abstract mixin class _$AuditEntryCopyWith<$Res> implements $AuditEntryCopyWith<$Res> {
  factory _$AuditEntryCopyWith(_AuditEntry value, $Res Function(_AuditEntry) _then) = __$AuditEntryCopyWithImpl;
@override @useResult
$Res call({
 String id,@LocalIsoConverter() DateTime at, String userName, AppRole role, String action, AuditRecordType recordType, String recordKey, String recordId, String recordLabel, String? note, List<FieldChange> changes
});




}
/// @nodoc
class __$AuditEntryCopyWithImpl<$Res>
    implements _$AuditEntryCopyWith<$Res> {
  __$AuditEntryCopyWithImpl(this._self, this._then);

  final _AuditEntry _self;
  final $Res Function(_AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? at = null,Object? userName = null,Object? role = null,Object? action = null,Object? recordType = null,Object? recordKey = null,Object? recordId = null,Object? recordLabel = null,Object? note = freezed,Object? changes = null,}) {
  return _then(_AuditEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AppRole,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,recordType: null == recordType ? _self.recordType : recordType // ignore: cast_nullable_to_non_nullable
as AuditRecordType,recordKey: null == recordKey ? _self.recordKey : recordKey // ignore: cast_nullable_to_non_nullable
as String,recordId: null == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String,recordLabel: null == recordLabel ? _self.recordLabel : recordLabel // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,changes: null == changes ? _self._changes : changes // ignore: cast_nullable_to_non_nullable
as List<FieldChange>,
  ));
}


}

// dart format on
