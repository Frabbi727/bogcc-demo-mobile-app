# How the mobile app is put together

Written after building Phase 1. Read this before changing anything structural;
`decisions.md` explains *why* the awkward parts are the way they are, and
`parity-with-web.md` covers what must stay in step with the web demo.

## The one idea

**Every user — citizen or any of the ten office desks — logs in and lands in a
shell built from their own role config.** Nothing in the shell, the home screen
or the navigation bar knows which role it is drawing for.

```
Session (role) → ShellConfig → tabs, home tiles, title, badges
```

That is why adding an office desk in Phase 2 is an entry in `kShellConfigs`
rather than a new screen, and why `AppShell` and the home screen are each a
single widget serving eleven different-looking apps.

## Layers

```
lib/
  app/        MaterialApp, GoRouter, bootstrap, route constants
  core/       Bangla numerals/dates/words, seeded RNG, local-ISO time
  domain/     models (freezed) + rules (SLA, fiscal year, ids, fees, status)
  catalogue/  static config: services, wards, users, 9 register configs
  data/       deterministic seed builder, Hive stores, repositories
  state/      the one DemoStore notifier, its actions and selectors
  shell/      ShellConfig → nav + home tiles, driven by role
  ui/         theme tokens and shared widgets
  engine/     config-driven form: field registry, validators, screens
  features/   auth, citizen/*, verify, office (Phase 2)
```

`test/` mirrors `lib/` one-to-one.

Dependencies point downward only: `features` may use anything; `domain` and
`core` use nothing above them. `catalogue` is pure data and depends only on
`domain/enums.dart`.

## The register engine

Nine of the eleven modules are a `RegisterConfig` read by generic screens, so
**adding a register is a config file, not a screen**:

- `catalogue/registers/*.dart` — one file per register, hand-written `const`
- `engine/field_registry.dart` — `FieldType` → widget builder
- `engine/form_state.dart` — values, errors, per-type validation

A register's `citizenInput` fields become the online application form with no
screen work. Trade licence is the one bespoke module, because of its fee lines,
renewal and printed form.

**`canAdvance` gates on the *next* step's actors, not the current step's.** That
is the classic way to get this engine backwards; there is a test naming the
electrician and the operator specifically.

## State and persistence

One store, loaded once at boot:

```
bootstrap() → opens Hive → seeds if version mismatch → DemoState in memory
```

The whole dataset is a few hundred records, so reads never touch Hive after
boot and **every selector is synchronous**. Writes update state *and* write
through to their box.

Records are stored as plain JSON maps, not Hive `TypeAdapter`s — no Hive
codegen, no typeId registry to keep in step with freezed. The cost is that
every read must go through `asJsonMap`, which is centralised in `JsonBoxStore`.

## The four-part invariant

Every mutation does the same four things. This is what the system rests on:

1. patch the record and append a `HistoryStep`
2. append an `AuditEntry` — the log is append-only
3. queue an `AppNotification` when the register is citizen-facing
4. persist, including the serial counters

See `state/actions/entry_actions.dart`. **Nothing is ever deleted**; cancelling
is its own action that keeps the record visible with its reason.

## Rules that are load-bearing

- **All displayed digits are Bangla numerals.** Values are *stored* as ASCII;
  `core/bn` converts on the way out and an input formatter converts on the way
  in, because Android keyboards disagree about which digits they emit.
- **Timestamps are local ISO without `Z`.** Nothing calls `.toUtc()`. A record
  filed at 11pm must not land on the next day's register line.
- **Register serials are gapless** per register per fiscal year, assigned at the
  moment the paper book would get its next line — on creation for an engine
  register, at approval for a trade licence.
- **Receipt numbers run in collection order** across every revenue head, the way
  one book at one counter does.

## Routing

Two shell routes, `/nagorik` and `/office`, wrapped by the same `AppShell`:
go_router needs branches declared statically while the tabs come from the role
config. Public routes (`/verify`, `/document`, `/receipt`) sit outside both, so
a scanned QR opens without a session — the person checking a certificate is
usually not the person it belongs to.

The redirect rule is a pure function, `redirectFor(session:, location:)`, so it
can be tested directly rather than by driving a widget tree.
