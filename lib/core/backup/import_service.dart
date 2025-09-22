// lib/core/backup/import_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:habit_tracker/features/habits/domain/habit.dart';

Map<String, dynamic> _decodeJson(String s) => jsonDecode(s) as Map<String, dynamic>;

class ImportResult {
  final int added;
  final int merged;
  const ImportResult({required this.added, required this.merged});
}

class ImportService {
  /// Dosya seç, içeriği oku, JSON parse et, Habit listesine çevir.
  Future<List<Habit>> pickAndParse() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true, // mobil için ideal; bytes geliyor
    );
    if (res == null || res.files.isEmpty) return const [];

    final f = res.files.single;

    String? text;
    if (f.bytes != null) {
      text = utf8.decode(f.bytes!);
    } else if (f.path != null && f.path!.isNotEmpty) {
      text = await File(f.path!).readAsString();
    }
    if (text == null) {
      throw const FormatException('Cannot read selected file');
    }

    final map = await compute(_decodeJson, text);

    // Şema doğrulama
    if (map['type'] != 'habit_backup' || map['version'] != 1 || map['items'] is! List) {
      throw const FormatException('Invalid backup schema');
    }

    final items = (map['items'] as List).cast<Map<String, dynamic>>();
    return items
        .map(Habit.fromMap)
        .where((h) => h.id.isNotEmpty && h.name.isNotEmpty)
        .toList();
  }

  // history union: herhangi birinde true ise true
  Map<String, bool> _mergeHistory(Map<String, bool> a, Map<String, bool> b) {
    final out = <String, bool>{}..addAll(a);
    for (final e in b.entries) {
      if (e.value == true) out[e.key] = true;
    }
    return out;
  }

  /// Merge stratejisi:
  /// 1) id eşleşirse → hedef kaydın history'sini union yap (isim hedefteki gibi kalır).
  /// 2) id yok ama aynı isme (case-insensitive) sahipse → union.
  /// 3) değilse → yeni olarak ekle.
  ImportResult mergeInto(List<Habit> current, List<Habit> incoming) {
    int added = 0, merged = 0;

    final byId = {for (final h in current) h.id: h};
    final byName = {for (final h in current) h.name.trim().toLowerCase(): h};

    for (final inc in incoming) {
      final hitId = byId[inc.id];
      if (hitId != null) {
        final i = current.indexOf(hitId);
        current[i] = hitId.copyWith(
          history: _mergeHistory(hitId.history, inc.history),
        );
        merged++;
        continue;
      }

      final hitName = byName[inc.name.trim().toLowerCase()];
      if (hitName != null) {
        final i = current.indexOf(hitName);
        current[i] = hitName.copyWith(
          history: _mergeHistory(hitName.history, inc.history),
        );
        merged++;
        continue;
      }

      current.add(inc);
      added++;
    }

    return ImportResult(added: added, merged: merged);
  }
}
