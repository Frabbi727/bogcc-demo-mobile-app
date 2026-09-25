/// Holding tax — the annual property demand and what has been paid against it.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums.dart';
import 'json.dart';
import 'shared.dart';

part 'holding.freezed.dart';
part 'holding.g.dart';

@freezed
abstract class HoldingInstalment with _$HoldingInstalment {
  const factory HoldingInstalment({
    /// Quarter, 1-4.
    required int no,
    required int amount,
    @LocalIsoNullableConverter() DateTime? paidAt,
    String? receiptId,
  }) = _HoldingInstalment;

  factory HoldingInstalment.fromJson(Map<String, dynamic> json) =>
      _$HoldingInstalmentFromJson(json);
}

@freezed
abstract class HoldingBill with _$HoldingBill {
  const factory HoldingBill({
    required String fiscalYear,
    @Default(<FeeLine>[]) List<FeeLine> lines,

    /// Current year demand, before arrears.
    required int total,
    @Default(<HoldingInstalment>[]) List<HoldingInstalment> instalments,

    /// Unpaid amount carried over from earlier years.
    @Default(0) int arrears,

    /// Demo surcharge on arrears.
    @Default(0) int surcharge,
  }) = _HoldingBill;

  const HoldingBill._();

  factory HoldingBill.fromJson(Map<String, dynamic> json) =>
      _$HoldingBillFromJson(json);

  int get paid => instalments
      .where((i) => i.paidAt != null)
      .fold(0, (sum, i) => sum + i.amount);

  /// What the citizen still owes: this year's unpaid instalments plus whatever
  /// was carried over, plus the surcharge on it.
  int get due => total - paid + arrears + surcharge;

  bool get isSettled => due <= 0;
}

@freezed
abstract class Holding with _$Holding {
  const factory Holding({
    required String holdingNo,
    required int ward,
    required String ownerName,
    required String ownerMobile,
    required String address,
    required String area,
    required PropertyType propertyType,
    required int floors,
    required int annualValuation,
    @Default(<HoldingBill>[]) List<HoldingBill> bills,
  }) = _Holding;

  const Holding._();

  factory Holding.fromJson(Map<String, dynamic> json) =>
      _$HoldingFromJson(json);

  HoldingBill? billFor(String fiscalYear) {
    for (final bill in bills) {
      if (bill.fiscalYear == fiscalYear) return bill;
    }
    return null;
  }

  int get totalDue => bills.fold(0, (sum, b) => sum + b.due);
}
