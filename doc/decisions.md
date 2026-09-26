# Decisions, and why

The awkward parts of this codebase are mostly deliberate. Each entry says what
would go wrong if someone "tidied" it.

## The codegen versions are a chain, not preferences

Flutter 3.44.6 ships **Dart 3.12.2**. From that:

- `freezed` 4.x needs Dart ≥ 3.13 → pinned to `^3.2.5`
- freezed 3.x caps `analyzer` < 11 → caps `build_runner` < 2.15.2
- `riverpod_generator` needs `analyzer` ≥ 13 → **cannot coexist with freezed
  here at all**

So **providers are declared by hand**. That costs a few lines each and nothing
else. `flutter pub upgrade --major-versions` will break the resolution; raising
any one of the three means raising the Flutter SDK first.

## Do not use the `pdf` package for documents

It has no complex-script shaper. Bengali conjuncts (ক্ত, স্থ, র্ম) and pre-base
vowel reordering (ে, ি) render broken — the vowel draws after the consonant
instead of before it. Certificates, licences and receipts must be Flutter
widgets exported through `RepaintBoundary.toImage()` as PNG, which goes through
the real text engine.

This is the single most expensive trap in the project and it is easy to
rediscover late, after the document layout is already built.

## Fonts are bundled, not downloaded

`google_fonts` fetches at first paint, which forces the `INTERNET` permission
this app deliberately does without, and causes a font-swap flash. Hind Siliguri
and Tiro Bangla are both SIL OFL 1.1, so bundling is licence-clean provided
`assets/fonts/OFL.txt` ships — it does, and the about screen surfaces it.

## The app ships with no network permission

It holds all of its data on the device. A demo that provably cannot phone home
is worth more in front of an audience than any convenience.

`INTERNET` and `ACCESS_NETWORK_STATE` are **not declared** here — they arrive
through `mobile_scanner`'s ML Kit dependency, which drags in Google's
`transport-backend-cct` telemetry uploader. They are stripped at merge with
`tools:node="remove"`. QR scanning uses the on-device model and needs neither.

This regressed once, silently, when `mobile_scanner` was added. There is now
`test/app/manifest_test.dart`. Verify a build with:

```sh
aapt dump badging build/app/outputs/flutter-apk/app-release.apk | grep uses-permission
```

`flutter run` injects `INTERNET` into the *debug* manifest; that is expected and
does not affect release.

## Hive stores JSON maps, not TypeAdapters

No Hive codegen, no typeId registry to keep in step with the freezed models, and
schema evolution is just JSON tolerance. The cost: Hive hands back
`Map<dynamic, dynamic>` at every level, so every read goes through `asJsonMap`,
centralised in `JsonBoxStore`. Skipping that surfaces later as an opaque
`_TypeError` inside an unrelated screen.

## `SequenceService.next()` is synchronous on purpose

It contains no `await`, which is what makes read-increment-write atomic on
Dart's event loop without a lock. Making it async opens a window where two
callers read 6 and both write 7 — two records on one register line.

Persisting is a separate `flush()`. It was write-through at first; the
1000-serial test showed why that was wrong: a fire-and-forget box write per
serial leaves writes in flight when the box closes.

## The seed is a port in shape, not in stream

See `parity-with-web.md`. Reproducing 1,300 lines of draw order buys nothing
when the two demos do not share a store.

## `AppRole.citizen` exists, though the web has no such role

On the web a citizen simply has no role. Here one config keyed by role drives
the whole shell, so the citizen needs a seat in the same enum. This is the one
place the mobile domain is deliberately wider than the web's.

## The redirect rule is a pure function

`redirectFor(session:, location:)` rather than a closure inside the router. It
is what keeps each role inside its own shell, and driving a whole widget tree to
check it is slow and tells you less. The test covers every role against every
route, including that no redirect target itself redirects — which at runtime is
a frozen app rather than an error.

## Known gap: widget tests that drive the router

A widget test that boots the app and signs in **hangs** rather than failing,
somewhere in booting Hive through a faked `path_provider` per test. The logic
is covered by unit tests (`redirect_test.dart`, `entry_actions_test.dart`) and
the flow was verified by running the app on an emulator.

Worth solving before Phase 2 leans harder on widget tests. First thing to try:
boot once per file in `setUpAll` rather than per test, and bound `pumpAndSettle`
so a non-settling frame fails fast.

## Test-harness traps already paid for

- `flutter test` loads **neither** pubspec fonts **nor** MaterialIcons. Without
  `test/support/load_app_fonts.dart`, a Bangla golden silently records a row of
  tofu boxes and an icon golden records empty squares — as "expected".
- `json_serializable`'s `explicit_to_json` defaults **off**, which emits a
  nested model as the object rather than a map, so `toJson` output cannot be
  read back or written to Hive. Turned on globally in `build.yaml`.
- Piping `flutter test` into `grep` buffers everything; if the run is killed on
  a timeout you get no output at all. Write to a file and read the file.
