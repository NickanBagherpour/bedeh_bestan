import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List;
import 'package:local_db/local_db.dart'
    show AppDatabase, BackupException, BackupFailure;

final class BackupRepository {
  BackupRepository({
    required AppDatabase database,
    required this.readSettings,
    required this.writeSettings,
  }) : _database = database;

  final AppDatabase _database;
  final Map<String, String> Function() readSettings;
  final Future<void> Function(Map<String, String> values) writeSettings;

  Future<String> buildFile() async {
    final dbJson = jsonDecode(await _database.exportBackupJson());
    if (dbJson is! Map) {
      throw const BackupException(BackupFailure.invalidFormat);
    }
    final envelope = Map<String, Object?>.from(dbJson);
    envelope['settings'] = readSettings();
    return jsonEncode(envelope);
  }

  Future<void> applyFile(String raw) async {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw const BackupException(BackupFailure.invalidFormat);
    }
    final envelope = Map<String, Object?>.from(decoded);
    await _database.importBackupJson(raw);
    final settings = envelope['settings'];
    if (settings is Map) {
      await writeSettings({
        for (final entry in settings.entries)
          if (entry.key is String && entry.value != null)
            entry.key as String: '${entry.value}',
      });
    }
  }

  Future<bool> saveToDisk(String json, {required String fileName}) async {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: fileName,
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: const ['json'],
      bytes: Uint8List.fromList(utf8.encode(json)),
    );
    return path != null;
  }

  Future<String?> pickFromDisk() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;
    final bytes = result.files.single.bytes;
    if (bytes == null) return null;
    return utf8.decode(bytes);
  }
}
