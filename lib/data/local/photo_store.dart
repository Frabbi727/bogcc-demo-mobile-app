import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../core/time/local_iso.dart';
import '../../domain/enums.dart';
import '../../domain/models/shared.dart';

/// Photo files on disk, referenced from records by id.
///
/// The web stores a compressed data URL inside each record. That would be a
/// mistake here: every list read would carry the image bytes through the JSON
/// codec and into Hive. Instead a record holds a [PhotoRef] and the bytes live
/// in one directory.
///
/// Seeded photos are bundled assets ([PhotoRef.isAsset]), so a reseed needs no
/// synthesised JPEGs — and [deleteFor] must never remove them.
class PhotoStore {
  PhotoStore(this._dir);

  final Directory _dir;

  /// At most three per record. A complaint needs a before and an after; more
  /// than that is someone filling the disk.
  static const maxPerRecord = 3;

  static Future<PhotoStore> open() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/photos');
    if (!dir.existsSync()) await dir.create(recursive: true);
    return PhotoStore(dir);
  }

  File fileFor(String id) => File('${_dir.path}/$id');

  /// Copies a picked image in and returns a reference to store on the record.
  ///
  /// The caller picks at 800px / quality 70 (see the photo field widget), which
  /// is what keeps these at 60-120 KB rather than several megabytes.
  Future<PhotoRef> save(
    File source, {
    required PhotoKind kind,
    String? caption,
  }) async {
    final id = '${DateTime.now().microsecondsSinceEpoch}.jpg';
    await source.copy('${_dir.path}/$id');
    return PhotoRef(id: id, at: now(), kind: kind, caption: caption);
  }

  /// Removes the files behind a record's photos.
  Future<void> deleteFor(Iterable<PhotoRef> photos) async {
    for (final photo in photos) {
      // Asset-backed photos are part of the app bundle, not our data.
      if (photo.isAsset) continue;
      final file = fileFor(photo.id);
      if (file.existsSync()) await file.delete();
    }
  }

  /// Empties the directory. Part of ডেমো রিসেট.
  Future<void> clear() async {
    if (!_dir.existsSync()) return;
    await _dir.delete(recursive: true);
    await _dir.create(recursive: true);
  }

  int get count => _dir.existsSync()
      ? _dir.listSync().whereType<File>().length
      : 0;
}
