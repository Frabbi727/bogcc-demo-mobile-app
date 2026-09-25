import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../core/time/local_iso.dart';
import '../../domain/models/json.dart';
import '../../domain/models/session.dart';

/// Small singleton values: what seed is loaded, who is signed in, and the
/// register sequence counters.
class MetaStore {
  MetaStore(this.box);

  final Box<dynamic> box;

  static const _seedVersion = 'seedVersion';
  static const _seedDate = 'seedDate';
  static const _sequences = 'sequences';
  static const _officeSession = 'officeSession';
  static const _citizenSession = 'citizenSession';

  int? get seedVersion => box.get(_seedVersion) as int?;
  Future<void> setSeedVersion(int v) => box.put(_seedVersion, v);

  /// The day the loaded seed was generated for. Seed dates are relative to it,
  /// so a month-old install would otherwise show a stale dashboard.
  DateTime? get seedDate => tryParseIso(box.get(_seedDate) as String?);
  Future<void> setSeedDate(DateTime d) => box.put(_seedDate, iso(d));

  Map<String, int> get sequences {
    final raw = box.get(_sequences);
    if (raw is! Map) return {};
    return {
      for (final e in raw.entries) e.key.toString(): (e.value as num).toInt(),
    };
  }

  Future<void> setSequences(Map<String, int> value) =>
      box.put(_sequences, value);

  OfficeSession? get officeSession {
    final raw = box.get(_officeSession);
    return raw == null ? null : OfficeSession.fromJson(asJsonMap(raw));
  }

  Future<void> setOfficeSession(OfficeSession? s) => s == null
      ? box.delete(_officeSession)
      : box.put(_officeSession, s.toJson());

  CitizenSession? get citizenSession {
    final raw = box.get(_citizenSession);
    return raw == null ? null : CitizenSession.fromJson(asJsonMap(raw));
  }

  Future<void> setCitizenSession(CitizenSession? s) => s == null
      ? box.delete(_citizenSession)
      : box.put(_citizenSession, s.toJson());

  Future<void> clearSessions() async {
    await box.delete(_officeSession);
    await box.delete(_citizenSession);
  }
}
