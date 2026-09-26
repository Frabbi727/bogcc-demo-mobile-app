/// The provider graph.
///
/// Declared by hand rather than generated: riverpod_generator needs a newer
/// analyzer than freezed 3.x allows on this SDK (see pubspec.yaml). The cost is
/// a few lines per provider.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/bootstrap.dart';
import '../data/local/meta_store.dart';
import '../data/local/photo_store.dart';
import '../data/repositories/repositories.dart';
import '../data/repositories/sequence_service.dart';
import 'demo_store.dart';

/// Overridden in main() once bootstrap has run, so nothing downstream has to
/// deal with an async or nullable dataset.
final appServicesProvider = Provider<AppServices>(
  (ref) => throw StateError('appServicesProvider must be overridden in main()'),
);

final repositoriesProvider = Provider<Repositories>(
  (ref) => ref.watch(appServicesProvider).repositories,
);

final metaStoreProvider = Provider<MetaStore>(
  (ref) => ref.watch(appServicesProvider).meta,
);

final sequenceServiceProvider = Provider<SequenceService>(
  (ref) => ref.watch(appServicesProvider).sequences,
);

final photoStoreProvider = Provider<PhotoStore>(
  (ref) => ref.watch(appServicesProvider).photos,
);

final demoStoreProvider = NotifierProvider<DemoStore, DemoState>(() {
  throw StateError('demoStoreProvider must be overridden in main()');
});

/// Wires what bootstrap produced into the graph.
///
/// A widget rather than a `List<Override>` helper because flutter_riverpod
/// 3.4.3 does not export the `Override` type, so the list cannot be named. It
/// also reads better: main() and every widget test wrap the same way.
class AppProviderScope extends StatelessWidget {
  const AppProviderScope({
    required this.services,
    required this.child,
    super.key,
  });

  final AppServices services;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        appServicesProvider.overrideWithValue(services),
        demoStoreProvider.overrideWith(
          () => DemoStore(
            services.repositories,
            services.sequences,
            services.initialState,
          ),
        ),
      ],
      child: child,
    );
  }
}
