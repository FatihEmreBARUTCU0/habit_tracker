
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
  bool get isCheckedToday => history[_todayYmd()] == true;

  void toggleToday() {
    final t = _todayYmd();
    if (history[t] == true) {
      history.remove(t);
    } else {
      history[t] = true;
    }
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

String _todayYmd() {
  final now = DateTime.now();
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  return '${now.year}-$m-$d';
}

