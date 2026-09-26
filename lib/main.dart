import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'shell/demo_banner.dart';
import 'state/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Storage and the dataset are ready before the first frame, so no screen has
  // to render a loading state over an empty store.
  final services = await bootstrap();

  runApp(
    AppProviderScope(
      services: services,
      // Replaced by the router in T16.
      child: const BogccApp(
        home: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                DemoBanner(),
                Expanded(child: Center(child: Text('বগুড়া সিটি কর্পোরেশন'))),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
