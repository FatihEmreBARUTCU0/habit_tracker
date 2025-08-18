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

String genId() => DateTime.now().microsecondsSinceEpoch.toString();
