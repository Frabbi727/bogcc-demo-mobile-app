import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../domain/models/json.dart';

/// Reads and writes freezed models as JSON maps in one Hive box.
///
/// The only place that deals with Hive's untyped `Map<dynamic, dynamic>`: every
/// read goes through `asJsonMap`, so a nested model cannot surface later as an
/// opaque `_TypeError` in an unrelated screen.
class JsonBoxStore<T> {
  JsonBoxStore({
    required this.box,
    required this.fromJson,
    required this.toJson,
    required this.idOf,
  });

  final Box<dynamic> box;
  final T Function(Map<String, dynamic> json) fromJson;
  final Map<String, dynamic> Function(T value) toJson;
  final String Function(T value) idOf;

  List<T> readAll() => [
        for (final raw in box.values)
          if (raw != null) fromJson(asJsonMap(raw)),
      ];

  T? read(String id) {
    final raw = box.get(id);
    return raw == null ? null : fromJson(asJsonMap(raw));
  }

  Future<void> write(T value) => box.put(idOf(value), toJson(value));

  Future<void> writeAll(Iterable<T> values) => box.putAll({
        for (final v in values) idOf(v): toJson(v),
      });

  /// Deliberately absent on the audit store: see [AuditRepository].
  Future<void> delete(String id) => box.delete(id);

  int get length => box.length;
}
