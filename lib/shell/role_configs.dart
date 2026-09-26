/// One config per role.
///
/// The citizen entry is what Phase 1 renders. The ten office entries are
/// complete too: logging in as any of them produces that desk's own shell, with
/// its own tabs and its own inbox. Their screens land in Phase 2, but the shape
/// of each desk is settled here so that work is additive.
library;

import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../catalogue/users.dart';
import '../domain/enums.dart';
import 'role_config.dart';

const _citizenDestinations = <NavDestination>[
  NavDestination(
    key: 'home',
    label: 'হোম',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    route: Routes.citizenHome,
  ),
  NavDestination(
    key: 'services',
    label: 'সেবা',
    icon: Icons.grid_view_outlined,
    selectedIcon: Icons.grid_view,
    route: Routes.services,
  ),
  NavDestination(
    key: 'track',
    label: 'ট্র্যাক',
    icon: Icons.search_outlined,
    selectedIcon: Icons.search,
    route: Routes.track,
  ),
  NavDestination(
    key: 'messages',
    label: 'বার্তা',
    icon: Icons.sms_outlined,
    selectedIcon: Icons.sms,
    route: Routes.messages,
    badge: BadgeSource.unreadSms,
  ),
  NavDestination(
    key: 'me',
    label: 'আমি',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    route: Routes.profile,
  ),
];

/// The citizen home grid, matching the web's Citizen Corner tiles.
const _citizenTiles = <HomeTile>[
  HomeTile(
    label: 'আবেদন করুন',
    hint: 'ট্রেড লাইসেন্স, সনদ, অভিযোগ',
    icon: Icons.edit_document,
    route: Routes.services,
    tone: TileTone.primary,
  ),
  HomeTile(
    label: 'আবেদন ট্র্যাক করুন',
    hint: 'ট্র্যাকিং নম্বর দিয়ে অবস্থা দেখুন',
    icon: Icons.timeline,
    route: Routes.track,
  ),
  HomeTile(
    label: 'হোল্ডিং কর',
    hint: 'বকেয়া দেখুন ও পরিশোধ করুন',
    icon: Icons.home_work_outlined,
    route: Routes.holding,
  ),
  HomeTile(
    label: 'সনদ যাচাই',
    hint: 'QR স্ক্যান করে সত্যতা দেখুন',
    icon: Icons.verified_outlined,
    route: Routes.verify,
  ),
  HomeTile(
    label: 'বার্তা',
    hint: 'আপনার এসএমএস দেখুন',
    icon: Icons.sms_outlined,
    route: Routes.messages,
  ),
  HomeTile(
    label: 'নোটিশ',
    hint: 'কর্পোরেশনের ঘোষণা',
    icon: Icons.campaign_outlined,
    route: Routes.notices,
  ),
];

/// Every office desk gets the same five tabs; what differs is the inbox behind
/// "আমার কাজ" and which registers "রেজিস্টার" lists.
const _officeDestinations = <NavDestination>[
  NavDestination(
    key: 'home',
    label: 'হোম',
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    route: Routes.officeHome,
  ),
  NavDestination(
    key: 'work',
    label: 'আমার কাজ',
    icon: Icons.inbox_outlined,
    selectedIcon: Icons.inbox,
    route: Routes.officeWork,
    badge: BadgeSource.myPendingWork,
  ),
  NavDestination(
    key: 'registers',
    label: 'রেজিস্টার',
    icon: Icons.menu_book_outlined,
    selectedIcon: Icons.menu_book,
    route: Routes.officeRegisters,
  ),
  NavDestination(
    key: 'search',
    label: 'খুঁজুন',
    icon: Icons.search_outlined,
    selectedIcon: Icons.search,
    route: Routes.officeSearch,
  ),
  NavDestination(
    key: 'me',
    label: 'আমি',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    route: Routes.officeProfile,
  ),
];

ShellConfig _office(
  AppRole role, {
  required List<WorkQueueSpec> queues,
  Set<String> sections = const {},
  bool wardScoped = false,
}) {
  final user = userFor(role);
  return ShellConfig(
    role: role,
    title: user.title,
    subtitle: user.designation,
    homeRoute: Routes.officeHome,
    destinations: _officeDestinations,
    queues: queues,
    sections: sections,
    wardScoped: wardScoped,
  );
}

