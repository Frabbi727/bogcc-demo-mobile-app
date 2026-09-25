/// Simulated SMS and public notices.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums.dart';
import 'json.dart';

part 'messaging.freezed.dart';
part 'messaging.g.dart';

/// A simulated SMS. Nothing is ever actually sent — there is no INTERNET
/// permission and no gateway. The inbox screen is the whole delivery mechanism.
@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String mobile,
    required String text,
    @LocalIsoConverter() required DateTime at,
    String? trackingNo,
    @Default(false) bool read,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

@freezed
abstract class Notice with _$Notice {
  const factory Notice({
    required String id,
    required String title,
    required String body,
    @LocalIsoConverter() required DateTime at,
    required String byName,
    required AppRole byRole,
  }) = _Notice;

  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
}
