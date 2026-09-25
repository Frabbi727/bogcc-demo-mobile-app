/// Number and identifier formats.
///
/// Every number a citizen or an officer reads aloud is built here, so the shapes
/// stay consistent across the seed, the store and the printed documents.
///
/// All of these stay in **Latin digits**. A citizen types a tracking number back
/// into the track form, and an officer reads a licence number off a printed
/// page; converting them to Bangla numerals for display is the caller's job.
library;

String _pad(int n, int width) => n.toString().padLeft(width, '0');

/// Leaves per paper receipt book.
const receiptBookLeaves = 100;

/// Citizen-facing tracking number, e.g. `BOGCC-2026-000123`.
String trackingNo(int year, int n) => 'BOGCC-$year-${_pad(n, 6)}';

/// Trade licence number, e.g. `BOGCC/TL/2026-27/00013`.
String licenceNo(String fy, int serial) => 'BOGCC/TL/$fy/${_pad(serial, 5)}';

/// Application number for a walk-in or online application.
String applicationNo(String fy, int n) => 'BOGCC/APP/$fy/${_pad(n, 4)}';

/// Generic register serial, e.g. `SL/2026-27/007`.
String registerSerialNo(String prefix, String fy, int serial) =>
    '$prefix/$fy/${_pad(serial, 3)}';

/// Certificate number, e.g. `BOGCC/CERT/2026-27/0042`.
String certificateNo(String fy, int serial) =>
    'BOGCC/CERT/$fy/${_pad(serial, 4)}';

/// Money receipt number, e.g. `MR/2026-27/0104`.
String receiptNo(String fy, int n) => 'MR/$fy/${_pad(n, 4)}';

/// Holding number, e.g. `W05-0123`.
String holdingNo(int ward, int n) => 'W${_pad(ward, 2)}-${_pad(n, 4)}';

/// Where a receipt number sits in the paper receipt book.
/// Receipt 1 is book 1 leaf 1; receipt 101 is book 2 leaf 1.
({int bookNo, int pageNo}) receiptBookRef(int n) => (
      bookNo: (n - 1) ~/ receiptBookLeaves + 1,
      pageNo: (n - 1) % receiptBookLeaves + 1,
    );

/// Mock gateway transaction id, e.g. `TXN8F3K2QD1`.
///
/// The alphabet omits I, O and 1/0 lookalikes so a transaction id read over the
/// phone is not ambiguous.
String txnId(double Function() rand) {
  const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ0123456789';
  final out = StringBuffer('TXN');
  for (var i = 0; i < 8; i++) {
    out.write(alphabet[(rand() * alphabet.length).floor()]);
  }
  return out.toString();
}
