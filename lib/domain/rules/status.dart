/// Status labels and the colour tone each one carries.
library;

import '../enums.dart';

const licenceStatusLabel = <LicenceStatus, String>{
  LicenceStatus.submitted: 'আবেদন জমা',
  LicenceStatus.verified: 'যাচাইকৃত',
  LicenceStatus.approved: 'অনুমোদিত',
  LicenceStatus.issued: 'ইস্যুকৃত',
  LicenceStatus.cancelled: 'বাতিল',
};

const licenceStatusTone = <LicenceStatus, Tone>{
  LicenceStatus.submitted: Tone.pending,
  LicenceStatus.verified: Tone.info,
  LicenceStatus.approved: Tone.info,
  LicenceStatus.issued: Tone.success,
  LicenceStatus.cancelled: Tone.danger,
};

/// Which desk acts next on a licence, and what that action is called.
/// `null` once the licence is issued or cancelled — nobody is waiting.
({AppRole role, String action})? nextActionFor(LicenceStatus status) =>
    switch (status) {
      LicenceStatus.submitted => (role: AppRole.inspector, action: 'মাঠ যাচাই'),
      LicenceStatus.verified => (
          role: AppRole.licenceOfficer,
          action: 'অনুমোদন ও রেজিস্টার নম্বর',
        ),
      LicenceStatus.approved => (
          role: AppRole.accounts,
          action: 'ফি আদায় ও ইস্যু',
        ),
      LicenceStatus.issued || LicenceStatus.cancelled => null,
    };

/// Tone for a status in a config-driven register: the last status in the list
/// reads as done, the first as pending, everything between as in progress.
Tone entryStatusTone(
  List<String> statuses,
  String status, {
  bool cancelled = false,
}) {
  if (cancelled) return Tone.danger;
  final i = statuses.indexOf(status);
  if (i < 0) return Tone.neutral;
  if (i == statuses.length - 1) return Tone.success;
  if (i == 0) return Tone.pending;
  return Tone.info;
}
