import 'package:habit_tracker/core/utils/date_utils.dart' as dtu;

class Habit {
  final String id;
  final String name;
  final Map<String, bool> history;
  final String lastCheckedYmd;

  Habit({
    required this.id,
    required this.name,
    this.lastCheckedYmd = '',
    Map<String, bool>? history,
  }) : history = history ?? {};

  Habit copyWith({String? id, String? name, Map<String, bool>? history}) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      lastCheckedYmd: lastCheckedYmd,
      history: history ?? this.history,
    );
  }

  // bugünün işaret durumu
 bool get isCheckedToday => history[dtu.todayYmd()] == true;

    Habit toggleTodayImmutable() {
    final t = dtu.todayYmd();
    final next = Map<String, bool>.from(history);
    if (next[t] == true) {
      next.remove(t);
    } else {
      next[t] = true;
    }
    return copyWith(history: next);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastCheckedYmd': lastCheckedYmd,
      'history': history,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    final lc = map['lastCheckedYmd'] as String? ?? '';
    final rawHistory = map['history'];
    Map<String, bool> parsedHistory = {};
    if (rawHistory is Map) {
      parsedHistory = rawHistory.map((k, v) => MapEntry(k.toString(), v == true));
    }
    if (parsedHistory.isEmpty && lc.isNotEmpty) {
      parsedHistory[lc] = true;
    }
    return Habit(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      lastCheckedYmd: lc,
      history: parsedHistory,
    );
  }
}


