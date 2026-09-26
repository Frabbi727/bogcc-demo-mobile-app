/// The "এই মাসে আমরা" figures on the citizen home screen.
///
/// Deliberately the small, honest subset of the web's dashboard analytics: what
/// the corporation did this month, phrased so a citizen can read it. The full
/// Mayor dashboard is Phase 2.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalogue/registers/registers.dart';
import '../../core/time/local_iso.dart';
import '../providers.dart';

class PublicStats {
  const PublicStats({
    required this.applicationsThisMonth,
    required this.resolvedThisMonth,
    required this.averageRating,
    required this.ratingCount,
  });

  final int applicationsThisMonth;
  final int resolvedThisMonth;
  final double averageRating;
  final int ratingCount;

  bool get hasRatings => ratingCount > 0;
}

final publicStatsProvider = Provider<PublicStats>((ref) {
  final state = ref.watch(demoStoreProvider);
  final from = DateTime(now().year, now().month);

  // Internal books are excluded: a trip log line is not a citizen's
  // application, and counting it would overstate what the month achieved.
  final citizenEntries = state.entries.where(
    (e) => getRegister(e.registerKey)?.citizenFacing ?? false,
  );

  var applications = 0;
  var resolved = 0;
  var ratingTotal = 0;
  var ratingCount = 0;

  void tally(DateTime createdAt, DateTime? closedAt, int? rating) {
    if (!createdAt.isBefore(from)) applications += 1;
    if (closedAt != null && !closedAt.isBefore(from)) resolved += 1;
    if (rating != null) {
      ratingTotal += rating;
      ratingCount += 1;
    }
  }

  for (final e in citizenEntries) {
    tally(e.createdAt, e.closedAt, e.feedback?.rating);
  }
  for (final l in state.licences) {
    tally(l.createdAt, l.closedAt, l.feedback?.rating);
  }

  return PublicStats(
    applicationsThisMonth: applications,
    resolvedThisMonth: resolved,
    averageRating: ratingCount == 0 ? 0 : ratingTotal / ratingCount,
    ratingCount: ratingCount,
  );
});
