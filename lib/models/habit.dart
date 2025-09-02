import 'dart:math';

final _rnd = Random();
int _ctr = 0;

class Habit {
  final String id;
  String name;

  // (Opsiyonel) Eski alan — geriye uyumluluk için şimdilik tutuyoruz ama KULLANMIYORUZ.
  String lastCheckedYmd;

  // YENİ: tarih (YYYY-MM-DD) -> o gün yapıldı mı?
  Map<String, bool> history;

  Habit({
    required this.id,
    required this.name,
    this.lastCheckedYmd = '',              // eski veri yüklenirse burada dursun
    Map<String, bool>? history,            // null gelirse boş map yap
  }) : history = history ?? {};

  // BUGÜN işaretli mi? Artık history üzerinden hesaplıyoruz.
  bool get isCheckedToday => history[_todayYmd()] == true;

  // JSON için: nesneden Map'e
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastCheckedYmd': lastCheckedYmd,    // geriye uyumluluk: yazmaya devam (isteğe bağlı)
      'history': history,                  // Map<String,bool> JSON'a doğal gider
    };
  }

  // JSON için: Map'ten nesneye
  factory Habit.fromMap(Map<String, dynamic> map) {
    // history güvenli parse
    final rawHistory = map['history'];
    Map<String, bool> parsedHistory = {};
    if (rawHistory is Map) {
      parsedHistory = rawHistory.map((k, v) => MapEntry(k.toString(), v == true));
    }

    return Habit(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      lastCheckedYmd: map['lastCheckedYmd'] as String? ?? '',  // eski veriyi al
      history: parsedHistory,
    );
  }

  // YENİ: Bugünü toggle etmek için ufak yardımcı (istersen kullanırsın)
  void toggleToday() {
    final t = _todayYmd();
    if (history[t] == true) {
      history.remove(t); // yok = false
    } else {
      history[t] = true;
    }
  }
}


// Yardımcı: bugünün tarihini 'YYYY-MM-DD' üret
String _todayYmd() {
  final now = DateTime.now();
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  return '${now.year}-$m-$d';
}

String genId() {
  final ts = DateTime.now().microsecondsSinceEpoch;
  final c = (_ctr++ & 0xFFFFF);
  final r = _rnd.nextInt(1 << 32);
  return '$ts-$c-$r';
}
