/// Money: starting a payment, settling it, and moving the record it was for.
///
/// Ported from the web demo's `src/store/useStore.ts` (the `/* money */`
/// section). The shape that matters here is that [_settle] is the **only**
/// place a [Receipt] is ever created — online through the mock gateway, or at
/// the counter when Phase 2 lands. That single door is what keeps the receipt
/// book gapless no matter which channel the money came through; two entry
/// points writing receipts would eventually disagree about the next number.
///
/// Every settlement does the same four things as any other mutation (see
/// `entry_actions.dart` and `doc/architecture.md`):
///   1. patch the record and append a [HistoryStep]
///   2. append an [AuditEntry] — the log is append-only
///   3. queue an [AppNotification] when the register is citizen-facing
///   4. persist, including the serial counters
library;

import 'dart:math';

import 'package:collection/collection.dart';

import 'package:uuid/uuid.dart';

import '../../catalogue/registers/registers.dart';
import '../../catalogue/services.dart';
import '../../catalogue/users.dart';
import '../../core/time/local_iso.dart';
import '../../data/seed/seed_builder.dart';
import '../../data/seed/seed_data.dart';
import '../../domain/enums.dart';
import '../../domain/models/audit_entry.dart';
import '../../domain/models/messaging.dart';
import '../../domain/models/money.dart';
import '../../domain/models/shared.dart';
import '../../domain/rules/fiscal.dart';
import '../../domain/rules/ids.dart';
import '../demo_store.dart';

const _uuid = Uuid();

int _feeTotalOf(List<FeeLine> lines) =>
    lines.fold(0, (sum, l) => sum + l.amount);

/// Opens a pending payment. No money has moved and no receipt exists yet.
///
/// Separating this from settlement is what lets the gateway be a real screen
/// with a link of its own: the payment is addressable before it is paid.
Future<Payment> startPayment({
  required DemoStore store,
  required PaymentTarget target,
  required RevenueHead head,
  required Channel channel,
  required String purpose,
  required String payerName,
  required String payerMobile,
  required List<FeeLine> feeLines,
}) async {
  final payment = Payment(
    id: _uuid.v4(),
    status: PaymentStatus.pending,
    head: head,
    channel: channel,
    purpose: purpose,
    payerName: payerName,
    payerMobile: payerMobile,
    feeLines: feeLines,
    total: _feeTotalOf(feeLines),
    createdAt: now(),
    target: target,
  );
  await store.putPayment(payment);
  return payment;
}

/// Settles a pending payment through the mock gateway.
///
/// Returns `null` when the payment is unknown or already paid, rather than
/// settling twice. That guard is what makes revisiting a gateway link safe:
/// the screen shows the receipt that already exists instead of writing a
/// second one against the same payment.
Future<Receipt?> completePayment({
  required DemoStore store,
  required String paymentId,
  required OnlineMethod method,
  Random? random,
}) async {
  final payment = store.current.payment(paymentId);
  if (payment == null || payment.status == PaymentStatus.paid) return null;

  final paid = payment.copyWith(
    status: PaymentStatus.paid,
    method: method,
    channel: Channel.online,
    txnRef: txnId((random ?? Random()).nextDouble),
  );
  await store.putPayment(paid);

  return _settle(
    store: store,
    payment: paid,
    collectedBy: 'অনলাইন পেমেন্ট গেটওয়ে (ডেমো)',
  );
}

/// Marks a payment failed and does **nothing else**.
///
/// No receipt, no history step, no notification, and the record the payment
/// was for is left exactly as it was. A failed payment that had moved the
/// application forward would be worse than no gateway at all.
Future<void> failPayment({
  required DemoStore store,
  required String paymentId,
}) async {
  final payment = store.current.payment(paymentId);
  if (payment == null) return;
  await store.putPayment(payment.copyWith(status: PaymentStatus.failed));
}

/// Collects a payment at the office counter.
///
/// Phase 2 uses this; it is here rather than in an office action file because
/// it must go through the same [_settle] as the gateway, and splitting the two
/// across files is how the receipt book stops being one book.
Future<Receipt?> collectAtCounter({
  required DemoStore store,
  required PaymentTarget target,
  required RevenueHead head,
  required String purpose,
  required String payerName,
  required String payerMobile,
  required List<FeeLine> feeLines,
  required PaymentMode mode,
  String? txnRef,
}) async {
  final payment = await startPayment(
    store: store,
    target: target,
    head: head,
    channel: Channel.office,
    purpose: purpose,
    payerName: payerName,
    payerMobile: payerMobile,
    feeLines: feeLines,
  );
  final withMode = payment.copyWith(mode: mode, txnRef: txnRef);
  await store.putPayment(withMode);

  return _settle(
    store: store,
    payment: withMode,
    collectedBy: userFor(AppRole.accounts).name,
  );
}

/* ---------------- the single door ---------------- */

