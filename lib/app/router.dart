/// The router.
///
/// Two shell routes — `/nagorik` and `/office` — both wrapped by the same
/// [AppShell], because go_router needs branches declared statically while the
/// tabs themselves come from the signed-in role's config.
///
/// Public routes sit outside both shells so a scanned QR code opens without
/// anyone being signed in, exactly as on the web.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/citizen/apply/apply_screen.dart';
import '../features/citizen/home/citizen_home_screen.dart';
import '../features/citizen/messages/messages_screen.dart';
import '../features/citizen/notices/notice_list_screen.dart';
import '../features/citizen/payment/pay_screen.dart';
import '../features/citizen/payment/receipt_screen.dart';
import '../features/citizen/profile/about_screen.dart';
import '../features/citizen/profile/profile_screen.dart';
import '../features/citizen/services/service_charter_screen.dart';
import '../features/citizen/services/service_list_screen.dart';
import '../features/citizen/track/request_detail_screen.dart';
import '../features/citizen/track/track_screen.dart';
import '../features/office/coming_soon_screen.dart';
import '../shell/app_shell.dart';
import '../state/session_controller.dart';
import 'routes.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// Routes anyone may open, signed in or not.
///
/// The document and verify pages are public so a scanned QR code just opens,
/// which is the whole point of printing one — the person checking a certificate
/// is usually not the person it belongs to.
bool isPublicRoute(String location) =>
    location.startsWith(Routes.login) ||
    location.startsWith(Routes.verify) ||
    location.startsWith(Routes.document) ||
    location.startsWith(Routes.receipt) ||
    location.startsWith(Routes.pay);

/// Where a request for [location] should actually go, or null to allow it.
///
/// Pulled out of the router as a pure function so it can be tested directly:
/// it is the rule that keeps each role inside its own shell, and driving a
/// whole widget tree to check it is slow and tells you less.
String? redirectFor({required Session session, required String location}) {
  if (isPublicRoute(location)) return null;

  if (!session.isSignedIn) return Routes.login;

  final home = session.role.isOffice ? Routes.officeHome : Routes.citizenHome;

  // Send the root at whoever is signed in, and keep each side out of the
  // other's shell: the two have different tabs, so crossing over would render
  // a bar that does not match the branch it is sitting in.
  if (location == Routes.root) return home;
  if (session.role.isOffice && location.startsWith('/nagorik')) return home;
  if (!session.role.isOffice && location.startsWith('/office')) return home;

  return null;
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.root,
    refreshListenable: _SessionListenable(ref),
    redirect: (context, state) => redirectFor(
      session: ref.read(sessionProvider),
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: Routes.root,
        builder: (_, _) => const SizedBox.shrink(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.otp,
        builder: (_, state) => OtpScreen(
          mobile: state.uri.queryParameters['mobile'] ?? '',
        ),
      ),

      // Citizen screens that sit outside the tab shell, so they open over it
      // with a back arrow rather than swapping a tab underneath the user.
      GoRoute(
        path: Routes.notices,
        builder: (_, _) => const NoticeListScreen(),
      ),
      GoRoute(
        path: Routes.about,
        builder: (_, _) => const AboutScreen(),
      ),
      GoRoute(
        path: Routes.holding,
        builder: (_, _) => Scaffold(
          appBar: AppBar(title: const Text('হোল্ডিং কর')),
          body: const ComingSoonScreen(
            title: 'হোল্ডিং কর',
            detail: 'হোল্ডিং নম্বর দিয়ে বকেয়া দেখা ও অনলাইনে পরিশোধ।',
          ),
        ),
      ),
      // The gateway and the receipt it produces. Both public: a payment link
      // and a receipt are each opened from an SMS as often as from inside the
      // app, and the person holding a receipt need not be signed in.
      GoRoute(
        path: '${Routes.pay}/:paymentId',
        builder: (_, state) => PayScreen(
          paymentId: state.pathParameters['paymentId']!,
        ),
      ),
      GoRoute(
        path: '${Routes.receipt}/:id',
        builder: (_, state) => ReceiptScreen(
          receiptId: state.pathParameters['id']!,
        ),
      ),

      GoRoute(
        path: Routes.verify,
        builder: (_, _) => Scaffold(
          appBar: AppBar(title: const Text('সনদ যাচাই')),
          body: const ComingSoonScreen(
            title: 'সনদ যাচাই',
            detail: 'সনদের QR স্ক্যান করে বা নম্বর দিয়ে সত্যতা যাচাই।',
          ),
        ),
      ),

      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.citizenHome,
              builder: (_, _) => const CitizenHomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.services,
              builder: (_, _) => const ServiceListScreen(),
              routes: [
                GoRoute(
                  // Relative to the parent, so this is /nagorik/services/:key.
                  path: ':key',
                  parentNavigatorKey: _rootKey,
                  builder: (_, state) => ServiceCharterScreen(
                    serviceKey: state.pathParameters['key']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'apply',
                      parentNavigatorKey: _rootKey,
                      builder: (_, state) => ApplyScreen(
                        serviceKey: state.pathParameters['key']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.track,
              builder: (_, _) => const TrackScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: _rootKey,
                  builder: (_, state) => RequestDetailScreen(
                    recordId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.messages,
              builder: (_, _) => const MessagesScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.profile,
              builder: (_, _) => const ProfileScreen(),
            ),
          ]),
        ],
      ),

      // Phase 2. Declared now so every office role already lands in its own
      // shell rather than on an error page.
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(navigationShell: shell),
        branches: [
          for (final (path, title) in const [
            (Routes.officeHome, 'দপ্তরের হোম'),
            (Routes.officeWork, 'আমার কাজ'),
            (Routes.officeRegisters, 'রেজিস্টার বই'),
            (Routes.officeSearch, 'খোঁজ'),
            (Routes.officeProfile, 'আমি'),
          ])
            StatefulShellBranch(routes: [
              GoRoute(
                path: path,
                builder: (_, _) => ComingSoonScreen(title: title),
              ),
            ]),
        ],
      ),
    ],
  );
});

/// Rebuilds the router's redirect when someone signs in or out.
class _SessionListenable extends ChangeNotifier {
  _SessionListenable(Ref ref) {
    ref.listen(sessionProvider, (_, _) => notifyListeners());
  }
}
