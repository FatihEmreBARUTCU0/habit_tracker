import 'dart:math';

final _rnd = Random();
int _ctr = 0;

class Habit {
  final String id;
  String name;
  bool isDone;

  // NEW: Bugünlük işaret bilgisini hesaplarken kullanacağımız alan (YYYY-MM-DD)
  String lastCheckedYmd;

  Habit({
    required this.id,
    required this.name,
    this.isDone = false,
    this.lastCheckedYmd = '', // NEW: hiç işaretlenmediyse boş kalsın
  });

  // NEW: Bugün işaretli mi? (gün değişince otomatik false olur)
  bool get isCheckedToday => lastCheckedYmd == _todayYmd();

  // JSON için: nesneden Map'e
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isDone': isDone,
      'lastCheckedYmd': lastCheckedYmd, // NEW
    };
  }

  // JSON için: Map'ten nesneye
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      isDone: map['isDone'] as bool? ?? false,
      lastCheckedYmd: map['lastCheckedYmd'] as String? ?? '', // NEW
    );
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
