import 'package:bogcc_demo_mobile_app/app/router.dart';
import 'package:bogcc_demo_mobile_app/app/routes.dart';
import 'package:bogcc_demo_mobile_app/core/time/local_iso.dart';
import 'package:bogcc_demo_mobile_app/domain/enums.dart';
import 'package:bogcc_demo_mobile_app/domain/models/session.dart';
import 'package:bogcc_demo_mobile_app/state/session_controller.dart';
import 'package:flutter_test/flutter_test.dart';

final _citizen = Session(
  citizen: CitizenSession(mobile: '01700000000', since: now()),
);

Session _office(AppRole role) => Session(
      office: OfficeSession(role: role, name: 'x', since: now()),
    );

void main() {
  group('nobody signed in', () {
    test('is sent to the front door', () {
      expect(
        redirectFor(session: Session.none, location: Routes.citizenHome),
        Routes.login,
      );
      expect(
        redirectFor(session: Session.none, location: Routes.officeHome),
        Routes.login,
      );
      expect(
        redirectFor(session: Session.none, location: Routes.root),
        Routes.login,
      );
    });

    test('can still open a scanned certificate', () {
      // The person checking a certificate is usually not the person it belongs
      // to, so requiring a session here would make the printed QR useless.
      for (final location in [
        Routes.verify,
        '${Routes.verify}?no=BOGCC/CERT/2026-27/0042',
        Routes.scan,
        Routes.documentFor('certificate', 'cc001'),
        Routes.receiptFor('rc0001'),
      ]) {
        expect(
          redirectFor(session: Session.none, location: location),
          isNull,
          reason: location,
        );
      }
    });

    test('can reach login and OTP without bouncing', () {
      // A bounce here would be an infinite redirect.
      expect(redirectFor(session: Session.none, location: Routes.login), isNull);
      expect(redirectFor(session: Session.none, location: Routes.otp), isNull);
    });
  });

  group('a signed-in citizen', () {
    test('lands on the citizen home from the root', () {
      expect(
        redirectFor(session: _citizen, location: Routes.root),
        Routes.citizenHome,
      );
    });

    test('moves freely inside their own shell', () {
      for (final location in [
        Routes.citizenHome,
        Routes.services,
        Routes.track,
        Routes.messages,
        Routes.profile,
        Routes.requestDetailFor('sl001'),
        Routes.applyFor('streetlight'),
      ]) {
        expect(
          redirectFor(session: _citizen, location: location),
          isNull,
          reason: location,
        );
      }
    });

    test('cannot wander into an office shell', () {
      // The two shells have different tabs, so rendering one inside the other
      // would show a bar that does not match the branch it sits in.
      expect(
        redirectFor(session: _citizen, location: Routes.officeHome),
        Routes.citizenHome,
      );
      expect(
        redirectFor(session: _citizen, location: Routes.officeRegisters),
        Routes.citizenHome,
      );
    });
  });

  group('a signed-in officer', () {
    test('lands on the office home from the root, whichever desk', () {
      for (final role in AppRole.values.where((r) => r.isOffice)) {
        expect(
          redirectFor(session: _office(role), location: Routes.root),
          Routes.officeHome,
          reason: role.name,
        );
      }
    });

    test('moves freely inside the office shell', () {
      final session = _office(AppRole.accounts);
      for (final location in [
        Routes.officeHome,
        Routes.officeWork,
        Routes.officeRegisters,
        Routes.officeSearch,
        Routes.officeProfile,
      ]) {
        expect(redirectFor(session: session, location: location), isNull,
            reason: location);
      }
    });

    test('cannot wander into the citizen corner', () {
      final session = _office(AppRole.electrician);
      expect(
        redirectFor(session: session, location: Routes.citizenHome),
        Routes.officeHome,
      );
      expect(
        redirectFor(session: session, location: Routes.messages),
        Routes.officeHome,
      );
    });

    test('can still open a public document', () {
      expect(
        redirectFor(
          session: _office(AppRole.ceo),
          location: Routes.documentFor('certificate', 'cc001'),
        ),
        isNull,
      );
    });
  });

  group('no redirect loops', () {
    test('every redirect target is itself allowed', () {
      // A target that redirects again is an infinite loop at runtime, which
      // shows up as a frozen app rather than an error.
      final sessions = [
        Session.none,
        _citizen,
        for (final role in AppRole.values.where((r) => r.isOffice))
          _office(role),
      ];
      const locations = [
        Routes.root,
        Routes.login,
        Routes.otp,
        Routes.citizenHome,
        Routes.services,
        Routes.track,
        Routes.messages,
        Routes.profile,
        Routes.officeHome,
        Routes.officeWork,
        Routes.verify,
      ];

      for (final session in sessions) {
        for (final location in locations) {
          final first = redirectFor(session: session, location: location);
          if (first == null) continue;
          expect(
            redirectFor(session: session, location: first),
            isNull,
            reason: '$location -> $first loops for ${session.role.name}',
          );
        }
      }
    });
  });

  group('isPublicRoute', () {
    test('covers exactly the routes meant to be open', () {
      expect(isPublicRoute(Routes.login), isTrue);
      expect(isPublicRoute(Routes.verify), isTrue);
      expect(isPublicRoute(Routes.document), isTrue);
      expect(isPublicRoute(Routes.receipt), isTrue);
      expect(isPublicRoute(Routes.citizenHome), isFalse);
      expect(isPublicRoute(Routes.officeHome), isFalse);
      expect(isPublicRoute(Routes.root), isFalse);
    });
  });
}
