/// Route paths and names, in one place so a nav destination and a router branch
/// cannot disagree about where a tab goes.
library;

abstract final class Routes {
  /// Decides where to send someone based on their session.
  static const root = '/';

  // --- public: reachable with no session, so a scanned QR just opens ---
  static const login = '/login';
  static const otp = '/login/otp';
  static const verify = '/verify';
  static const scan = '/verify/scan';
  static const document = '/document'; // /document/:kind/:id
  static const receipt = '/receipt'; // /receipt/:id

  /// The mock gateway. Public because a payment link is a document of its
  /// own: it is opened from an SMS as often as from inside the app.
  static const pay = '/pay'; // /pay/:paymentId

  // --- citizen shell branches ---
  static const citizenHome = '/nagorik';
  static const services = '/nagorik/services';
  static const track = '/nagorik/track';
  static const messages = '/nagorik/messages';
  static const profile = '/nagorik/me';

  // --- citizen leaves ---
  static const serviceDetail = '/nagorik/services/:key';
  static const apply = '/nagorik/services/:key/apply';
  static const requestDetail = '/nagorik/track/:id';
  static const holding = '/nagorik/holding';
  static const notices = '/nagorik/notices';
  static const about = '/nagorik/me/about';

  // --- office shell (Phase 2) ---
  static const officeHome = '/office';
  static const officeWork = '/office/work';
  static const officeRegisters = '/office/registers';
  static const officeSearch = '/office/search';
  static const officeProfile = '/office/me';

  static String serviceDetailFor(String key) => '/nagorik/services/$key';
  static String applyFor(String key) => '/nagorik/services/$key/apply';
  static String requestDetailFor(String id) => '/nagorik/track/$id';
  static String documentFor(String kind, String id) => '/document/$kind/$id';
  static String receiptFor(String id) => '/receipt/$id';
  static String payFor(String paymentId) => '/pay/$paymentId';
}
