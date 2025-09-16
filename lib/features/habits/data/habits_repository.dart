import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';

class HabitsRepository {
  final SharedPreferences prefs;
  static const _key = 'habits_v1';

  HabitsRepository(this.prefs);

  Future<List<Habit>> load() async {
    final s = prefs.getString(_key);
    if (s == null) return [];
    final raw = (jsonDecode(s) as List).cast<Map<String, dynamic>>();
    return raw.map(Habit.fromMap).toList();
  }

  Future<void> save(List<Habit> items) async {
    final s = jsonEncode(items.map((e) => e.toMap()).toList());
    await prefs.setString(_key, s);
  }
}
