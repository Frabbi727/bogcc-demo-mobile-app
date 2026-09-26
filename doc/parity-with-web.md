# Keeping the mobile app and the web demo in step

The mobile app is a port of the React demo at
`../tonmoy/bogura-city-corporation`. They do **not** share a store or a server —
each holds its own data — but they must agree on everything a person can see,
or the two demos tell different stories about the same corporation.

Spec: `doc/upgrade-doc.md` in the web repo ("Build Spec v2") is authoritative.
`doc/promt.md` is the superseded v1.

## The port map

| Web file | Dart file | Must stay identical |
|---|---|---|
| `src/lib/bn.ts` | `lib/core/bn/*` | Yes — every digit, date, amount on screen |
| `src/lib/sla.ts` | `lib/domain/rules/sla.dart` | Yes — what a citizen is promised |
| `src/lib/fiscal.ts` | `lib/domain/rules/fiscal.dart` | Yes |
| `src/lib/ids.ts` | `lib/domain/rules/ids.dart` | Yes — numbers printed on documents |
| `src/lib/status.ts` | `lib/domain/rules/status.dart` | Yes |
| `src/lib/random.ts` | `lib/core/random/*` | Yes — frozen against the JS stream |
| `src/data/services.ts` | `lib/catalogue/services.dart` | Yes — the charter |
| `src/data/businessTypes.ts` | `lib/catalogue/business_types.dart` | Yes — fees |
| `src/data/wards.ts` | `lib/catalogue/wards.dart` | Yes |
| `src/data/users.ts` | `lib/catalogue/users.dart` | Yes |
| `src/data/names.ts` | `lib/catalogue/names.dart` | Generated — see below |
| `src/registers/*.ts` | `lib/catalogue/registers/*.dart` | Yes — the engine |
| `src/types.ts` | `lib/domain/models/*` | Shape yes, exact fields yes |
| `src/data/seed.ts` | `lib/data/seed/*` | **Shape and volume only** — see below |
| `src/index.css` `@theme` | `lib/ui/theme/colors.dart` | Yes — token names too |

## What is deliberately *not* identical

**The seed's random stream.** `lib/data/seed/seed_builder.dart` reproduces the
counts, the status spread, gapless serials, receipts numbered in collection
order, the overdue budget and the demo citizen's four requests — but not the
exact draw order of 1,300 lines of TypeScript. The two demos do not share a
store, so byte-identical data buys nothing and would break at the first
divergence. **If you change seed volumes on one side, change them on the other**
(`test/data/seed/seed_test.dart` asserts them).

**`names.dart` is generated, not typed.** It was produced from `names.ts` by a
script so no Bangla string is mistranscribed. If the web's names change,
regenerate rather than hand-edit — see `tool/` in the web repo.

## Re-checking parity

The web repo has `tool/parity/` — small scripts that run the *TypeScript* and
print values to compare against the Dart tests. The expected values in these
Dart tests came from running those scripts, and a comment in each test says so:

- `test/core/bn/bn_test.dart`
- `test/domain/rules/rules_test.dart`
- `test/core/random/seeded_rng_test.dart`

If one of those fails after a change to the web app, the port has drifted and
the two demos will disagree on screen. **Do not "fix" the expected value by
hand** — run the parity script and see which side is wrong.

```sh
cd ../tonmoy/bogura-city-corporation
npx tsx tool/parity/bn.mts        # Bangla formatting
npx tsx tool/parity/rules.mts     # SLA, fiscal year, identifiers
npx tsx tool/parity/random.mts    # the seeded RNG stream
```

## Cross-checks already in place

Two tests check the two ports against *each other* rather than against a
literal, which is the strongest evidence available that both are right:

- `test/catalogue/registers_test.dart` asserts every register's step
  `citizenLabel` equals the service catalogue's `citizenLabels` entry for that
  status. Those were ported from different files; if they drift, an applicant is
  told two different stories about one application.
- The same file checks every certificate `{{placeholder}}` resolves to a real
  field — a typo would print literally on a signed certificate.

## When you change the web app

| If you change… | Also do this |
|---|---|
| A service's charter days, fee or citizen labels | Update `services.dart`; run the register/service agreement test |
| A register's steps, fields or actors | Update the matching `catalogue/registers/*.dart` |
| A Bangla formatter | Run the parity script, update the frozen values in the Dart test |
| A colour token | Update `ui/theme/colors.dart`, keep the token name |
| Seed volumes | Update `seed_builder.dart` and the counts in `seed_test.dart` |
| `src/types.ts` | Update `domain/models/*`, rerun `build_runner` |

## When you change the mobile app

The web app is the older and more complete of the two on the office side. If you
add something to mobile that belongs in both — a validation rule, a status
label, a fee line — put it in the web app too, or the next person porting will
find them disagreeing and not know which is intended.
