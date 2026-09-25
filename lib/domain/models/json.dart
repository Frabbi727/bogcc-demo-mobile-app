/// JSON converters shared by every model.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/time/local_iso.dart';

/// Stores a `DateTime` as the local ISO string the web demo uses — no `Z`, no
/// offset — so a record filed at 11pm stays on the same calendar day, and so a
/// Hive box written by this app could be read by the web one unchanged.
class LocalIsoConverter implements JsonConverter<DateTime, String> {
  const LocalIsoConverter();

  @override
  DateTime fromJson(String json) => parseIso(json);

  @override
  String toJson(DateTime object) => iso(object);
}

/// As [LocalIsoConverter], for optional timestamps.
class LocalIsoNullableConverter implements JsonConverter<DateTime?, String?> {
  const LocalIsoNullableConverter();

  @override
  DateTime? fromJson(String? json) => tryParseIso(json);

  @override
  String? toJson(DateTime? object) => object == null ? null : iso(object);
}

/// Hive hands back `Map<dynamic, dynamic>` for nested objects, and
/// `List<dynamic>` for nested lists, whatever was written. Every model read
/// goes through this first, or the failure surfaces later as an opaque
/// `_TypeError` inside an unrelated screen.
Map<String, dynamic> asJsonMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value.map(MapEntry.new)..updateAll((_, v) => _deep(v));
  }
  if (value is Map) {
    return <String, dynamic>{
      for (final entry in value.entries) entry.key.toString(): _deep(entry.value),
    };
  }
  throw ArgumentError.value(value, 'value', 'Expected a JSON object');
}

Object? _deep(Object? value) {
  if (value is Map) return asJsonMap(value);
  if (value is List) return value.map(_deep).toList();
  return value;
}
