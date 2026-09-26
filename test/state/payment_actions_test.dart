import 'dart:io';
import 'dart:math';

import 'package:bogcc_demo_mobile_app/app/bootstrap.dart';
import 'package:bogcc_demo_mobile_app/catalogue/registers/registers.dart';
import 'package:bogcc_demo_mobile_app/data/seed/seed_data.dart';
import 'package:bogcc_demo_mobile_app/domain/enums.dart';
import 'package:bogcc_demo_mobile_app/domain/models/money.dart';
import 'package:bogcc_demo_mobile_app/state/actions/entry_actions.dart';
import 'package:bogcc_demo_mobile_app/state/actions/payment_actions.dart';
import 'package:bogcc_demo_mobile_app/state/demo_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  _FakePathProvider(this.root);
  final String root;
  @override
  Future<String?> getApplicationDocumentsPath() async => root;
  @override
  Future<String?> getApplicationSupportPath() async => root;
  @override
  Future<String?> getTemporaryPath() async => root;
}

/// Drives the notifier without a widget tree, which is all these actions need.
class _Harness extends DemoStore {
  _Harness(super.repos, super.sequences, super.initial);
  late DemoState _state = super.build();
  @override
  DemoState get state => _state;
  @override
  set state(DemoState value) => _state = value;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tmp;
  late AppServices services;
  late _Harness store;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('bogcc_payments');
    PathProviderPlatform.instance = _FakePathProvider(tmp.path);
    services = await bootstrap();
    store = _Harness(
      services.repositories,
      services.sequences,
      services.initialState,
    );
  });

  tearDown(() async {
    await Hive.close();
    if (tmp.existsSync()) await tmp.delete(recursive: true);
  });

  final config = getRegister('cert-citizen')!;

  /// A fresh citizenship-certificate application, which carries a ৳১০০ fee and
  /// whose second step is the one marked `payment`.
  Future<String> fileCertificate() async {
    final entry = await createCitizenEntry(
      store: store,
      config: config,
      data: <String, dynamic>{
        'name': 'রহিমা খাতুন',
        'fatherName': 'আব্দুল করিম',
        'motherName': 'সালেহা বেগম',
        'dob': '1990-03-14',
        'nid': '1994881234567',
        'address': 'সাতমাথা, সদর',
        'ward': 5,
        'mobile': demoCitizenMobile,
      },
      applicantMobile: demoCitizenMobile,
    );
    return entry.id;
  }

  /// Deterministic, so a txn id never makes a test flaky.
  Random fixedRandom() => Random(7);

  group('startPayment', () {
    test('opens a pending payment and creates no receipt yet', () async {
      final entryId = await fileCertificate();
      final receiptsBefore = store.state.receipts.length;

      final payment = await payForEntry(store: store, entryId: entryId);

      expect(payment, isNotNull);
      expect(payment!.status, PaymentStatus.pending);
      expect(payment.head, RevenueHead.certificate);
      expect(payment.total, 100, reason: 'the charter fixes this at ৳১০০');
      expect(payment.payerMobile, demoCitizenMobile);
      expect(store.state.receipts, hasLength(receiptsBefore));
    });

    test('it declines an entry that carries no fee', () async {
      // A streetlight complaint is free, so there is nothing to pay.
      final complaint = await createCitizenEntry(
        store: store,
        config: getRegister('streetlight')!,
        data: <String, dynamic>{
          'ward': 5,
          'road': 'সাতমাথা, সদর',
          'faultType': 'বাতি নষ্ট',
          'complainant': 'রহিমা খাতুন',
          'complainantMobile': demoCitizenMobile,
          'description': 'রাতে পুরো এলাকা অন্ধকার থাকে।',
        },
        applicantMobile: demoCitizenMobile,
      );

      expect(
        await payForEntry(store: store, entryId: complaint.id),
        isNull,
      );
    });
  });

  group('completePayment', () {
    test('it advances the entry to the step marked payment', () async {
      final entryId = await fileCertificate();
      expect(store.state.entry(entryId)!.status, 'received');

      final payment = await payForEntry(store: store, entryId: entryId);
      final receipt = await completePayment(
        store: store,
        paymentId: payment!.id,
        method: OnlineMethod.bkash,
        random: fixedRandom(),
      );

      expect(receipt, isNotNull);
      final entry = store.state.entry(entryId)!;
      expect(entry.status, 'paid');
      expect(
        config.stepOf(entry.status)!.payment,
        isTrue,
        reason: 'the landing step is the one the config marks, not the second',
      );
      expect(entry.receiptId, receipt!.id);
      expect(entry.paymentId, payment.id);
      expect(entry.history.last.status, 'paid');
      expect(entry.history.last.publicNote, isTrue);
    });

    test('it creates exactly one receipt, and marks the payment paid',
        () async {
      final entryId = await fileCertificate();
      final before = store.state.receipts.length;

      final payment = await payForEntry(store: store, entryId: entryId);
      final receipt = await completePayment(
        store: store,
        paymentId: payment!.id,
        method: OnlineMethod.nagad,
        random: fixedRandom(),
      );

      expect(store.state.receipts, hasLength(before + 1));
      expect(receipt!.total, 100);
      expect(receipt.channel, Channel.online);
      expect(receipt.method, OnlineMethod.nagad);
      expect(receipt.txnRef, startsWith('TXN'));
      expect(receipt.receiptNo, startsWith('MR/'));

      final settled = store.state.payment(payment.id)!;
      expect(settled.status, PaymentStatus.paid);
      expect(settled.paidAt, isNotNull);
      expect(settled.receiptId, receipt.id);
    });

    test('it adds exactly one payment notification for the payer', () async {
      final entryId = await fileCertificate();
      final before = store.state.notifications.length;

      final payment = await payForEntry(store: store, entryId: entryId);
      final receipt = await completePayment(
        store: store,
        paymentId: payment!.id,
        method: OnlineMethod.card,
        random: fixedRandom(),
      );

      // Two: the receipt confirmation, and the status change on the entry —
      // which is the citizen-facing register's own notification, not a second
      // receipt message.
      final added = store.state.notifications.length - before;
      expect(added, 2);

      final receiptSms = store.state.notifications
          .where((n) => n.text.contains(receipt!.receiptNo))
          .toList();
      expect(receiptSms, hasLength(1));
      expect(receiptSms.single.mobile, demoCitizenMobile);
      expect(receiptSms.single.text, contains('পরিশোধ সম্পন্ন'));
    });

    test('receipt numbers stay gapless across mixed revenue heads', () async {
      final firstEntry = await fileCertificate();
      final secondEntry = await fileCertificate();

      final holding = store.state.holdings.firstWhere(
        (h) => h.bills.any(
          (b) => b.instalments.any((i) => i.paidAt == null),
        ),
      );
      final bill =
          holding.bills.firstWhere((b) => b.instalments.any((i) => i.paidAt == null));
      final instalment = bill.instalments.firstWhere((i) => i.paidAt == null);

      final numbers = <int>[];
      for (final payment in <Payment?>[
        await payForEntry(store: store, entryId: firstEntry),
        await payHoldingInstalment(
          store: store,
          holdingNo: holding.holdingNo,
          fiscalYear: bill.fiscalYear,
          instalmentNo: instalment.no,
        ),
        await payForEntry(store: store, entryId: secondEntry),
      ]) {
        final receipt = await completePayment(
          store: store,
          paymentId: payment!.id,
          method: OnlineMethod.bkash,
          random: fixedRandom(),
        );
        numbers.add(receipt!.no);
      }

      // One book, one counter: the numbers run on regardless of the head.
      expect(numbers[1], numbers[0] + 1);
      expect(numbers[2], numbers[1] + 1);
    });

    test('the book and page follow the hundred-leaf paper book', () async {
      final entryId = await fileCertificate();
      final payment = await payForEntry(store: store, entryId: entryId);
      final receipt = await completePayment(
        store: store,
        paymentId: payment!.id,
        method: OnlineMethod.bkash,
        random: fixedRandom(),
      );

      expect(receipt!.bookNo, (receipt.no - 1) ~/ 100 + 1);
      expect(receipt.pageNo, (receipt.no - 1) % 100 + 1);
    });

    test('paying twice returns null and writes no second receipt', () async {
      final entryId = await fileCertificate();
      final payment = await payForEntry(store: store, entryId: entryId);
      final first = await completePayment(
        store: store,
        paymentId: payment!.id,
        method: OnlineMethod.bkash,
        random: fixedRandom(),
      );
      final after = store.state.receipts.length;

      final second = await completePayment(
        store: store,
        paymentId: payment.id,
        method: OnlineMethod.bkash,
        random: fixedRandom(),
      );

      expect(first, isNotNull);
      expect(second, isNull, reason: 'a refreshed gateway link must not charge again');
      expect(store.state.receipts, hasLength(after));
    });
  });

  group('failPayment', () {
    test('it leaves the record completely untouched', () async {
      final entryId = await fileCertificate();
      final entryBefore = store.state.entry(entryId)!;
      final receiptsBefore = store.state.receipts.length;
      final smsBefore = store.state.notifications.length;
      final auditBefore = store.state.audit.length;

      final payment = await payForEntry(store: store, entryId: entryId);
      await failPayment(store: store, paymentId: payment!.id);

      expect(store.state.payment(payment.id)!.status, PaymentStatus.failed);

      final entryAfter = store.state.entry(entryId)!;
      expect(entryAfter.status, entryBefore.status);
      expect(entryAfter.history, hasLength(entryBefore.history.length));
      expect(entryAfter.receiptId, isNull);
      expect(store.state.receipts, hasLength(receiptsBefore));
      expect(store.state.notifications, hasLength(smsBefore));
      expect(store.state.audit, hasLength(auditBefore));
    });

    test('a failed payment can still be retried and settled', () async {
      final entryId = await fileCertificate();
      final payment = await payForEntry(store: store, entryId: entryId);
      await failPayment(store: store, paymentId: payment!.id);

      final receipt = await completePayment(
        store: store,
        paymentId: payment.id,
        method: OnlineMethod.bkash,
        random: fixedRandom(),
      );

      expect(receipt, isNotNull);
      expect(store.state.entry(entryId)!.status, 'paid');
    });
  });

  group('holding tax', () {
    test('paying an instalment marks that one paid and drops the due',
        () async {
      final holding = store.state.holdings.firstWhere(
        (h) => h.bills.any((b) => b.instalments.any((i) => i.paidAt == null)),
      );
      final bill = holding.bills
          .firstWhere((b) => b.instalments.any((i) => i.paidAt == null));
      final instalment = bill.instalments.firstWhere((i) => i.paidAt == null);
      final dueBefore = bill.due;

      final payment = await payHoldingInstalment(
        store: store,
        holdingNo: holding.holdingNo,
        fiscalYear: bill.fiscalYear,
        instalmentNo: instalment.no,
      );
      final receipt = await completePayment(
        store: store,
        paymentId: payment!.id,
        method: OnlineMethod.bkash,
        random: fixedRandom(),
      );

      final after = store.state
          .holding(holding.holdingNo)!
          .billFor(bill.fiscalYear)!;
      final paidOne = after.instalments.firstWhere((i) => i.no == instalment.no);

      expect(paidOne.paidAt, isNotNull);
      expect(paidOne.receiptId, receipt!.id);
      expect(after.due, dueBefore - instalment.amount);
      expect(receipt.head, RevenueHead.holdingTax);
    });

    test('an instalment already paid is never charged twice', () async {
      final holding = store.state.holdings.firstWhere(
        (h) => h.bills.any((b) => b.instalments.any((i) => i.paidAt != null)),
      );
      final bill = holding.bills
          .firstWhere((b) => b.instalments.any((i) => i.paidAt != null));
      final paid = bill.instalments.firstWhere((i) => i.paidAt != null);

      expect(
        await payHoldingInstalment(
          store: store,
          holdingNo: holding.holdingNo,
          fiscalYear: bill.fiscalYear,
          instalmentNo: paid.no,
        ),
        isNull,
      );
    });
  });

  group('trade licence', () {
    test('paying an approved licence issues it', () async {
      final approved = store.state.licences
          .where((l) => l.licenceStatus == LicenceStatus.approved)
          .first;

      final payment = await payForLicence(store: store, licenceId: approved.id);
      final receipt = await completePayment(
        store: store,
        paymentId: payment!.id,
        method: OnlineMethod.bkash,
        random: fixedRandom(),
      );

      final after = store.state.licence(approved.id)!;
      expect(after.licenceStatus, LicenceStatus.issued);
      expect(after.closedAt, isNotNull);
      expect(after.receiptId, receipt!.id);
      expect(receipt.head, RevenueHead.tradeLicence);
    });

    test('a licence that is not yet approved cannot be paid for', () async {
      final submitted = store.state.licences
          .where((l) => l.licenceStatus == LicenceStatus.submitted)
          .first;

      expect(
        await payForLicence(store: store, licenceId: submitted.id),
        isNull,
      );
    });
  });

  group('counter collection', () {
    test('it settles through the same book as the gateway', () async {
      final entryId = await fileCertificate();
      final entry = store.state.entry(entryId)!;

      final receipt = await collectAtCounter(
        store: store,
        target: PaymentTarget.registerEntry(
          id: entryId,
          registerKey: entry.registerKey,
        ),
        head: RevenueHead.certificate,
        purpose: 'নাগরিকত্ব সনদ ফি — ${entry.applicantName}',
        payerName: entry.applicantName,
        payerMobile: entry.applicantMobile,
        feeLines: entry.feeLines!,
        mode: PaymentMode.cash,
      );

      expect(receipt, isNotNull);
      expect(receipt!.channel, Channel.office);
      expect(receipt.mode, PaymentMode.cash);
      expect(receipt.receiptNo, startsWith('MR/'));
      expect(store.state.entry(entryId)!.status, 'paid');
    });
  });

  test('a settled payment survives a restart, counter included', () async {
    final entryId = await fileCertificate();
    final payment = await payForEntry(store: store, entryId: entryId);
    final receipt = await completePayment(
      store: store,
      paymentId: payment!.id,
      method: OnlineMethod.bkash,
      random: fixedRandom(),
    );
    await Hive.close();

    final again = await bootstrap();
    expect(again.initialState.receipt(receipt!.id), isNotNull);
    expect(again.initialState.payment(payment.id)!.status, PaymentStatus.paid);
    expect(again.initialState.entry(entryId)!.status, 'paid');
    expect(
      again.sequences.peek('receipt-${receipt.fiscalYear}'),
      greaterThanOrEqualTo(receipt.no),
    );
  });
}
