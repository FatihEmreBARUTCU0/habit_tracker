import 'dart:math';

final _rnd = Random();
int _ctr = 0;

class Habit {
  final String id;
  String name;
  bool isDone;

  Habit({
    required this.id,
    required this.name,
    this.isDone = false,
  });

  // JSON için: nesneden Map'e
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isDone': isDone,
    };
  }

  // JSON için: Map'ten nesneye
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      isDone: map['isDone'] as bool? ?? false,
    );
  }
}


String genId() {
  final ts = DateTime.now().microsecondsSinceEpoch;
  final c = (_ctr++ & 0xFFFFF);
  final r = _rnd.nextInt(1 << 32);
  return '$ts-$c-$r';
}
