import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/bn/bn.dart';
import '../../../state/selectors/citizen_selectors.dart';
import '../../../ui/theme/colors.dart';
import '../../../ui/theme/spacing.dart';
import '../../../ui/widgets/empty_state.dart';

/// The simulated SMS inbox.
///
/// Nothing was ever sent — the app has no network — so this is the delivery
/// mechanism, and it is labelled as such rather than implying a real message.
class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(myMessagesProvider);

    if (messages.isEmpty) {
      return const EmptyState(
        icon: Icons.sms_outlined,
        title: 'কোনো বার্তা নেই',
        detail: 'আবেদন করলে প্রতিটি ধাপে এখানে বার্তা আসবে।',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(Insets.lg),
      itemCount: messages.length,
      separatorBuilder: (_, _) => const SizedBox(height: Insets.sm),
      itemBuilder: (context, index) {
        final message = messages[index];
        final text = Theme.of(context).textTheme;

        return Container(
          padding: const EdgeInsets.all(Insets.md),
          decoration: BoxDecoration(
            color: message.read ? AppColors.page : AppColors.forest50,
            borderRadius: BorderRadius.circular(Radii.md),
            border: Border.all(
              color: message.read ? AppColors.rule : AppColors.forest700,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    message.read
                        ? Icons.mark_email_read_outlined
                        : Icons.mark_email_unread,
                    size: 15,
                    color: message.read ? AppColors.muted : AppColors.forest700,
                  ),
                  const SizedBox(width: Insets.sm),
                  Expanded(
                    child: Text(
                      message.trackingNo ?? 'বগুড়া সিটি কর্পোরেশন',
                      style: text.labelMedium,
                    ),
                  ),
                  Text(timeAgoBn(message.at), style: text.labelSmall),
                ],
              ),
              const SizedBox(height: Insets.sm),
              Text(message.text, style: text.bodyMedium),
              const SizedBox(height: Insets.xs),
              Text(formatDateTimeBn(message.at), style: text.labelSmall),
            ],
          ),
        );
      },
    );
  }
}
