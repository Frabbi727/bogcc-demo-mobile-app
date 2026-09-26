import 'package:bogcc_demo_mobile_app/catalogue/registers/registers.dart';
import 'package:bogcc_demo_mobile_app/domain/enums.dart';
import 'package:bogcc_demo_mobile_app/engine/field_registry.dart';
import 'package:bogcc_demo_mobile_app/engine/form_state.dart';
import 'package:flutter_test/flutter_test.dart';

RegisterField _field(FieldType type, {bool required = false, List<String>? options}) =>
    RegisterField(
      key: 'f',
      label: 'ক্ষেত্র',
      type: type,
      required: required,
      options: options,
    );

void main() {
  group('required', () {
    test('an empty required field is rejected, an optional one is not', () {
      expect(validateField(_field(FieldType.text, required: true), null),
          isNotNull);
      expect(validateField(_field(FieldType.text, required: true), '  '),
          isNotNull);
      expect(validateField(_field(FieldType.text), null), isNull);
      expect(validateField(_field(FieldType.text), ''), isNull);
    });

    test('the message says what to do, not that something is wrong', () {
      final message =
          validateField(_field(FieldType.text, required: true), null)!;
      expect(message, contains('দিন'));
    });
  });

  group('per-type rules', () {
    test('a mobile number must be eleven digits starting 01', () {
      final field = _field(FieldType.phone, required: true);
      expect(validateField(field, '01712345678'), isNull);
      expect(validateField(field, '0171234567'), isNotNull);
      expect(validateField(field, '02712345678'), isNotNull);
      expect(validateField(field, 'abcdefghijk'), isNotNull);
    });

    test('an NID may be 10, 13 or 17 digits', () {
      // All three lengths are in circulation in Bangladesh, so rejecting any
      // of them would turn away real people.
      final field = _field(FieldType.nid, required: true);
      expect(validateField(field, '1234567890'), isNull);
      expect(validateField(field, '1234567890123'), isNull);
      expect(validateField(field, '12345678901234567'), isNull);
      expect(validateField(field, '123456'), isNotNull);
      expect(validateField(field, '123456789012'), isNotNull);
    });

    test('a ward must be one of the twenty-one', () {
      final field = _field(FieldType.ward, required: true);
      expect(validateField(field, 1), isNull);
      expect(validateField(field, 21), isNull);
      expect(validateField(field, 0), isNotNull);
      expect(validateField(field, 22), isNotNull);
    });

    test('a select must be one of its own options', () {
      final field = _field(
        FieldType.select,
        required: true,
        options: ['বাতি নষ্ট', 'তার ছেঁড়া'],
      );
      expect(validateField(field, 'বাতি নষ্ট'), isNull);
      expect(validateField(field, 'অন্য কিছু'), isNotNull);
    });

    test('a number field rejects text', () {
      expect(validateField(_field(FieldType.number), 'অনেক'), isNotNull);
      expect(validateField(_field(FieldType.number), 12), isNull);
    });
  });

  group('DynamicFormState', () {
    test('clearing a value removes it rather than storing an empty string', () {
      // An empty string in the data map would later print as a blank column in
      // the register book instead of being absent.
      final form = DynamicFormState(fields: [_field(FieldType.text)]);
      form.set('f', 'কিছু');
      expect(form.values['f'], 'কিছু');
      form.set('f', '');
      expect(form.values.containsKey('f'), isFalse);
    });

    test('validate reports every missing field at once', () {
      final config = getRegister('streetlight')!;
      final form = DynamicFormState(fields: config.citizenFields);
      expect(form.validate(), isFalse);
      // Four of the citizen fields on this register are required.
      expect(form.errors.keys,
          containsAll(['ward', 'road', 'faultType', 'complainant']));
    });

    test('a complete form passes', () {
      final config = getRegister('streetlight')!;
      final form = DynamicFormState(fields: config.citizenFields)
        ..set('ward', 5)
        ..set('road', 'সাতমাথা')
        ..set('faultType', 'বাতি নষ্ট')
        ..set('complainant', 'রহিমা খাতুন')
        ..set('complainantMobile', '01700000000');
      expect(form.validate(), isTrue);
      expect(form.errors, isEmpty);
    });

    test('setting a value clears that field error', () {
      final config = getRegister('streetlight')!;
      final form = DynamicFormState(fields: config.citizenFields);
      form.validate();
      expect(form.errors['ward'], isNotNull);
      form.set('ward', 5);
      expect(form.errors['ward'], isNull);
    });
  });

  group('the field registry', () {
    test('has a builder for every field type the engine declares', () {
      // A missing entry is a crash the first time a register uses that type.
      for (final type in FieldType.values) {
        expect(fieldRegistry[type], isNotNull, reason: type.name);
      }
    });

    test('covers every field actually used by every register', () {
      for (final config in registers) {
        for (final field in config.fields) {
          expect(fieldRegistry[field.type], isNotNull,
              reason: '${config.key}.${field.key}');
        }
      }
    });
  });
}
