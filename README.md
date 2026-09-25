# বগুড়া সিটি কর্পোরেশন — ডেমো মোবাইল অ্যাপ

A Bangla-only Android demo of the Bogura City Corporation digital service system, and the mobile
companion to the React demo in `bogura-city-corporation`.

Every user logs in and lands in a shell built from their own role config, so a citizen and each of
the ten office desks see only their own work. **Phase 1 builds the নাগরিক (citizen) side**; the
office roles are Phase 2 and slot in as configuration rather than a rewrite.

## This is a demo

No real money, no real SMS, no real OTP, no real citizen data. Everything is generated on the
device from a deterministic seed and can be wiped with **ডেমো রিসেট**.

**The app ships without `android.permission.INTERNET`.** It holds all of its data locally and is
provably unable to phone home — which is also why runtime font downloading (`google_fonts`) and
any analytics SDK are permanently off the table. `flutter run` injects INTERNET into the *debug*
manifest only; the release manifest must stay without it. The only permission is `CAMERA`, for
photographing a complaint and scanning a certificate QR.

## Toolchain

Flutter 3.44.6 / Dart 3.12.2.

⚠️ **`freezed` is pinned to `^3.2.5`.** Version 4.x requires Dart `>=3.13.0`. Do not run
`flutter pub upgrade --major-versions`.

⚠️ **Do not use the `pdf` package** for certificates, licences or receipts. It has no
complex-script shaper, so Bengali conjuncts (ক্ত, স্থ, র্ম) and pre-base vowel reordering (ে, ি)
render broken. Documents are Flutter widgets exported through `RepaintBoundary.toImage()` as PNG.

## Layout

```
lib/
  app/        MaterialApp, GoRouter, bootstrap
  core/       Bangla numerals/dates/words, seeded RNG, local-ISO time
  domain/     models (freezed) + rules (SLA, fiscal year, ids, fees, status)
  catalogue/  static config: services, wards, users, and the 9 register configs
  data/       deterministic seed builder, Hive stores, repositories
  state/      the one DemoStore notifier, its actions and selectors
  shell/      ShellConfig -> nav + home tiles, driven by role
  ui/         theme tokens and shared widgets
  engine/     config-driven register form / detail / book screens
  features/   auth, citizen/*, verify, office (Phase 2)
```

`test/` mirrors `lib/` one-to-one.

## Develop

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run
```

## Conventions

- **All displayed digits are Bangla numerals (০-৯).** Values are *stored* as ASCII; `BnText` and
  the `core/bn` formatters convert on the way out, and an input formatter converts on the way in.
- **Timestamps are local ISO without `Z`.** Never call `.toUtc()` — use `core/time/local_iso.dart`.
- **Nothing is ever deleted.** Records are cancelled (বাতিল) with a mandatory reason and stay
  visible, struck through and stamped.
- **Every mutation appends to the audit log.** `AuditRepository` has no update or delete method.
- **Register serials are gapless** per register per fiscal year.
