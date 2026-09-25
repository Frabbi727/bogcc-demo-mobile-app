import 'package:flutter/material.dart';

import 'app/app.dart';
import 'shell/demo_banner.dart';

/// Placeholder entry point. Replaced in T14 by bootstrap + ProviderScope, and
/// in T16 by the router.
void main() {
  runApp(
    const BogccApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              DemoBanner(),
              Expanded(
                child: Center(child: Text('বগুড়া সিটি কর্পোরেশন')),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
