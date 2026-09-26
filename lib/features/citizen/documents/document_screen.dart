/// Viewing and saving a certificate.
///
/// Public, outside both shells: a document is a document, and the person
/// holding one is not always the person signed in.
///
/// The sheet is laid out at A4 proportions and scaled to fit the phone, then
/// exported through [RepaintBoundary.toImage] — **not** through the `pdf`
/// package, which cannot shape Bengali. See `doc/decisions.md`.
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../catalogue/registers/registers.dart';
import '../../../domain/models/register_entry.dart';
import '../../../shell/demo_banner.dart';
import '../../../state/providers.dart';
import '../../../ui/theme/colors.dart';
import '../../../ui/theme/spacing.dart';
import 'certificate_sheet.dart';

/// Kinds of document the route can render. Only certificates exist so far;
/// the licence and the receipt each have their own shape and land later.
const documentKindCertificate = 'certificate';

class DocumentScreen extends ConsumerStatefulWidget {
  const DocumentScreen({required this.kind, required this.id, super.key});

  final String kind;
  final String id;

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  final _sheetKey = GlobalKey();
  bool _saving = false;

  /// Renders the sheet as it stands and writes it out as a PNG.
  ///
  /// The pixel ratio is fixed rather than taken from the device so the file is
  /// the same size whatever phone produced it — a certificate is a document,
  /// and its resolution should not depend on who downloaded it.
  Future<void> _save(RegisterEntry entry) async {
    setState(() => _saving = true);
    try {
      final boundary = _sheetKey.currentContext?.findRenderObject();
      if (boundary is! RenderRepaintBoundary) return;

      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) return;

      final dir = Directory(
        '${(await getApplicationDocumentsDirectory()).path}/documents',
      );
      if (!dir.existsSync()) await dir.create(recursive: true);

      final name = (entry.certificateNo ?? entry.serialNo)
          .replaceAll(RegExp(r'[^A-Za-z0-9-]'), '-');
      final file = File('${dir.path}/$name.png');
      await file.writeAsBytes(bytes.buffer.asUint8List());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('সনদ সংরক্ষিত হয়েছে: ${file.path}'),
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = ref.watch(demoStoreProvider).entry(widget.id);
    final config = entry == null ? null : getRegister(entry.registerKey);
    final text = Theme.of(context).textTheme;

    if (widget.kind != documentKindCertificate ||
        entry == null ||
        config?.certificate == null) {
      return _Shell(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Insets.xl),
            child: Text(
              'সনদ পাওয়া যায়নি।',
              style: text.bodyMedium?.copyWith(color: AppColors.muted),
            ),
          ),
        ),
      );
    }

    // A certificate is not a receipt: it exists only once the fee behind it
    // has actually been collected. Showing one before that would put an
    // unpaid document in a citizen's hands.
    if (entry.receiptId == null) {
      return _Shell(child: _FeeUnpaid(text: text));
    }

    return _Shell(
      action: IconButton(
        onPressed: _saving ? null : () => _save(entry),
        icon: _saving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.download_outlined),
        tooltip: 'ছবি হিসেবে সংরক্ষণ করুন',
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Scaled rather than reflowed: the sheet must be the same drawing on
          // screen and in the exported file, or the citizen saves something
          // they never saw.
          final scale =
              (constraints.maxWidth - Insets.lg * 2) / certificateSheetWidth;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.lg),
            child: Center(
              child: SizedBox(
                width: certificateSheetWidth * scale,
                height: certificateSheetHeight * scale,
                child: FittedBox(
                  child: RepaintBoundary(
                    key: _sheetKey,
                    child: SizedBox(
                      width: certificateSheetWidth,
                      height: certificateSheetHeight,
                      child: CertificateSheet(entry: entry, config: config!),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell({required this.child, this.action});

  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('সনদপত্র'),
        actions: [?action],
      ),
      backgroundColor: AppColors.paper,
      body: Column(
        children: [
          const DemoBanner(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _FeeUnpaid extends StatelessWidget {
  const _FeeUnpaid({required this.text});

  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Insets.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 32, color: AppColors.muted),
            const SizedBox(height: Insets.md),
            Text('সনদ এখনো প্রস্তুত নয়', style: text.titleMedium),
            const SizedBox(height: Insets.xs),
            Text(
              'ফি পরিশোধের পর সনদ ডাউনলোড করা যাবে।',
              style: text.bodyMedium?.copyWith(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
