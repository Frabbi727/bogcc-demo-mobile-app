import '../local/meta_store.dart';

/// Gapless counters, one per register per fiscal year.
///
/// A register book's serials run 1, 2, 3 with no holes — a missing number is
/// the first thing an auditor asks about — so a serial is handed out at the
/// exact moment the paper book would get its next line, and never reserved
/// ahead or rolled back.
///
/// [next] is **synchronous and contains no `await`** on purpose. Dart's event
/// loop cannot interleave another caller inside a synchronous method, so
/// read-increment-write is atomic without a lock. Making it async would open a
/// window where two callers read 6 and both write 7.
///
/// Persisting is therefore separate: callers take a number, finish whatever
/// they were writing, then [flush]. Every mutation in the store is already
/// async and already awaits its own writes, so this adds no new await points —
/// and it avoids firing an unawaited box write per serial, which is both
/// wasteful and a way to have writes still in flight when the box closes.
class SequenceService {
  SequenceService(this._meta) : _values = Map.of(_meta.sequences);

  final MetaStore _meta;
  final Map<String, int> _values;

  /// The next number for [key], e.g. `SL-2026-27` or `receipt-2026-27`.
  int next(String key) {
    final value = (_values[key] ?? 0) + 1;
    _values[key] = value;
    return value;
  }

  /// The last number handed out for [key], without advancing.
  int peek(String key) => _values[key] ?? 0;

  /// Used by the seed builder, which assigns serials in bulk and then tells the
  /// service where the counters ended up.
  void set(String key, int value) => _values[key] = value;

  Map<String, int> snapshot() => Map.unmodifiable(_values);

  /// Writes the counters to disk. Call after the record that used them.
  Future<void> flush() => _meta.setSequences(_values);

  Future<void> reset() async {
    _values.clear();
    await flush();
  }
}
