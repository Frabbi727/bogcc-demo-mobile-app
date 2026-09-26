/// Renders a [RegisterField] as a widget.
///
/// A map from field type to builder, so adding a field type to the engine is
/// one entry here plus one enum member — not a change to any screen.
library;

import 'package:flutter/material.dart';

import '../catalogue/names.dart';
import '../catalogue/registers/registers.dart';
import '../catalogue/wards.dart';
import '../core/bn/bn.dart';
import '../domain/enums.dart';
import '../ui/theme/colors.dart';
import '../ui/theme/spacing.dart';
import 'form_state.dart';

class FieldContext {
  const FieldContext({required this.field, required this.form});

  final RegisterField field;
  final DynamicFormState form;

  Object? get value => form[field.key];
  String? get error => form.errors[field.key];
  void set(Object? v) => form.set(field.key, v);
}

typedef FieldBuilder = Widget Function(FieldContext context);

final fieldRegistry = <FieldType, FieldBuilder>{
  FieldType.text: (c) => _TextField(c: c),
  FieldType.textarea: (c) => _TextField(c: c, lines: 3),
  FieldType.number: (c) => _TextField(c: c, digitsOnly: true, numeric: true),
  FieldType.phone: (c) => _TextField(c: c, digitsOnly: true, maxLength: 11),
  FieldType.nid: (c) => _TextField(c: c, digitsOnly: true, maxLength: 17),
  FieldType.select: (c) => _SelectField(c: c),
  FieldType.ward: (c) => _WardField(c: c),
  FieldType.date: (c) => _DateField(c: c),
  FieldType.photo: (c) => _PhotoField(c: c),
  FieldType.heirs: (c) => _HeirsField(c: c),
};

/// A label with the required marker, shared by every field.
class _Label extends StatelessWidget {
  const _Label({required this.field});
  final RegisterField field;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.xs),
      child: Row(
        children: [
          Text(field.label, style: text.labelLarge),
          if (field.required)
            Text(' *', style: text.labelLarge?.copyWith(color: AppColors.stamp)),
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.field, required this.error});
  final RegisterField field;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final message = error ?? field.hint;
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: Insets.xs),
      child: Text(
        message,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: error != null ? AppColors.stamp : AppColors.muted,
            ),
      ),
    );
  }
}

class _Wrapper extends StatelessWidget {
  const _Wrapper({required this.c, required this.child});
  final FieldContext c;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Label(field: c.field),
          child,
          _Hint(field: c.field, error: c.error),
        ],
      ),
    );
  }
}

class _TextField extends StatefulWidget {
  const _TextField({
    required this.c,
    this.lines = 1,
    this.digitsOnly = false,
    this.numeric = false,
    this.maxLength,
  });

  final FieldContext c;
  final int lines;
  final bool digitsOnly;
  final bool numeric;
  final int? maxLength;

