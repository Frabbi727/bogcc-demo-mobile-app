/// Citizen-charter service levels.
///
/// Every service in the catalogue promises a number of working days. The office
/// week is Sunday to Thursday: Friday and Saturday are the weekend and never
/// count towards a deadline.
library;

import '../../core/time/local_iso.dart';

/// Friday and Saturday.
///
/// These happen to be 5 and 6 in both `Date.getDay()` (0=Sun) and
/// `DateTime.weekday` (1=Mon), which is why this reads as a direct translation
/// of the original. Sunday does **not** line up — 0 there, 7 here — so any
/// future working-day check must not be copied across without checking.
bool isWeekend(DateTime d) =>
    d.weekday == DateTime.friday || d.weekday == DateTime.saturday;

/// The deadline [days] working days after [createdAt], at end of that day.
DateTime dueDate(DateTime createdAt, int days) {
  var d = dateOnly(createdAt);
  var remaining = days < 0 ? 0 : days;
  while (remaining > 0) {
    d = shiftDays(d, 1);
    if (!isWeekend(d)) remaining -= 1;
  }
  // 23:59:59 on the due day: a record filed on its deadline day is on time.
  return DateTime(d.year, d.month, d.day, 23, 59, 59);
}

/// Working days between two dates, ignoring the weekend.
/// Negative when [to] is earlier than [from].
int workingDaysBetween(DateTime from, DateTime to) {
  final sign = !to.isBefore(from) ? 1 : -1;
  var cursor = dateOnly(sign > 0 ? from : to);
  final last = dateOnly(sign > 0 ? to : from);

  var count = 0;
  while (cursor.isBefore(last)) {
    cursor = shiftDays(cursor, 1);
    if (!isWeekend(cursor)) count += 1;
  }
  return count * sign;
}

enum SlaStatus { onTime, dueSoon, overdue }

const slaLabel = <SlaStatus, String>{
  SlaStatus.onTime: 'সময়মতো',
  SlaStatus.dueSoon: 'শীঘ্রই মেয়াদ শেষ',
  SlaStatus.overdue: 'মেয়াদোত্তীর্ণ',
};

/// The parts of a record the SLA helpers need.
///
/// Deliberately an interface rather than the record type: this module has to
/// work for licences, register entries and anything added later, and should not
/// have to know about any of them.
abstract interface class SlaSubject {
  DateTime get dueAt;
  DateTime? get closedAt;
  DateTime? get cancelledAt;

  /// Internal books like the daily trip log promise nothing to a citizen, so
  /// they are not measured against the charter at all.
  bool get slaExempt;
}

/// A record is overdue when it is still open past its deadline, or was closed
/// after it. A cancelled record is never overdue — nobody is waiting on it.
bool isOverdue(SlaSubject record, {DateTime? asOf}) {
  if (record.cancelledAt != null || record.slaExempt) return false;
  final settled = record.closedAt ?? asOf ?? now();
  return settled.isAfter(record.dueAt);
}

/// [SlaStatus.dueSoon] means one working day or less remains.
SlaStatus slaStatus(SlaSubject record, {DateTime? asOf}) {
  if (record.slaExempt) return SlaStatus.onTime;
  if (isOverdue(record, asOf: asOf)) return SlaStatus.overdue;
  if (record.closedAt != null || record.cancelledAt != null) {
    return SlaStatus.onTime;
  }
  return workingDaysBetween(asOf ?? now(), record.dueAt) <= 1
      ? SlaStatus.dueSoon
      : SlaStatus.onTime;
}

/// Working days a record is past its deadline; 0 when it is not overdue.
int daysOverdue(SlaSubject record, {DateTime? asOf}) {
  if (!isOverdue(record, asOf: asOf)) return 0;
  final settled = record.closedAt ?? asOf ?? now();
  final days = workingDaysBetween(record.dueAt, settled);
  // Past the deadline by any amount is at least one day late on a report.
  return days < 1 ? 1 : days;
}
