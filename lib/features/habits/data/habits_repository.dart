import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:flutter/foundation.dart';

class HabitsRepository {
  final SharedPreferences prefs;
  static const _key = 'habits_v1';

  HabitsRepository(this.prefs);

  Future<List<Habit>> load() async {
  final s = prefs.getString(_key);
  if (s == null || s.trim().isEmpty) return [];

  try {
    final raw = jsonDecode(s);

    if (raw is List) {
      final out = <Habit>[];
      for (final item in raw) {
        if (item is Map) {
          // tip güvenliği: dynamic map → Map<String, dynamic>
          final map = Map<String, dynamic>.from(item);
          out.add(Habit.fromMap(map));
        }
      }
      return out;
    }
  } catch (e, st) {
    if (kDebugMode) {
      debugPrint('HabitsRepository.load: invalid JSON → $e');
      debugPrintStack(stackTrace: st);
    }
  }

  // Beklenmeyen biçimlerde sessizce boş liste dön
  return [];
}


  Future<void> save(List<Habit> items) async {
    final s = jsonEncode(items.map((e) => e.toMap()).toList());
    await prefs.setString(_key, s);
  }
}
