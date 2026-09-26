# What is left

State as of the end of Phase 1's second pass (branch `main`, 265 tests green,
release APK builds and runs).

## Built and verified

Sign-in for both faces, the role-aware shell for all eleven roles, the citizen
charter, the config-driven application form, tracking with step-by-step
progress, the simulated SMS inbox, notices, about, and ডেমো রিসেট. The whole
citizen loop was driven on an emulator: apply → tracking number → appears in the
track list → message badge increments.

The entire domain layer is ported and tested: Bangla formatting, SLA, fiscal
year, identifiers, the seeded RNG, all nine register configs, the models, the
seed (45 licences, 233 register lines, 60 holdings), persistence.

Since then, in the order the list below used to have them: the **mock payment
gateway** with its receipts, the **certificate** as an A4 widget exported to
PNG, and **QR verification** — all three built and tested.

## Phase 1 leftovers, in the order they unblock each other

**1. Holding tax** (`/nagorik/holding`) — currently a labelled placeholder.
Search by holding number, show dues / arrears / instalments, pay one instalment.
The data and the `HoldingBill.due` logic already exist and are tested; this is
screens plus the payment actions, which are now built.

**2. Star rating** — offered only when a record is closed and not yet rated.
`Feedback` is already on the model and seeded.

**3. Track by tracking number** for someone not signed in as that citizen.
`findByTracking` already requires tracking number **and** mobile — that privacy
rule is deliberate and tested; keep it.

**4. Photo capture** — `_PhotoField` in `engine/field_registry.dart` is
currently an explaining placeholder. `PhotoStore` and `PhotoRef` are built and
tested; what is missing is wiring `image_picker` at 800px / quality 70 and the
3-per-record cap.

## Phase 2 — the office side

The shape is already settled: every one of the ten desks has a `ShellConfig`
with tabs and a `WorkQueueSpec` naming which registers and statuses it acts on,
and logging in as any of them already produces that desk's own shell. What is
missing is the screens behind the tabs:

- **My Work** — render each `WorkQueueSpec` as an inbox. The specs are already
  tested to only queue work the role can actually action.
- **`RegisterDetailScreen` in `staff` mode** — the citizen mode exists; staff
  mode uses `step.label` rather than `citizenLabel`, shows every note and
  staff-only field, and offers the advance action gated by `canAdvance`.
- **Register book** — the ruled ledger using `bookColumns`, FY/ward/status
  filters, `totals` in the footer, cancelled rows struck through.
- **Counter collection, receipts, search, the Mayor dashboard.**

The Mayor dashboard is the largest single piece; the web's `src/lib/mayor.ts` is
554 lines of aggregation and is deliberately not ported yet.

## Housekeeping

- Make widget tests trustworthy across navigation boundaries before Phase 2
  relies on them — see the "Known gap" entry in `decisions.md` for what was
  actually observed and the three things to try.
- The release APK is 72.8 MB, mostly ML Kit from `mobile_scanner`. Now that
  `/verify/scan` uses it, dropping the package means dropping camera scanning
  and falling back to typing the number — which the screen already supports and
  which is the only path on a device that refuses the camera permission. It
  would also remove the telemetry dependency the manifest currently strips.

- **The licence document is not built.** Verification handles licences from the
  device's own records, but there is no printable licence sheet yet, so no
  licence QR exists to scan. `CertificateSheet` is the template to follow, and
  its `verifyUrl` already omits `t=cert` for the licence case.
- `ios/` does not exist. `flutter create --platforms=ios .` when wanted.
