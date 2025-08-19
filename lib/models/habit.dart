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
}

String genId() {
  final ts = DateTime.now().microsecondsSinceEpoch;
  final c = (_ctr++ & 0xFFFFF);
  final r = _rnd.nextInt(1 << 32);
  return '$ts-$c-$r';
}
