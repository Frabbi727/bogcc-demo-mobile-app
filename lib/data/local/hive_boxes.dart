/// Hive box names and lifecycle.
///
/// Values are stored as plain JSON maps (`toJson()` output), **not** through
/// Hive `TypeAdapter`s. That means no Hive codegen, no typeId registry to keep
/// in step with the freezed models, and schema evolution that is just JSON
/// tolerance. It also means every read has to go back through `asJsonMap`,
/// which is centralised in [JsonBoxStore].
library;

import 'package:hive_ce_flutter/hive_flutter.dart';

abstract final class Boxes {
  static const meta = 'meta';
  static const licences = 'licences';
  static const entries = 'entries';
  static const holdings = 'holdings';
  static const payments = 'payments';
  static const receipts = 'receipts';
  static const notifications = 'notifications';
  static const notices = 'notices';
  static const audit = 'audit';

  /// Every box except [meta], which survives a data wipe long enough to record
  /// the new seed version.
  static const dataBoxes = <String>[
    licences,
    entries,
    holdings,
    payments,
    receipts,
    notifications,
    notices,
    audit,
  ];

  static const all = <String>[meta, ...dataBoxes];
}

/// Opens every box. Call once, from bootstrap.
Future<void> openBoxes() async {
  for (final name in Boxes.all) {
    if (!Hive.isBoxOpen(name)) {
      await Hive.openBox<dynamic>(name);
    }
  }
}

Box<dynamic> boxOf(String name) => Hive.box<dynamic>(name);

/// Empties the data boxes, leaving [Boxes.meta] alone.
Future<void> clearDataBoxes() async {
  for (final name in Boxes.dataBoxes) {
    await boxOf(name).clear();
  }
}
