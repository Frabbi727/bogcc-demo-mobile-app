/// How a stored field value is written out for a human to read.
///
/// Ported from the web's `src/lib/registerFields.ts`. One function, used by the
/// citizen's tracking page, the certificate and (in Phase 2) the register book,
/// because a value that reads one way on screen and another on a signed
/// certificate is a defect the reader has no way to resolve.
///
/// Values are *stored* in ASCII digits; everything here is the conversion on
/// the way out. See `core/bn`.
library;

import '../catalogue/registers/register_config.dart';
import '../core/bn/bn.dart';
import '../domain/enums.dart';
import '../domain/models/json.dart';
import '../domain/models/shared.dart';

/// Placeholder for a field with nothing in it. An em dash, not an empty cell:
/// a blank on a register line reads as an omission rather than a known absence.
const emptyFieldMark = '—';

/// One field's value, formatted by the type the config declares for it.
String displayField(RegisterField? field, Object? value) {
  if (value == null || (value is String && value.isEmpty)) return emptyFieldMark;

  return switch (field?.type) {
    FieldType.heirs => '${toBnDigits(_heirsOf(value).length)} জন ওয়ারিশ',
    FieldType.photo => '${toBnDigits(value is List ? value.length : 0)} টি ছবি',
    FieldType.ward => 'ওয়ার্ড ${toBnDigits(value)}',
    FieldType.date => _date(value),
    FieldType.number || FieldType.phone || FieldType.nid => toBnDigits(value),
    _ => toBnDigits(value),
  };
}

/// The same value with no unit or label around it, for `{{field}}`
/// interpolation into a certificate's body paragraph — where the surrounding
/// sentence already supplies the wording.
String interpolatedField(RegisterField? field, Object? value) {
  if (value == null || value is List) return '';
  return switch (field?.type) {
    FieldType.date => _date(value),
    _ => toBnDigits(value.toString()),
  };
}

String _date(Object value) {
  final parsed = value is DateTime ? value : DateTime.tryParse(value.toString());
  return parsed == null ? toBnDigits(value) : formatDateBn(parsed);
}

List<Heir> _heirsOf(Object value) {
  if (value is! List) return const [];
  return [
    for (final row in value)
      if (row is Map) Heir.fromJson(asJsonMap(row)),
  ];
}
