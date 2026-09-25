/// Seeded pseudo-random numbers, ported from the web demo's `src/lib/random.ts`.
///
/// The seed data is generated relative to "today" so the dashboards always look
/// alive, but it must still come out identical on every device and every launch
/// on the same day. A seeded PRNG gives both: fresh dates, fixed choices.
///
/// **Why this file is fussy about bit widths.** The original is JavaScript,
/// where `Math.imul`, `^`, `|` and `>>>` all coerce to 32 bits. Dart integers
/// are 64-bit, so every step here masks back to 32 bits explicitly. Getting that
/// subtly wrong still produces a perfectly deterministic stream — just a
/// *different* one from the web app's — which is why the golden test freezes the
/// first outputs rather than merely checking that two runs agree.
library;

const _mask32 = 0xFFFFFFFF;

/// 32-bit multiply, the equivalent of JavaScript's `Math.imul`.
///
/// Dart's 64-bit multiplication overflows for operands this size, but overflow
/// wraps modulo 2^64 and therefore preserves the low 32 bits, which is all the
/// result depends on.
int _imul(int a, int b) => (a * b) & _mask32;

/// mulberry32 — small, fast, good enough for demo data.
///
/// Returns a function producing floats in [0, 1).
double Function() makeRng(int seed) {
  var a = seed & _mask32;
  return () {
    a = (a + 0x6D2B79F5) & _mask32;
    var t = a;
    t = _imul(t ^ (t >>> 15), t | 1);
    t = (t ^ (t + _imul(t ^ (t >>> 7), t | 61))) & _mask32;
    return ((t ^ (t >>> 14)) & _mask32) / 4294967296.0;
  };
}

/// A stable numeric seed from a string, so `buildSeed('2026-09-25')` repeats.
/// FNV-1a over UTF-16 code units, matching `charCodeAt` in the original.
int seedFrom(String s) {
  var h = 2166136261;
  for (final unit in s.codeUnits) {
    h = (h ^ unit) & _mask32;
    h = _imul(h, 16777619);
  }
  return h & _mask32;
}
