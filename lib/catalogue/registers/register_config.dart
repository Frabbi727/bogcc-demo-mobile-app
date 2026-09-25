/// The config-driven register engine's contract.
///
/// Nine of the eleven modules are just a [RegisterConfig] consumed by three
/// generic screens, which is why this file is the highest-leverage part of the
/// port: adding a register means adding a config, not a screen.
///
/// These are hand-written `const` classes rather than freezed models on purpose
/// — a config is compile-time data that is never persisted or serialised, so
/// JSON and copyWith would be pure overhead.
library;

import '../../domain/enums.dart';

class RegisterField {
  const RegisterField({
    required this.key,
    required this.label,
    required this.type,
    this.options,
    this.required = false,
    this.showInBook = false,
    this.citizenInput = false,
    this.staffOnly = false,
    this.hint,
  });

  final String key;

  /// Bangla label, and also the register book column heading.
  final String label;
  final FieldType type;
  final List<String>? options;
  final bool required;

  /// Show as a column on the register book page.
  final bool showInBook;

  /// Ask the citizen for this on the online application form.
  final bool citizenInput;

  /// Filled by staff while processing; never shown to the citizen as an input.
  final bool staffOnly;
  final String? hint;
}

/// One step in a register's workflow.
///
/// The paper book gets a step's columns filled at the moment that step happens,
/// which is what [requiredFields] encodes.
class RegisterStep {
  const RegisterStep({
    required this.key,
    required this.label,
    required this.citizenLabel,
    this.actors = const [],
    this.requiredFields = const [],
    this.payment = false,
  });

  final String key;

  /// Label staff see.
  final String label;

  /// Label the citizen sees on their tracking page.
  final String citizenLabel;

  /// Roles allowed to move a record INTO this step. Empty for creation.
  final List<AppRole> actors;

  /// Staff fields that must be filled to complete this step.
  final List<String> requiredFields;

  /// Reached by paying rather than by a staff tap — either the citizen pays
  /// through the mock gateway or accounts collects at the counter.
  final bool payment;
}

class CertificateSection {
  const CertificateSection({required this.label, required this.fields});
  final String label;
  final List<String> fields;
}

class CertificateSpec {
  const CertificateSpec({
    required this.docTitle,
    required this.body,
    this.sections = const [],
    this.signatories = const [],
  });

  final String docTitle;

  /// Body paragraph; `{{field}}` placeholders are filled from the entry data.
  final String body;
  final List<CertificateSection> sections;
  final List<String> signatories;
}

/// Which data fields carry the applicant's name and mobile.
class ApplicantFields {
  const ApplicantFields({required this.name, required this.mobile});
  final String name;
  final String mobile;
}

class RegisterConfig {
  const RegisterConfig({
    required this.key,
    required this.title,
    required this.section,
    required this.serialPrefix,
    required this.fields,
    required this.steps,
    required this.dateField,
    this.serviceKey,
    this.createRoles = const [],
    this.cancelRoles = const [],
    this.citizenFacing = false,
    this.wardScoped = false,
    this.printable = false,
    this.applicantFields,
    this.totals = const [],
    this.description,
    this.certificate,
  });

  final String key;

  /// Links to the service catalogue when citizens can apply for this.
  final String? serviceKey;
  final String title;
  final String section;
  final String serialPrefix;
  final List<RegisterField> fields;

  /// Ordered; the first step is set on creation.
  final List<RegisterStep> steps;
  final List<AppRole> createRoles;
  final List<AppRole> cancelRoles;
  final bool citizenFacing;

  /// The councillor sees only records in their own ward.
  final bool wardScoped;

  /// Shows a printable certificate once the final step is reached.
  final bool printable;

  /// Field used for the fiscal-year and date-range filters.
  final String dateField;

  /// A register that does not collect the applicant's details as fields leaves
  /// this unset, and the intake form asks for them separately.
  final ApplicantFields? applicantFields;

  /// Numeric field keys summed in the book footer.
  final List<String> totals;

  /// One-line description shown on the register book header.
  final String? description;
  final CertificateSpec? certificate;
}

extension RegisterConfigX on RegisterConfig {
  int stepIndexOf(String statusKey) =>
      steps.indexWhere((s) => s.key == statusKey);

  RegisterStep? stepOf(String statusKey) {
    for (final s in steps) {
      if (s.key == statusKey) return s;
    }
    return null;
  }

  /// The step after [statusKey], or null when the work is finished.
  RegisterStep? nextStep(String statusKey) {
    final i = stepIndexOf(statusKey);
    if (i < 0 || i >= steps.length - 1) return null;
    return steps[i + 1];
  }

  /// Can this role move the record into its next step?
  bool canAdvance(String statusKey, AppRole role) {
    final next = nextStep(statusKey);
    return next != null && next.actors.contains(role);
  }

  /// Whether this role may cancel a record in this register.
  bool canCancel(AppRole role) => cancelRoles.contains(role);

  /// Whether this role may open a new line in this register.
  bool canCreate(AppRole role) => createRoles.contains(role);

  /// Fields shown on the citizen-facing application form, in config order.
  List<RegisterField> get citizenFields =>
      [for (final f in fields) if (f.citizenInput) f];

  /// Fields an operator fills for a walk-in entry: everything but staff-only.
  List<RegisterField> get intakeFields =>
      [for (final f in fields) if (!f.staffOnly) f];

  /// Columns that appear on the register book page.
  List<RegisterField> get bookColumns =>
      [for (final f in fields) if (f.showInBook) f];

  RegisterField? fieldOf(String key) {
    for (final f in fields) {
      if (f.key == key) return f;
    }
    return null;
  }

  /// The internal status keys in order, for the status-tone helper.
  List<String> get statusKeys => [for (final s in steps) s.key];

  /// Pulls the applicant's name and mobile out of an entry's data.
  ///
  /// Returns null for a register that does not collect them — the office-only
  /// trip log — and the caller falls back to the staff member filing the line.
  ({String name, String mobile})? applicantFrom(Map<String, dynamic> data) {
    final f = applicantFields;
    if (f == null) return null;
    final name = data[f.name];
    final mobile = data[f.mobile];
    if (name is! String || mobile is! String) return null;
    return (name: name, mobile: mobile);
  }
}
