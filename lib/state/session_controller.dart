/// Who is signed in, for both faces of the app.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../catalogue/users.dart';
import '../core/time/local_iso.dart';
import '../data/local/meta_store.dart';
import '../domain/enums.dart';
import '../domain/models/session.dart';
import '../shell/role_config.dart';
import '../shell/role_configs.dart';
import 'providers.dart';

/// The signed-in party, or nobody.
///
/// One type for both faces so the shell can ask a single question — what role
/// is this? — rather than branching on which of two sessions exists.
class Session {
  const Session({this.office, this.citizen});

  final OfficeSession? office;
  final CitizenSession? citizen;

  bool get isSignedIn => office != null || citizen != null;

  AppRole get role => office?.role ?? AppRole.citizen;

  /// What to put in the app bar: the desk's title, or the citizen's number.
  String get displayName =>
      office?.name ?? citizen?.mobile ?? userFor(AppRole.citizen).name;

  static const none = Session();
}

class SessionController extends Notifier<Session> {
  MetaStore get _meta => ref.read(metaStoreProvider);

  @override
  // Phase 2: the office face is disabled for this demo, so a desk session left
  // on the device is ignored rather than restored. See doc/remaining-work.md.
  // Session build() =>
  //     Session(office: _meta.officeSession, citizen: _meta.citizenSession);
  Session build() => Session(citizen: _meta.citizenSession);

  /// Signs in at an office desk.
  ///
  /// There is no password, exactly as on the web: the demo is about which desk
  /// does which step, not about authentication.
  Future<void> signInAsOffice(AppRole role) async {
    assert(role.isOffice, 'Use signInAsCitizen for the citizen side');
    final session = OfficeSession(
      role: role,
      name: userFor(role).name,
      since: now(),
    );
    await _meta.setOfficeSession(session);
    await _meta.setCitizenSession(null);
    state = Session(office: session);
  }

  /// Signs a citizen in against their mobile number.
  ///
  /// The OTP is simulated and shown on screen; see the login screen for why
  /// that is the honest thing to do in a demo with no network.
  Future<void> signInAsCitizen(String mobile) async {
    final session = CitizenSession(mobile: mobile, since: now());
    await _meta.setCitizenSession(session);
    await _meta.setOfficeSession(null);
    state = Session(citizen: session);
  }

  Future<void> signOut() async {
    await _meta.clearSessions();
    state = Session.none;
  }
}

final sessionProvider =
    NotifierProvider<SessionController, Session>(SessionController.new);

/// The shell for whoever is signed in. Everything the shell renders comes from
/// here, so no screen needs to know which role it is drawing for.
final shellConfigProvider = Provider<ShellConfig>(
  (ref) => shellConfigFor(ref.watch(sessionProvider).role),
);
