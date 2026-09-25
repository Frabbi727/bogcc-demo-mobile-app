import 'package:flutter/material.dart';

/// Placeholder entry point. Replaced in T14 by the bootstrap + ProviderScope.
void main() {
  runApp(const BogccApp());
}

class BogccApp extends StatelessWidget {
  const BogccApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'বগুড়া সিটি কর্পোরেশন',
      home: Scaffold(body: Center(child: Text('বগুড়া সিটি কর্পোরেশন (ডেমো)'))),
    );
  }
}
