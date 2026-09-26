/// The result of a seed build, and the marker that says which build is loaded.
library;

import '../../domain/models/audit_entry.dart';
import '../../domain/models/holding.dart';
import '../../domain/models/licence.dart';
import '../../domain/models/messaging.dart';
import '../../domain/models/money.dart';
import '../../domain/models/register_entry.dart';

/// Bump to force every install to rebuild its data on next launch.
///
/// Matches the web demo's `bogcc-demo-v3` localStorage key generation, so the
/// two are talking about the same vintage of demo data even though they do not
/// share a store.
const kSeedVersion = 3;

/// The mobile number the presenter uses to demonstrate citizen tracking.
const demoCitizenMobile = '01700000000';

class SeedData {
  const SeedData({
    required this.seedDate,
    required this.licences,
    required this.entries,
    required this.holdings,
    required this.payments,
    required this.receipts,
    required this.notifications,
    required this.notices,
    required this.audit,
    required this.sequences,
  });

  /// The day the data was generated for. Every date in it is relative to this,
  /// so the dashboards are never empty whenever the demo is shown.
  final DateTime seedDate;

  final List<Licence> licences;
  final List<RegisterEntry> entries;
  final List<Holding> holdings;
  final List<Payment> payments;
  final List<Receipt> receipts;
  final List<AppNotification> notifications;
  final List<Notice> notices;
  final List<AuditEntry> audit;

  /// Sequence key -> last used number, so serials continue where the seed left
  /// off rather than colliding with it.
  final Map<String, int> sequences;
}

/// Sequence key names, matching the web's `SEQ`.
abstract final class SeqKeys {
  static String tracking(int year) => 'tracking-$year';
  static String app(String fy) => 'app-$fy';
  static String licence(String fy) => 'TL-$fy';
  static String receipt(String fy) => 'receipt-$fy';
  static String register(String prefix, String fy) => '$prefix-$fy';
  static String certificate(String fy) => 'cert-$fy';
}
