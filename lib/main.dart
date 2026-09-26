import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'state/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Storage and the dataset are ready before the first frame, so no screen has
  // to render a loading state over an empty store.
  final services = await bootstrap();

  runApp(
    AppProviderScope(
      services: services,
      child: const BogccApp(),
    ),
  );
}