/// Creates the receipt and moves the record the money was for.
///
/// The receipt number comes from the fiscal year's counter at the moment the
/// money is taken, which is when the paper book would get its next leaf — the
/// same rule register serials follow.
Future<Receipt> _settle({
  required DemoStore store,
  required Payment payment,
  required String collectedBy,
}) async {
  final collectedAt = now();
  final fy = fiscalYearOf(collectedAt);
  final no = store.sequences.next(SeqKeys.receipt(fy));
  final book = receiptBookRef(no);

  final receipt = Receipt(
    id: _uuid.v4(),
    no: no,
    receiptNo: receiptNo(fy, no),
    bookNo: book.bookNo,
    pageNo: book.pageNo,
    fiscalYear: fy,
    head: payment.head,
    channel: payment.channel,
    paymentId: payment.id,
    payerName: payment.payerName,
    purpose: payment.purpose,
    feeLines: payment.feeLines,
    total: payment.total,
    mode: payment.mode,
    method: payment.method,
    txnRef: payment.txnRef,
    collectedBy: collectedBy,
    collectedAt: collectedAt,
    source: payment.target,
  );

  await store.putReceipt(receipt);
  await store.putPayment(
    payment.copyWith(
      status: PaymentStatus.paid,
      paidAt: collectedAt,
      receiptId: receipt.id,
    ),
  );

  await _applyPaidTarget(store: store, payment: payment, receipt: receipt);

  await store.appendAudit(
    AuditEntry(
      id: _uuid.v4(),
      at: collectedAt,
      userName: collectedBy,
      role: payment.head == RevenueHead.holdingTax
          ? AppRole.revenueOfficer
          : AppRole.accounts,
      action: 'ফি আদায়',
      recordType: AuditRecordType.receipt,
      recordKey: payment.head.name,
      recordId: receipt.id,
      recordLabel: '${receipt.receiptNo} — ${payment.payerName}',
      note: '${payment.channel == Channel.online ? 'অনলাইনে' : '${payment.mode?.label ?? 'নগদ'} মাধ্যমে'} '
          '${payment.total} টাকা আদায়; বই নং ${book.bookNo}, পাতা ${book.pageNo}।',
    ),
  );

  await store.putNotification(
    AppNotification(
      id: _uuid.v4(),
      mobile: payment.payerMobile,
      text: 'রসিদ ${receipt.receiptNo}: ${payment.total} টাকা পরিশোধ সম্পন্ন। '
          'ধন্যবাদ, বগুড়া সিটি কর্পোরেশন।',
      at: collectedAt,
    ),
  );

  // Only now, once the receipt that used the number is safely written.
  await store.flushSequences();

  return receipt;
}

/// Moves the record the payment was for into its next state.
Future<void> _applyPaidTarget({
  required DemoStore store,
  required Payment payment,
  required Receipt receipt,
}) async {
  switch (payment.target) {
    case TradeLicenceTarget(:final id):
      final licence = store.current.licence(id);
      if (licence == null) return;
      final byName = payment.channel == Channel.online
          ? '${payment.payerName} (অনলাইন)'
          : userFor(AppRole.accounts).name;
      await store.putLicence(
        licence.copyWith(
          licenceStatus: LicenceStatus.issued,
          closedAt: receipt.collectedAt,
          paymentId: payment.id,
          receiptId: receipt.id,
          history: [
            ...licence.history,
            HistoryStep(
              status: LicenceStatus.issued.name,
              at: receipt.collectedAt,
              byName: byName,
              byRole: AppRole.accounts,
              note: payment.channel == Channel.online
                  ? 'নাগরিক অনলাইনে ফি পরিশোধ করেছেন।'
                  : 'কাউন্টারে ফি আদায় করা হয়েছে।',
              publicNote: true,
            ),
          ],
        ),
      );
      await store.putNotification(
        AppNotification(
          id: _uuid.v4(),
          mobile: licence.applicantMobile,
          text: '${licence.trackingNo}: '
              '${citizenLabel(licence.serviceKey, LicenceStatus.issued.name)}',
          at: receipt.collectedAt,
          trackingNo: licence.trackingNo,
        ),
      );

    case RegisterEntryTarget(:final id):
      final entry = store.current.entry(id);
      final config = entry == null ? null : getRegister(entry.registerKey);
      if (entry == null || config == null) return;
      // The step a payment lands on is declared by the config, not assumed to
      // be second: `cert-warish` pays before verification, `cert-citizen`
      // before approval.
      final payStep = config.steps.where((s) => s.payment).firstOrNull;
      if (payStep == null) return;

      final byName = payment.channel == Channel.online
          ? '${payment.payerName} (অনলাইন)'
          : userFor(AppRole.accounts).name;
      await store.putEntry(
        entry.copyWith(
          status: payStep.key,
          paymentId: payment.id,
          receiptId: receipt.id,
          history: [
            ...entry.history,
            HistoryStep(
              status: payStep.key,
              at: receipt.collectedAt,
              byName: byName,
              byRole: AppRole.accounts,
              note: payment.channel == Channel.online
                  ? 'নাগরিক অনলাইনে ফি পরিশোধ করেছেন।'
                  : 'কাউন্টারে ফি আদায় করা হয়েছে।',
              publicNote: true,
            ),
          ],
        ),
      );

      if (config.citizenFacing) {
        await store.putNotification(
          AppNotification(
            id: _uuid.v4(),
            mobile: entry.applicantMobile,
            text: '${entry.trackingNo}: ${payStep.citizenLabel}',
            at: receipt.collectedAt,
            trackingNo: entry.trackingNo,
          ),
        );
      }

      await store.appendAudit(
        AuditEntry(
          id: _uuid.v4(),
          at: receipt.collectedAt,
          userName: byName,
          role: AppRole.accounts,
          action: payStep.label,
          recordType: AuditRecordType.registerEntry,
          recordKey: config.key,
          recordId: entry.id,
          recordLabel: '${entryLabelOf(entry)} (${entry.serialNo})',
          note: 'ফি পরিশোধিত, রসিদ ${receipt.receiptNo}',
        ),
      );

    case HoldingTarget(:final holdingNo, :final fiscalYear, :final instalment):
      final holding = store.current.holding(holdingNo);
      final bill = holding?.billFor(fiscalYear);
      if (holding == null || bill == null) return;

      await store.putHolding(
        holding.copyWith(
          bills: [
            for (final b in holding.bills)
              if (b.fiscalYear != fiscalYear)
                b
              else
                b.copyWith(
                  instalments: [
                    for (final i in b.instalments)
                      if (i.no != instalment)
                        i
                      else
                        i.copyWith(
                          paidAt: receipt.collectedAt,
                          receiptId: receipt.id,
                        ),
                  ],
                ),
          ],
        ),
      );
  }
}

