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