  @override
  State<_TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> {
  late final _controller =
      TextEditingController(text: widget.c.value?.toString() ?? '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Wrapper(
      c: widget.c,
      child: TextField(
        controller: _controller,
        maxLines: widget.lines,
        maxLength: widget.maxLength,
        keyboardType: widget.digitsOnly
            ? TextInputType.number
            : widget.lines > 1
                ? TextInputType.multiline
                : TextInputType.text,
        // Bangla numerals are normalised to ASCII as the user types, so the
        // stored value never depends on which keyboard they happen to use.
        inputFormatters: widget.digitsOnly
            ? const [DigitsOnlyInputFormatter()]
            : const [BanglaDigitInputFormatter()],
        decoration: InputDecoration(
          counterText: '',
          errorText: widget.c.error == null ? null : '',
          errorStyle: const TextStyle(height: 0, fontSize: 0),
        ),
        onChanged: (v) => widget.c.set(
          widget.numeric ? num.tryParse(bnToEnDigits(v)) : v,
        ),
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({required this.c});
  final FieldContext c;

  @override
  Widget build(BuildContext context) {
    return _Wrapper(
      c: c,
      child: DropdownButtonFormField<String>(
        initialValue: c.value as String?,
        isExpanded: true,
        hint: const Text('বেছে নিন'),
        items: [
          for (final option in c.field.options ?? const <String>[])
            DropdownMenuItem(value: option, child: Text(option)),
        ],
        onChanged: c.set,
      ),
    );
  }
}

class _WardField extends StatelessWidget {
  const _WardField({required this.c});
  final FieldContext c;

  @override
  Widget build(BuildContext context) {
    return _Wrapper(
      c: c,
      child: DropdownButtonFormField<int>(
        initialValue: (c.value as num?)?.toInt(),
        isExpanded: true,
        hint: const Text('ওয়ার্ড বেছে নিন'),
        items: [
          for (final ward in wards)
            DropdownMenuItem(
              value: ward,
              child: Text('ওয়ার্ড ${toBnDigits(ward)}'),
            ),
        ],
        onChanged: c.set,
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.c});
  final FieldContext c;

  @override
  Widget build(BuildContext context) {
    final raw = c.value as String?;
    final parsed = raw == null ? null : DateTime.tryParse(raw);

    return _Wrapper(
      c: c,
      child: OutlinedButton.icon(
        onPressed: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: parsed ?? DateTime.now(),
            firstDate: DateTime(1940),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (picked != null) {
            final month = picked.month.toString().padLeft(2, '0');
            final day = picked.day.toString().padLeft(2, '0');
            c.set('${picked.year}-$month-$day');
          }
        },
        icon: const Icon(Icons.calendar_today_outlined, size: 16),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(parsed == null ? 'তারিখ বেছে নিন' : formatDateBn(parsed)),
        ),
      ),
    );
  }
}

/// Photo capture is Phase 1 scope but needs a camera, which an emulator and a
/// widget test both lack. The field is present and explains itself rather than
/// offering a button that cannot work.
class _PhotoField extends StatelessWidget {
  const _PhotoField({required this.c});
  final FieldContext c;

  @override
  Widget build(BuildContext context) {
    return _Wrapper(
      c: c,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: AppColors.rule),
        ),
        child: Column(
          children: [
            const Icon(Icons.photo_camera_outlined,
                size: 26, color: AppColors.muted),
            const SizedBox(height: Insets.sm),
            Text(
              'ছবি যুক্ত করুন (ঐচ্ছিক)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// The one field that is not a scalar: a table of heirs.
class _HeirsField extends StatefulWidget {
  const _HeirsField({required this.c});
  final FieldContext c;

  @override
  State<_HeirsField> createState() => _HeirsFieldState();
}

class _HeirsFieldState extends State<_HeirsField> {
  List<Map<String, dynamic>> get _rows =>
      (widget.c.value as List?)?.cast<Map<String, dynamic>>() ?? const [];

  void _add() {
    widget.c.set([
      ..._rows,
      <String, dynamic>{'name': '', 'relation': 'পুত্র', 'age': 0},
    ]);
  }

  void _removeAt(int index) {
    final next = [..._rows]..removeAt(index);
    widget.c.set(next.isEmpty ? null : next);
  }

  void _update(int index, String key, Object? value) {
    final next = [
      for (var i = 0; i < _rows.length; i++)
        if (i == index) {..._rows[i], key: value} else _rows[i],
    ];
    widget.c.set(next);
  }

  @override
  Widget build(BuildContext context) {
    return _Wrapper(
      c: widget.c,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < _rows.length; i++)
            Card(
              margin: const EdgeInsets.only(bottom: Insets.sm),
              child: Padding(
                padding: const EdgeInsets.all(Insets.md),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${toBnDigits(i + 1)} নং ওয়ারিশ',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _removeAt(i),
                          icon: const Icon(Icons.close, size: 18),
                          tooltip: 'সরান',
                        ),
                      ],
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'নাম'),
                      controller: TextEditingController(
                        text: _rows[i]['name']?.toString() ?? '',
                      ),
                      onChanged: (v) => _update(i, 'name', v),
                    ),
                    const SizedBox(height: Insets.sm),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _rows[i]['relation'] as String?,
                            isExpanded: true,
                            decoration:
                                const InputDecoration(labelText: 'সম্পর্ক'),
                            items: [
                              for (final r in heirRelations)
                                DropdownMenuItem(value: r, child: Text(r)),
                            ],
                            onChanged: (v) => _update(i, 'relation', v),
                          ),
                        ),
                        const SizedBox(width: Insets.sm),
                        SizedBox(
                          width: 92,
                          child: TextField(
                            decoration:
                                const InputDecoration(labelText: 'বয়স'),
                            keyboardType: TextInputType.number,
                            inputFormatters: const [
                              DigitsOnlyInputFormatter(),
                            ],
                            controller: TextEditingController(
                              text: _rows[i]['age']?.toString() ?? '',
                            ),
                            onChanged: (v) =>
                                _update(i, 'age', int.tryParse(v) ?? 0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          OutlinedButton.icon(
            onPressed: _add,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('ওয়ারিশ যোগ করুন'),
          ),
        ],
      ),
    );
  }
}
