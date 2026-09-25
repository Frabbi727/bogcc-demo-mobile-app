import 'package:flutter/material.dart';

import '../ui/theme/colors.dart';
import '../ui/theme/spacing.dart';

/// Shown on every screen except the document views, so nobody mistakes the
/// seeded data for a live system. Ported from the web's `DemoBanner.tsx`.
class DemoBanner extends StatelessWidget {
  const DemoBanner({super.key});

  static const label = 'ডেমো সংস্করণ: সকল তথ্য কাল্পনিক';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // The web uses amber at 12% over the page; the same tint over paper.
      color: AppColors.amber.withValues(alpha: 0.12),
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.lg,
        vertical: Insets.sm - 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning_amber_rounded,
              size: 16, color: AppColors.amber),
          const SizedBox(width: Insets.sm),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.amber,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
