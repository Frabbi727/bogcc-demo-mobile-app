/// Spacing and radii. The radii are the web's `--radius-sm` and `--radius-md`:
/// deliberately tight, because the UI is meant to read as a ruled ledger rather
/// than a consumer app.
abstract final class Insets {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

abstract final class Radii {
  static const sm = 3.0;
  static const md = 5.0;
}