/// Keyed by role. Every member of [AppRole] has an entry — see the shell test.
final kShellConfigs = <AppRole, ShellConfig>{
  AppRole.citizen: const ShellConfig(
    role: AppRole.citizen,
    title: 'নাগরিক কর্নার',
    subtitle: 'বগুড়া সিটি কর্পোরেশন',
    homeRoute: Routes.citizenHome,
    destinations: _citizenDestinations,
    tiles: _citizenTiles,
  ),

  AppRole.operator: _office(
    AppRole.operator,
    sections: {'রাজস্ব শাখা'},
    queues: const [
      WorkQueueSpec(
        label: 'মিস্ত্রি নিযুক্ত করতে হবে',
        registerKeys: ['streetlight'],
        statuses: ['received'],
      ),
      WorkQueueSpec(
        label: 'সনদ ইস্যু করতে হবে',
        registerKeys: ['cert-citizen', 'cert-warish'],
        statuses: ['approved'],
      ),
    ],
  ),

  AppRole.inspector: _office(
    AppRole.inspector,
    sections: {'রাজস্ব শাখা', 'ইঞ্জিনিয়ারিং শাখা'},
    queues: const [
      WorkQueueSpec(
        label: 'মাঠ যাচাইয়ের অপেক্ষায়',
        registerKeys: ['trade-licence'],
        statuses: ['submitted'],
      ),
      WorkQueueSpec(
        label: 'পরিদর্শনের অপেক্ষায়',
        registerKeys: ['building-plan'],
        statuses: ['received'],
      ),
    ],
  ),

  AppRole.licenceOfficer: _office(
    AppRole.licenceOfficer,
    sections: {'রাজস্ব শাখা', 'লাইসেন্স শাখা'},
    queues: const [
      WorkQueueSpec(
        label: 'অনুমোদনের অপেক্ষায়',
        registerKeys: ['trade-licence'],
        statuses: ['verified'],
      ),
      WorkQueueSpec(
        label: 'প্লেট বরাদ্দের অপেক্ষায়',
        registerKeys: ['rickshaw-licence'],
        statuses: ['feePaid'],
      ),
    ],
  ),

  AppRole.accounts: _office(
    AppRole.accounts,
    sections: {'হিসাব শাখা'},
    queues: const [
      WorkQueueSpec(
        label: 'ফি আদায়ের অপেক্ষায়',
        registerKeys: ['trade-licence'],
        statuses: ['approved'],
      ),
      WorkQueueSpec(
        label: 'সনদ ফি আদায়',
        registerKeys: ['cert-citizen', 'cert-warish'],
        statuses: ['received'],
      ),
      WorkQueueSpec(
        label: 'ভাড়া আদায়',
        registerKeys: ['market-rent'],
        statuses: ['raised'],
      ),
    ],
  ),

  AppRole.revenueOfficer: _office(
    AppRole.revenueOfficer,
    sections: {'রাজস্ব শাখা'},
    queues: const [
      WorkQueueSpec(
        label: 'যাচাইয়ের অপেক্ষায়',
        registerKeys: ['market-rent'],
        statuses: ['collected'],
      ),
    ],
  ),

  AppRole.electrician: _office(
    AppRole.electrician,
    sections: {'বিদ্যুৎ শাখা'},
    queues: const [
      WorkQueueSpec(
        label: 'মেরামতের অপেক্ষায়',
        registerKeys: ['streetlight'],
        statuses: ['assigned'],
      ),
    ],
  ),

  AppRole.conservancy: _office(
    AppRole.conservancy,
    sections: {'পরিচ্ছন্নতা শাখা'},
    queues: const [
      WorkQueueSpec(
        label: 'দল নিযুক্ত করতে হবে',
        registerKeys: ['garbage'],
        statuses: ['received'],
      ),
      WorkQueueSpec(
        label: 'পরিষ্কার সম্পন্ন করতে হবে',
        registerKeys: ['garbage'],
        statuses: ['assigned'],
      ),
      WorkQueueSpec(
        label: 'ট্রিপ যাচাই',
        registerKeys: ['garbage-trips'],
        statuses: ['entry'],
      ),
    ],
  ),

  AppRole.councillor: _office(
    AppRole.councillor,
    sections: {'সাধারণ শাখা'},
    wardScoped: true,
    // Two queues rather than one: the councillor approves a citizenship
    // certificate straight after payment, but a warish certificate only after
    // staff have verified the heirs list, so the two wait at different steps.
    queues: const [
      WorkQueueSpec(
        label: 'নাগরিকত্ব সনদ — অনুমোদনের অপেক্ষায়',
        registerKeys: ['cert-citizen'],
        statuses: ['paid'],
        wardScoped: true,
      ),
      WorkQueueSpec(
        label: 'ওয়ারিশ সনদ — অনুমোদনের অপেক্ষায়',
        registerKeys: ['cert-warish'],
        statuses: ['verified'],
        wardScoped: true,
      ),
    ],
  ),

  AppRole.ceo: _office(
    AppRole.ceo,
    queues: const [
      WorkQueueSpec(
        label: 'নকশা অনুমোদনের অপেক্ষায়',
        registerKeys: ['building-plan'],
        statuses: ['inspected'],
      ),
    ],
  ),

  AppRole.mayor: _office(
    AppRole.mayor,
    queues: const [
      WorkQueueSpec(
        label: 'মেয়াদোত্তীর্ণ আবেদন',
        registerKeys: [],
        statuses: [],
      ),
    ],
  ),
};

ShellConfig shellConfigFor(AppRole role) => kShellConfigs[role]!;
