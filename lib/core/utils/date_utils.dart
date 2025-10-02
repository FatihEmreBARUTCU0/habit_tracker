// lib/core/utils/date_utils.dart

/// YYYY-MM-DD üretir (sadece tarih, saat yok).
String ymdFormat(DateTime d) {
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$m-$day';
}

/// Bugün dahil geriye [n] günün YYYY-MM-DD listesi (soldan → sağa: eski → yeni).
List<String> lastNDatesYmd(int n, {DateTime? now}) {
  assert(n > 0);
  final base = now ?? DateTime.now();
  final today = DateTime(base.year, base.month, base.day);
  final out = <String>[];
  for (int i = n - 1; i >= 0; i--) {
    out.add(ymdFormat(today.subtract(Duration(days: i))));
  }
  return out;
}

/// Bugünün YYYY-MM-DD değeri (isteğe bağlı test için [now] verilebilir).
String todayYmd({DateTime? now}) {
  final base = now ?? DateTime.now();
  return ymdFormat(DateTime(base.year, base.month, base.day));
}

/// Art arda işaretli gün sayısı (bugünden geriye).
int consecutiveStreak(Map<String, bool> history, {DateTime? now}) {
  final base = now ?? DateTime.now();
  var d = DateTime(base.year, base.month, base.day);
  int streak = 0;
  while (history[ymdFormat(d)] == true) {
    streak++;
    d = d.subtract(const Duration(days: 1));
  }
  return streak;
}

/// 'YYYY-MM-DD' → DateTime (local, sadece tarih)
DateTime _parseYmd(String ymd) {
  final p = ymd.split('-').map(int.parse).toList();
  return DateTime(p[0], p[1], p[2]);
}

/// Güncel seri (bugüne eşit ya da bugünden önceki en yakın işaretli gün baz alınarak).
/// Örnek: dün işaretli ama bugün değilse, bu yine ≥1 döner.
/// Maliyet: işaretli gün sayısı kadar O(n).
int currentStreakNearest(Map<String, bool> history, {DateTime? now}) {
  final trueDays = history.entries
      .where((e) => e.value == true)
      .map((e) => _parseYmd(e.key))
      .toList()
    ..sort();

  if (trueDays.isEmpty) return 0;

  final base = now ?? DateTime.now();
  final today = DateTime(base.year, base.month, base.day);

  // son gün ≤ today olan indexi bul
  int j = -1;
  for (int i = trueDays.length - 1; i >= 0; i--) {
    if (!trueDays[i].isAfter(today)) {
      j = i;
      break;
    }
  }
  if (j == -1) return 0;

  int streak = 1;
  for (int i = j; i > 0; i--) {
    final diff = trueDays[i].difference(trueDays[i - 1]).inDays;
    if (diff == 1) {
      streak++;
    } else if (diff > 1) {
      break;
    }
  }
  return streak;
}

/// En iyi (tüm zamanlar) seri = en uzun kesintisiz gün.
/// Maliyet: işaretli gün sayısı kadar O(n).
int bestStreak(Map<String, bool> history) {
  final days = history.entries
      .where((e) => e.value == true)
      .map((e) => _parseYmd(e.key))
      .toList()
    ..sort();

  if (days.isEmpty) return 0;

  int best = 1, cur = 1;
  for (int i = 1; i < days.length; i++) {
    final diff = days[i].difference(days[i - 1]).inDays;
    if (diff == 1) {
      cur++;
      if (cur > best) best = cur;
    } else if (diff >= 2) {
      cur = 1;
    }
  }
  return best;
}
