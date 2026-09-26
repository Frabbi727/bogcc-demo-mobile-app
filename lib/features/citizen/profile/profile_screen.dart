import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/bootstrap.dart';
import '../../../app/routes.dart';
import '../../../core/bn/bn.dart';
import '../../../state/providers.dart';
import '../../../state/session_controller.dart';
import '../../../ui/theme/colors.dart';
import '../../../ui/theme/spacing.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final meta = ref.watch(metaStoreProvider);
    final text = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(Insets.lg),
      children: [
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.forest50,
              child: Icon(Icons.person_outline, color: AppColors.forest700),
            ),
            title: Text(toBnDigits(session.displayName), style: text.titleSmall),
            subtitle: Text(
              session.role.isOffice ? 'অফিস ব্যবহারকারী' : 'নাগরিক',
              style: text.bodySmall,
            ),
          ),
        ),
        const SizedBox(height: Insets.lg),

        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('অ্যাপ সম্পর্কে'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(Routes.about),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.campaign_outlined),
                title: const Text('নোটিশ'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(Routes.notices),
              ),
            ],
          ),
        ),
        const SizedBox(height: Insets.lg),

        Text('ডেমো', style: text.titleMedium),
        const SizedBox(height: Insets.sm),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.restart_alt, color: AppColors.stamp),
                title: const Text('ডেমো রিসেট'),
                subtitle: Text(
                  meta.seedDate == null
                      ? 'সব তথ্য নতুন করে তৈরি হবে'
                      : 'বর্তমান তথ্য ${formatDateBn(meta.seedDate!)} তারিখের',
                  style: text.labelSmall,
                ),
                onTap: () => _confirmReset(context, ref),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('সাইন আউট'),
                onTap: () async {
                  await ref.read(sessionProvider.notifier).signOut();
                  if (context.mounted) context.go(Routes.login);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ডেমো রিসেট করবেন?'),
        content: const Text(
          'সব তথ্য মুছে আজকের তারিখ অনুযায়ী নতুন ডেমো তথ্য তৈরি হবে। '
          'আপনার করা আবেদনগুলোও মুছে যাবে।',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('থাক'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('রিসেট করুন'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final services = ref.read(appServicesProvider);
    await resetDemo(services);
    // The store is rebuilt from the fresh boxes, and the session is gone, so
    // the router's redirect takes us back to the front door.
    ref.invalidate(demoStoreProvider);
    ref.invalidate(sessionProvider);
    if (context.mounted) context.go(Routes.login);
  }
}