/* ---------------- entry points ---------------- */

/// Starts payment of a register entry's certificate fee.
Future<Payment?> payForEntry({
  required DemoStore store,
  required String entryId,
  Channel channel = Channel.online,
}) async {
  final entry = store.current.entry(entryId);
  final config = entry == null ? null : getRegister(entry.registerKey);
  final feeLines = entry?.feeLines;
  if (entry == null || config == null || feeLines == null || feeLines.isEmpty) {
    return null;
  }
  return startPayment(
    store: store,
    target: PaymentTarget.registerEntry(
      id: entryId,
      registerKey: entry.registerKey,
    ),
    head: RevenueHead.certificate,
    channel: channel,
    purpose: '${config.title.replaceAll(' রেজিস্টার', '')} ফি '
        '— ${entry.applicantName}',
    payerName: entry.applicantName,
    payerMobile: entry.applicantMobile,
    feeLines: feeLines,
  );
}

/// Starts payment of an approved trade licence's fee.
Future<Payment?> payForLicence({
  required DemoStore store,
  required String licenceId,
  Channel channel = Channel.online,
}) async {
  final licence = store.current.licence(licenceId);
  if (licence == null || licence.licenceStatus != LicenceStatus.approved) {
    return null;
  }
  return startPayment(
    store: store,
    target: PaymentTarget.tradeLicence(id: licenceId),
    head: RevenueHead.tradeLicence,
    channel: channel,
    purpose: '${licence.isRenewal ? 'ট্রেড লাইসেন্স নবায়ন ফি' : 'ট্রেড লাইসেন্স ফি'} '
        '— ${licence.business.nameBn}',
    payerName: licence.owner.name,
    payerMobile: licence.applicantMobile,
    feeLines: licence.feeLines,
  );
}

/// Starts payment of one quarterly holding-tax instalment.
Future<Payment?> payHoldingInstalment({
  required DemoStore store,
  required String holdingNo,
  required String fiscalYear,
  required int instalmentNo,
  Channel channel = Channel.online,
}) async {
  final holding = store.current.holding(holdingNo);
  final bill = holding?.billFor(fiscalYear);
  final inst = bill?.instalments.where((i) => i.no == instalmentNo).firstOrNull;
  // An instalment already paid is not an error worth a message — the screen
  // simply will not offer the button — but it must never be charged twice.
  if (holding == null || bill == null || inst == null || inst.paidAt != null) {
    return null;
  }
  return startPayment(
    store: store,
    target: PaymentTarget.holding(
      holdingNo: holdingNo,
      fiscalYear: fiscalYear,
      instalment: instalmentNo,
    ),
    head: RevenueHead.holdingTax,
    channel: channel,
    purpose: 'হোল্ডিং কর — \$holdingNo, \$instalmentNoম কিস্তি (\$fiscalYear)',
    payerName: holding.ownerName,
    payerMobile: holding.ownerMobile,
    feeLines: [
      FeeLine(label: '\$instalmentNoম কিস্তি', amount: inst.amount),
    ],
  );
}
