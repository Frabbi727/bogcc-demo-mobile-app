/// Opens storage, seeds on first run, and builds the provider graph.
library;

import 'package:hive_ce_flutter/hive_flutter.dart';

import '../core/time/local_iso.dart';
import '../data/local/hive_boxes.dart';
import '../data/local/meta_store.dart';
import '../data/local/photo_store.dart';
import '../data/repositories/repositories.dart';
import '../data/repositories/sequence_service.dart';
import '../data/seed/seed_builder.dart';
import '../data/seed/seed_data.dart';
import '../state/demo_store.dart';

/// What bootstrap produces, ready to be injected into the provider graph.
class AppServices {
  const AppServices({
    required this.repositories,
    required this.meta,
    required this.sequences,
    required this.photos,
    required this.initialState,
    required this.seeded,
  });

  final Repositories repositories;
  final MetaStore meta;
  final SequenceService sequences;
  final PhotoStore photos;
  final DemoState initialState;

  /// True when this launch generated a fresh dataset.
  final bool seeded;
}

/// Opens Hive, seeds if needed, and loads everything into memory.
Future<AppServices> bootstrap() async {
  await Hive.initFlutter();
  await openBoxes();

  final meta = MetaStore(boxOf(Boxes.meta));
  final repositories = Repositories();
  final photos = await PhotoStore.open();

  // A version mismatch means the shape of the data changed, so the old rows
  // cannot be trusted. Reseeding is always safe here: nothing in this app is
  // real, and ডেমো রিসেট does the same thing on demand.
  final seeded = meta.seedVersion != kSeedVersion;
  if (seeded) {
    await _reseed(meta: meta, repositories: repositories, photos: photos);
  }

  return AppServices(
    repositories: repositories,
    meta: meta,
    sequences: SequenceService(meta),
    photos: photos,
    initialState: DemoState.fromRepositories(repositories),
    seeded: seeded,
  );
}

/// Wipes and regenerates the dataset for today. Shared by first run and reset.
Future<void> _reseed({
  required MetaStore meta,
  required Repositories repositories,
  required PhotoStore photos,
}) async {
  await clearDataBoxes();
  await photos.clear();

  final seed = buildSeed(now());

  await repositories.licences.writeAll(seed.licences);
  await repositories.entries.writeAll(seed.entries);
  await repositories.holdings.writeAll(seed.holdings);
  await repositories.payments.writeAll(seed.payments);
  await repositories.receipts.writeAll(seed.receipts);
  await repositories.notifications.writeAll(seed.notifications);
  await repositories.notices.writeAll(seed.notices);
  await repositories.audit.appendAll(seed.audit);

  // The counters have to land where the seed stopped, or the first record the
  // user creates would collide with a seeded serial.
  await meta.setSequences(seed.sequences);
  await meta.setSeedDate(seed.seedDate);
  await meta.setSeedVersion(kSeedVersion);
}

/// ডেমো রিসেট: back to a fresh dataset for today, sessions cleared.
Future<DemoState> resetDemo(AppServices services) async {
  await services.meta.clearSessions();
  await _reseed(
    meta: services.meta,
    repositories: services.repositories,
    photos: services.photos,
  );
  return DemoState.fromRepositories(services.repositories);
}
