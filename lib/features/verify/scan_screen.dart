/// The camera half of সনদ যাচাই: read a certificate's QR instead of typing its
/// number off the paper.
///
/// This screen decides nothing. It reads one code, pops it back to
/// [VerifyScreen] as a raw string, and lets the rules in
/// `domain/rules/verification.dart` reach the verdict — so there is exactly one
/// place where a document is judged, whether its number was typed or scanned.
///
/// Scanning is entirely on-device: ML Kit's bundled model, no network. That is
/// what lets the app keep refusing `android.permission.INTERNET` while still
/// shipping a scanner — see `doc/decisions.md`.
///
/// Public, like the rest of `/verify`: the person checking a certificate is
/// usually not the person it belongs to, and often not signed in at all.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../ui/theme/colors.dart';
import '../../ui/theme/spacing.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _controller = MobileScannerController(
    // QR only. Accepting every format would make the scanner fire on the
    // barcode of whatever else is on the desk.
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
  );

  /// The camera keeps detecting the same code many times a second. The first
  /// one wins and the rest are dropped, or `pop` is called on a dead route.
  bool _handled = false;

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;

    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw == null || raw.trim().isEmpty) continue;

      _handled = true;
      // Whether this is one of our own verify URLs or something else entirely
      // is the verify screen's judgement, not the camera's.
      context.pop(raw.trim());
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('কিউআর স্ক্যান'),
        actions: [
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (_, state, _) {
              if (state.torchState == TorchState.unavailable) {
                return const SizedBox.shrink();
              }
              final on = state.torchState == TorchState.on;
              return IconButton(
                tooltip: on ? 'ফ্ল্যাশ বন্ধ' : 'ফ্ল্যাশ চালু',
                icon: Icon(on ? Icons.flash_on : Icons.flash_off),
                onPressed: () => unawaited(_controller.toggleTorch()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                // A square window a little narrower than the screen: it both
                // aims the person and stops a code at the very edge of the
                // frame, where the lens distorts it, from being read.
                final side = size.shortestSide * 0.7;
                final window = Rect.fromCenter(
                  center: size.center(Offset.zero),
                  width: side,
                  height: side,
                );

                return MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                  scanWindow: window,
                  errorBuilder: (_, error) => _CameraUnavailable(error: error),
                  overlayBuilder: (_, _) => _Reticle(window: window),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(Insets.lg),
              child: Column(
                children: [
                  const Text(
                    'সনদ বা লাইসেন্সের কিউআর কোডটি চৌকো ঘরের ভিতরে ধরুন।',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Insets.md),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('নম্বর লিখে যাচাই করি'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Drawn over the preview: everything outside the scan window is dimmed, and
/// the window itself is left clear inside a white border.
///
/// The dimming is four panels around the window rather than one translucent
/// sheet with a hole in it, because a sheet would dim the window too and the
/// whole point is that the code inside it stays bright.
class _Reticle extends StatelessWidget {
  const _Reticle({required this.window});

  final Rect window;

  @override
  Widget build(BuildContext context) {
    const dim = Color(0x73000000);

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: window.top,
            child: const ColoredBox(color: dim),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: window.bottom,
            bottom: 0,
            child: const ColoredBox(color: dim),
          ),
          Positioned(
            left: 0,
            width: window.left,
            top: window.top,
            height: window.height,
            child: const ColoredBox(color: dim),
          ),
          Positioned(
            left: window.right,
            right: 0,
            top: window.top,
            height: window.height,
            child: const ColoredBox(color: dim),
          ),
          Positioned.fromRect(
            rect: window,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(Radii.md),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown instead of the preview when the camera cannot run at all: permission
/// refused, or no camera (an emulator without one, a desktop build). Typing the
/// number always works, so this is never a dead end.
class _CameraUnavailable extends StatelessWidget {
  const _CameraUnavailable({required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    final denied = error.errorCode == MobileScannerErrorCode.permissionDenied;

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(Insets.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                denied ? Icons.no_photography_outlined : Icons.videocam_off,
                color: AppColors.amber,
                size: 34,
              ),
              const SizedBox(height: Insets.md),
              Text(
                denied
                    ? 'ক্যামেরার অনুমতি দেওয়া হয়নি'
                    : 'এই ডিভাইসে ক্যামেরা ব্যবহার করা যাচ্ছে না',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Insets.xs),
              Text(
                denied
                    ? 'সেটিংসে গিয়ে অনুমতি দিন, অথবা নম্বর লিখে যাচাই করুন।'
                    : 'নম্বর লিখে যাচাই করুন।',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Insets.lg),
              FilledButton(
                onPressed: () => context.pop(),
                child: const Text('নম্বর লিখে যাচাই করি'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
