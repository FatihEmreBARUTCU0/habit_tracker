import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show compute;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:open_filex/open_filex.dart';


String _encodePretty(Map<String, dynamic> p) =>
    const JsonEncoder.withIndent('  ').convert(p);

Future<String> _buildAndEncode(List<Habit> items) async {
  final maps = items.map((e) => e.toMap()).toList();
  final payload = {
    'type': 'habit_backup',
    'version': 1,
    'exportedAt': DateTime.now().toIso8601String(),
    'items': maps,
  };
  return compute(_encodePretty, payload);
}

class BackupService {
  Future<XFile?> shareBackup(List<Habit> items, {String? fileName}) async {
    if (items.isEmpty) return null;

    final json = await _buildAndEncode(items);
    final dir = await getTemporaryDirectory();
    final name = fileName ??
        'habit_backup_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File('${dir.path}/$name');
    await file.writeAsString(json, encoding: utf8);

    final xfile = XFile(file.path, mimeType: 'application/json', name: name);

    // ✅ Yeni share_plus kullanımı
    await SharePlus.instance.share(
      ShareParams(
        files: [xfile],
        subject: 'Habit Backup',
      ),
    );
    return xfile;
  }
Future<String?> saveBackupToDownloads(List<Habit> items, {String? fileName}) async {
  if (items.isEmpty) return null;

  final json = await _buildAndEncode(items);
  final name = fileName ?? 'habit_backup_${DateTime.now().millisecondsSinceEpoch}';
  final bytes = Uint8List.fromList(utf8.encode(json));

  final savedPathOrUri = await FileSaver.instance.saveFile(
    name: '$name.json',
    bytes: bytes,
     
     mimeType: MimeType.json 
  );
  return savedPathOrUri;
}

Future<void> openSavedPath(String pathOrUri) async {
  await OpenFilex.open(pathOrUri);
}

Future<String> buildBackupJson(List<Habit> items) => _buildAndEncode(items);

// lib/core/backup/backup_service.dart
Future<String?> saveBackupWithPicker(List<Habit> items, {String? fileName}) async {
  if (items.isEmpty) return null;

  final json  = await _buildAndEncode(items);
  final name  = fileName ?? 'habit_backup_${DateTime.now().millisecondsSinceEpoch}';
  final bytes = Uint8List.fromList(utf8.encode(json));

  // Kullanıcıya konum/dosya adı seçtirir → MediaStore’a işler.
  final uriOrPath = await FileSaver.instance.saveAs(
    name: name,   // uzantısız
     fileExtension: 'json', 
    bytes: bytes,
    mimeType: MimeType.json,
  );
  return uriOrPath; // çoğunlukla content:// URI döner
}



}
