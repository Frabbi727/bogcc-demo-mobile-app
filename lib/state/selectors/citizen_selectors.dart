/// Read-models over the store for the citizen side.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/base_record.dart';
import '../../domain/models/messaging.dart';
import '../demo_store.dart';
import '../providers.dart';
import '../session_controller.dart';

/// The signed-in citizen's mobile number, or null on the office side.
final citizenMobileProvider = Provider<String?>(
  (ref) => ref.watch(sessionProvider).citizen?.mobile,
);

/// Everything the signed-in citizen has applied for, newest first.
final myRequestsProvider = Provider<List<BaseRecord>>((ref) {
  final mobile = ref.watch(citizenMobileProvider);
  if (mobile == null) return const [];
  final state = ref.watch(demoStoreProvider);
  final mine = <BaseRecord>[
    ...state.licences.where((l) => l.applicantMobile == mobile),
    ...state.entries.where((e) => e.applicantMobile == mobile),
  ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return mine;
});

/// The citizen's simulated SMS inbox, newest first.
final myMessagesProvider = Provider<List<AppNotification>>((ref) {
  final mobile = ref.watch(citizenMobileProvider);
  if (mobile == null) return const [];
  final messages = ref
      .watch(demoStoreProvider)
      .notifications
      .where((n) => n.mobile == mobile)
      .toList()
    ..sort((a, b) => b.at.compareTo(a.at));
  return messages;
});

final unreadMessageCountProvider = Provider<int>(
  (ref) => ref.watch(myMessagesProvider).where((n) => !n.read).length,
);

/// Public notices, newest first.
final noticesProvider = Provider((ref) {
  final notices = [...ref.watch(demoStoreProvider).notices]
    ..sort((a, b) => b.at.compareTo(a.at));
  return notices;
});

/// Looks up a record by tracking number **and** mobile.
///
/// Both are required on purpose: a tracking number alone is guessable, and
/// someone else's application is not a citizen's to read.
BaseRecord? findByTracking(DemoState state, String trackingNo, String mobile) {
  final normalised = trackingNo.trim().toUpperCase();
  final match = state.byTrackingNo(normalised);
  if (match is! BaseRecord) return null;
  return match.applicantMobile == mobile ? match : null;
}
