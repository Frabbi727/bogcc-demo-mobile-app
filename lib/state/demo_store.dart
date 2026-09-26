/// The one mutable store, mirroring the web demo's single zustand store.
library;

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/repositories.dart';
import '../data/repositories/sequence_service.dart';
import '../data/seed/seed_data.dart';
import '../domain/models/audit_entry.dart';
import '../domain/models/holding.dart';
import '../domain/models/licence.dart';
import '../domain/models/messaging.dart';
import '../domain/models/money.dart';
import '../domain/models/register_entry.dart';

/// Everything, held in memory.
///
/// The whole dataset is small enough to load once at boot — a few hundred
/// records — so reads never touch Hive after that and every selector can stay
/// synchronous. Writes update this state *and* write through to their box.
class DemoState {
  const DemoState({
    this.licences = const [],
    this.entries = const [],
    this.holdings = const [],
    this.payments = const [],
    this.receipts = const [],
    this.notifications = const [],
    this.notices = const [],
    this.audit = const [],
  });

  final List<Licence> licences;
  final List<RegisterEntry> entries;
  final List<Holding> holdings;
  final List<Payment> payments;
  final List<Receipt> receipts;
  final List<AppNotification> notifications;
  final List<Notice> notices;
  final List<AuditEntry> audit;

  DemoState copyWith({
    List<Licence>? licences,
    List<RegisterEntry>? entries,
    List<Holding>? holdings,
    List<Payment>? payments,
    List<Receipt>? receipts,
    List<AppNotification>? notifications,
    List<Notice>? notices,
    List<AuditEntry>? audit,
  }) {
    return DemoState(
      licences: licences ?? this.licences,
      entries: entries ?? this.entries,
      holdings: holdings ?? this.holdings,
      payments: payments ?? this.payments,
      receipts: receipts ?? this.receipts,
      notifications: notifications ?? this.notifications,
      notices: notices ?? this.notices,
      audit: audit ?? this.audit,
    );
  }

  static DemoState fromSeed(SeedData seed) => DemoState(
        licences: seed.licences,
        entries: seed.entries,
        holdings: seed.holdings,
        payments: seed.payments,
        receipts: seed.receipts,
        notifications: seed.notifications,
        notices: seed.notices,
        audit: seed.audit,
      );

  static DemoState fromRepositories(Repositories repos) => DemoState(
        licences: repos.licences.readAll(),
        entries: repos.entries.readAll(),
        holdings: repos.holdings.readAll(),
        payments: repos.payments.readAll(),
        receipts: repos.receipts.readAll(),
        notifications: repos.notifications.readAll(),
        notices: repos.notices.readAll(),
        audit: repos.audit.readAll(),
      );

  /* ---- lookups the screens need ---- */

  Licence? licence(String id) => licences.firstWhereOrNull((l) => l.id == id);

  RegisterEntry? entry(String id) => entries.firstWhereOrNull((e) => e.id == id);

  Holding? holding(String holdingNo) =>
      holdings.firstWhereOrNull((h) => h.holdingNo == holdingNo);

  Receipt? receipt(String id) => receipts.firstWhereOrNull((r) => r.id == id);

  Payment? payment(String id) => payments.firstWhereOrNull((p) => p.id == id);

  /// Finds a record by the number a citizen was given, of either kind.
  ///
  /// Returns a [BaseRecord] rather than a union so the tracking screen does not
  /// have to care which module the request belongs to.
  Object? byTrackingNo(String trackingNo) {
    final normalised = trackingNo.trim().toUpperCase();
    return licences.firstWhereOrNull((l) => l.trackingNo == normalised) ??
        entries.firstWhereOrNull((e) => e.trackingNo == normalised);
  }
}

/// Replaces the element matching [id], or appends it when it is new.
///
/// Written as a function rather than inline `cond ? [...] : [...]..[i] = x`:
/// the cascade there binds to the *whole* conditional, not to the else branch,
/// so the assignment also ran on the append path with an index of -1.
List<T> _upsert<T>(List<T> items, T value, bool Function(T) matches) {
  final index = items.indexWhere(matches);
  if (index < 0) return [...items, value];
  final next = [...items];
  next[index] = value;
  return next;
}

/// Owns the state and every write to it.
class DemoStore extends Notifier<DemoState> {
  DemoStore(this._repos, this._sequences, this._initial);

  final Repositories _repos;
  final SequenceService _sequences;
  final DemoState _initial;

  Repositories get repositories => _repos;
  SequenceService get sequences => _sequences;

  @override
  DemoState build() => _initial;

  /// The current state, readable from the action files.
  ///
  /// `state` itself is `@protected` on [Notifier], and the actions live outside
  /// this class on purpose — they are grouped by what they do, not by which
  /// notifier holds the data. This is the one door they read through.
  DemoState get current => state;

  /* ---- write-through helpers used by the action files ---- */

  Future<void> putEntry(RegisterEntry entry) async {
    state = state.copyWith(
      entries: _upsert(state.entries, entry, (e) => e.id == entry.id),
    );
    await _repos.entries.write(entry);
  }

  Future<void> putLicence(Licence licence) async {
    state = state.copyWith(
      licences: _upsert(state.licences, licence, (l) => l.id == licence.id),
    );
    await _repos.licences.write(licence);
  }

  Future<void> putHolding(Holding holding) async {
    state = state.copyWith(
      holdings: _upsert(
        state.holdings,
        holding,
        (h) => h.holdingNo == holding.holdingNo,
      ),
    );
    await _repos.holdings.write(holding);
  }

  Future<void> putPayment(Payment payment) async {
    state = state.copyWith(
      payments: _upsert(state.payments, payment, (p) => p.id == payment.id),
    );
    await _repos.payments.write(payment);
  }

  Future<void> putReceipt(Receipt receipt) async {
    state = state.copyWith(receipts: [...state.receipts, receipt]);
    await _repos.receipts.write(receipt);
  }

  Future<void> putNotification(AppNotification notification) async {
    state = state.copyWith(
      notifications: _upsert(
        state.notifications,
        notification,
        (n) => n.id == notification.id,
      ),
    );
    await _repos.notifications.write(notification);
  }

  /// Append-only, like the repository behind it.
  Future<void> appendAudit(AuditEntry entry) async {
    state = state.copyWith(audit: [...state.audit, entry]);
    await _repos.audit.append(entry);
  }

  /// Persists the serial counters. Call after the record that used them.
  Future<void> flushSequences() => _sequences.flush();
}
