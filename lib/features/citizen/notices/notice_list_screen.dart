import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/bn/bn.dart';
import '../../../shell/demo_banner.dart';
import '../../../state/selectors/citizen_selectors.dart';
import '../../../ui/theme/spacing.dart';
import '../../../ui/widgets/empty_state.dart';

class NoticeListScreen extends ConsumerWidget {
  const NoticeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notices = ref.watch(noticesProvider);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('নোটিশ')),
      body: Column(
        children: [
          const DemoBanner(),
          Expanded(
            child: notices.isEmpty
                ? const EmptyState(
                    icon: Icons.campaign_outlined,
                    title: 'কোনো নোটিশ নেই',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(Insets.lg),
                    itemCount: notices.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: Insets.md),
                    itemBuilder: (context, index) {
                      final notice = notices[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(Insets.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notice.title, style: text.titleSmall),
                              const SizedBox(height: Insets.xs),
                              Text(notice.body, style: text.bodySmall),
                              const SizedBox(height: Insets.sm),
                              Text(
                                '${notice.byName} · ${formatDateBn(notice.at)}',
                                style: text.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
