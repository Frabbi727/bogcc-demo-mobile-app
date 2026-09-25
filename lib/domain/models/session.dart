/// Who is using the app.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums.dart';
import 'json.dart';

part 'session.freezed.dart';
part 'session.g.dart';

/// A staff session. There is no password: the web demo's login is a role
/// picker, and this mirrors it, because the point is to show the workflow
/// rather than to model authentication.
@freezed
abstract class OfficeSession with _$OfficeSession {
  const factory OfficeSession({
    required AppRole role,
    required String name,
    @LocalIsoConverter() required DateTime since,
  }) = _OfficeSession;

  factory OfficeSession.fromJson(Map<String, dynamic> json) =>
      _$OfficeSessionFromJson(json);
}

/// A citizen is identified by mobile number plus a simulated OTP.
@freezed
abstract class CitizenSession with _$CitizenSession {
  const factory CitizenSession({
    required String mobile,
    @LocalIsoConverter() required DateTime since,
  }) = _CitizenSession;

  factory CitizenSession.fromJson(Map<String, dynamic> json) =>
      _$CitizenSessionFromJson(json);
}
