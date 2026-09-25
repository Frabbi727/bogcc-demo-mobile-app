/// Typed stores over the Hive boxes.
///
/// These are thin on purpose. Records are loaded once at bootstrap and held in
/// the one `DemoStore` notifier, mirroring the web's single in-memory store, so
/// reads never hit Hive after boot and every selector can stay synchronous.
/// What these give is the write-through and the typing.
library;

import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../domain/models/audit_entry.dart';
import '../../domain/models/holding.dart';
import '../../domain/models/json.dart';
import '../../domain/models/licence.dart';
import '../../domain/models/messaging.dart';
import '../../domain/models/money.dart';
import '../../domain/models/register_entry.dart';
import '../local/hive_boxes.dart';
import '../local/json_box_store.dart';

JsonBoxStore<Licence> licenceStore(Box<dynamic> box) => JsonBoxStore(
      box: box,
      fromJson: Licence.fromJson,
      toJson: (v) => v.toJson(),
      idOf: (v) => v.id,
    );

JsonBoxStore<RegisterEntry> entryStore(Box<dynamic> box) => JsonBoxStore(
      box: box,
      fromJson: RegisterEntry.fromJson,
      toJson: (v) => v.toJson(),
      idOf: (v) => v.id,
    );

JsonBoxStore<Holding> holdingStore(Box<dynamic> box) => JsonBoxStore(
      box: box,
      fromJson: Holding.fromJson,
      toJson: (v) => v.toJson(),
      // Keyed by holding number rather than a synthetic id: it is the natural
      // key, it is what a citizen types, and it is unique.
      idOf: (v) => v.holdingNo,
    );

JsonBoxStore<Payment> paymentStore(Box<dynamic> box) => JsonBoxStore(
      box: box,
      fromJson: Payment.fromJson,
      toJson: (v) => v.toJson(),
      idOf: (v) => v.id,
    );

JsonBoxStore<Receipt> receiptStore(Box<dynamic> box) => JsonBoxStore(
      box: box,
      fromJson: Receipt.fromJson,
      toJson: (v) => v.toJson(),
      idOf: (v) => v.id,
    );

JsonBoxStore<AppNotification> notificationStore(Box<dynamic> box) =>
    JsonBoxStore(
      box: box,
      fromJson: AppNotification.fromJson,
      toJson: (v) => v.toJson(),
      idOf: (v) => v.id,
    );

JsonBoxStore<Notice> noticeStore(Box<dynamic> box) => JsonBoxStore(
      box: box,
      fromJson: Notice.fromJson,
      toJson: (v) => v.toJson(),
      idOf: (v) => v.id,
    );

/// The audit log, which is append-only.
///
/// This is a class rather than a [JsonBoxStore] for one reason: it must not
/// have `write` in the sense of overwrite, or `delete`, at all. "Nothing is
/// ever deleted" is easier to hold when the method does not exist than when a
/// code review has to notice it being called.
class AuditRepository {
  AuditRepository(this._box);

  final Box<dynamic> _box;

  Future<void> append(AuditEntry entry) => _box.put(entry.id, entry.toJson());

  Future<void> appendAll(Iterable<AuditEntry> entries) => _box.putAll({
        for (final e in entries) e.id: e.toJson(),
      });

  List<AuditEntry> readAll() => [
        for (final raw in _box.values)
          if (raw != null) AuditEntry.fromJson(asJsonMap(raw)),
      ];

  int get length => _box.length;
}

/// Everything, opened once.
class Repositories {
  Repositories()
      : licences = licenceStore(boxOf(Boxes.licences)),
        entries = entryStore(boxOf(Boxes.entries)),
        holdings = holdingStore(boxOf(Boxes.holdings)),
        payments = paymentStore(boxOf(Boxes.payments)),
        receipts = receiptStore(boxOf(Boxes.receipts)),
        notifications = notificationStore(boxOf(Boxes.notifications)),
        notices = noticeStore(boxOf(Boxes.notices)),
        audit = AuditRepository(boxOf(Boxes.audit));

  final JsonBoxStore<Licence> licences;
  final JsonBoxStore<RegisterEntry> entries;
  final JsonBoxStore<Holding> holdings;
  final JsonBoxStore<Payment> payments;
  final JsonBoxStore<Receipt> receipts;
  final JsonBoxStore<AppNotification> notifications;
  final JsonBoxStore<Notice> notices;
  final AuditRepository audit;
}
