/// Holds what a citizen has typed into a config-driven form.
library;

import 'package:flutter/foundation.dart';

import '../catalogue/registers/registers.dart';
import '../domain/enums.dart';

class DynamicFormState extends ChangeNotifier {
  DynamicFormState({required this.fields, Map<String, dynamic>? initial})
      : values = {...?initial};

  final List<RegisterField> fields;
  final Map<String, dynamic> values;
  final Map<String, String> errors = {};

  Object? operator [](String key) => values[key] as Object?;

  void set(String key, Object? value) {
    if (value == null || (value is String && value.isEmpty)) {
      values.remove(key);
    } else {
      values[key] = value;
    }
    errors.remove(key);
    notifyListeners();
  }

  /// Fills [errors] and returns whether the form may be submitted.
  bool validate() {
    errors.clear();
    for (final field in fields) {
      final error = validateField(field, values[field.key] as Object?);
      if (error != null) errors[field.key] = error;
    }
    notifyListeners();
    return errors.isEmpty;
  }
}

/// One field's error message, or null when it is acceptable.
///
/// Messages say what to do rather than what is wrong: "১১ সংখ্যার মোবাইল নম্বর
/// দিন" is actionable in a way that "অবৈধ" is not.
String? validateField(RegisterField field, Object? value) {
  final isEmpty = value == null ||
      (value is String && value.trim().isEmpty) ||
      (value is List && value.isEmpty);

  if (isEmpty) return field.required ? '${field.label} দিন' : null;

  switch (field.type) {
    case FieldType.phone:
      // Bangladeshi mobile numbers are eleven digits starting 01.
      if (!RegExp(r'^01\d{9}$').hasMatch(value.toString())) {
        return '১১ সংখ্যার মোবাইল নম্বর দিন, যেমন ০১৭০০০০০০০০';
      }
    case FieldType.nid:
      final digits = value.toString();
      // 10, 13 and 17 digits are all in circulation in Bangladesh.
      if (!RegExp(r'^\d{10}$|^\d{13}$|^\d{17}$').hasMatch(digits)) {
        return '১০, ১৩ বা ১৭ সংখ্যার নম্বর দিন';
      }
    case FieldType.ward:
      final ward = int.tryParse(value.toString());
      if (ward == null || ward < 1 || ward > 21) {
        return 'ওয়ার্ড ১ থেকে ২১-এর মধ্যে বেছে নিন';
      }
    case FieldType.number:
      if (num.tryParse(value.toString()) == null) {
        return 'সংখ্যা দিন';
      }
    case FieldType.select:
      if (field.options != null && !field.options!.contains(value)) {
        return 'তালিকা থেকে বেছে নিন';
      }
    case FieldType.heirs:
      if (value is List && value.isEmpty) {
        return 'অন্তত একজন ওয়ারিশের তথ্য দিন';
      }
    case FieldType.text:
    case FieldType.textarea:
    case FieldType.date:
    case FieldType.photo:
      break;
  }
  return null;
}
