import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The app's central claim is that it holds all of its data on the device and
/// cannot phone home. That is a property of the built manifest, not of the
/// source, and it regressed once already: adding mobile_scanner pulled in ML
/// Kit, which drags in Google's transport-backend-cct telemetry uploader, which
/// declares INTERNET — and it merged into the release manifest silently.
///
/// This checks the source manifest keeps the removals in place. The built APK
/// is verified with `aapt dump badging`, which is in the README's verification
/// steps; this test is the cheap guard that runs on every commit.
void main() {
  final manifest =
      File('android/app/src/main/AndroidManifest.xml').readAsStringSync();

  test('network permissions are explicitly stripped at merge', () {
    for (final permission in [
      'android.permission.INTERNET',
      'android.permission.ACCESS_NETWORK_STATE',
    ]) {
      final declared = RegExp(
        '<uses-permission[^>]*android:name="$permission"[^>]*?'
        r'tools:node="remove"',
        dotAll: true,
      );
      expect(
        declared.hasMatch(manifest),
        isTrue,
        reason: '$permission must be removed with tools:node="remove"',
      );
    }
  });

  test('the tools namespace the removals need is declared', () {
    expect(manifest, contains('xmlns:tools="http://schemas.android.com/tools"'));
  });

  test('camera is the only permission the app asks for', () {
    final requested = RegExp(r'<uses-permission\s+android:name="([^"]+)"([^>]*)>')
        .allMatches(manifest)
        .where((m) => !m.group(2)!.contains('tools:node="remove"'))
        .map((m) => m.group(1)!)
        .toList();
    expect(requested, ['android.permission.CAMERA']);
  });

  test('the application id is not the com.example default', () {
    // Play and Firebase reject com.example, and it cannot be changed later
    // without a new app identity.
    final gradle =
        File('android/app/build.gradle.kts').readAsStringSync();
    expect(gradle, contains('bd.gov.bogura.bogcc.demo'));
    expect(gradle, isNot(contains('com.example')));
  });
}
