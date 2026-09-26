import 'package:flutter/material.dart';

import '../../ui/theme/colors.dart';
import '../../ui/theme/spacing.dart';

/// Placeholder for a screen Phase 2 will build.
///
/// It names the desk and what it will do, so logging in as any of the ten
/// office roles already shows that role's own shell rather than an error.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({required this.title, this.detail, super.key});

  final String title;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Insets.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction_outlined,
                size: 40, color: AppColors.muted),
            const SizedBox(height: Insets.md),
            Text(title, style: text.titleMedium, textAlign: TextAlign.center),
            if (detail != null) ...[
              const SizedBox(height: Insets.sm),
              Text(detail!, style: text.bodySmall, textAlign: TextAlign.center),
            ],
            const SizedBox(height: Insets.md),
            Text(
              'এই অংশটি দ্বিতীয় ধাপে যুক্ত হবে।',
              style: text.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
