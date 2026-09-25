/// Payments and receipts.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums.dart';
import 'json.dart';
import 'shared.dart';

part 'money.freezed.dart';
part 'money.g.dart';

/// What a payment or receipt is against.
///
/// A sealed union rather than a loose `type` string: the three arms carry
/// genuinely different fields, and a receipt that cannot say what it is for is
/// useless as an audit record.
@freezed
sealed class PaymentTarget with _$PaymentTarget {
  const factory PaymentTarget.tradeLicence({required String id}) =
      TradeLicenceTarget;

  const factory PaymentTarget.registerEntry({
    required String id,
    required String registerKey,
  }) = RegisterEntryTarget;

  const factory PaymentTarget.holding({
    required String holdingNo,
    required String fiscalYear,
    required int instalment,
  }) = HoldingTarget;

  factory PaymentTarget.fromJson(Map<String, dynamic> json) =>
      _$PaymentTargetFromJson(json);
}

@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String id,
    required PaymentStatus status,
    required RevenueHead head,
    required Channel channel,
    required String purpose,
    required String payerName,
    required String payerMobile,
    @Default(<FeeLine>[]) List<FeeLine> feeLines,
    required int total,
    @LocalIsoConverter() required DateTime createdAt,
    @LocalIsoNullableConverter() DateTime? paidAt,

    /// Counter collections carry a mode; online payments a method and txn id.
    PaymentMode? mode,
    OnlineMethod? method,
    String? txnRef,
    String? receiptId,
    required PaymentTarget target,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}

@freezed
abstract class Receipt with _$Receipt {
  const factory Receipt({
    required String id,

    /// Sequential within the fiscal year, and gapless: a missing receipt number
    /// is what an auditor looks for first.
    required int no,
    required String receiptNo,

    /// Where this would sit in the paper receipt book.
    required int bookNo,
    required int pageNo,
    required String fiscalYear,
    required RevenueHead head,
    required Channel channel,
    required String paymentId,
    required String payerName,
    required String purpose,
    @Default(<FeeLine>[]) List<FeeLine> feeLines,
    required int total,
    PaymentMode? mode,
    OnlineMethod? method,
    String? txnRef,
    required String collectedBy,
    @LocalIsoConverter() required DateTime collectedAt,
    required PaymentTarget source,
  }) = _Receipt;

  factory Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);
}
