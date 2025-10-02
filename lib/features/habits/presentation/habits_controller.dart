import 'package:flutter/foundation.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/data/habits_repository.dart';
import 'package:habit_tracker/core/utils/id_utils.dart';
import 'package:habit_tracker/core/backup/import_service.dart';

class HabitsController extends ChangeNotifier {
  final HabitsRepository repo;
  final List<Habit> _items = [];

  List<Habit> get items => List.unmodifiable(_items);

  HabitsController(this.repo);

  Future<void> init() async {
    final loaded = await repo.load();
    _items
      ..clear()
      ..addAll(loaded);
    notifyListeners();
  }

  Future<void> addHabit(String name) async {
    _items.add(Habit(id: genId(), name: name));
    await repo.save(_items);
    notifyListeners();
  }

  Future<void> renameHabit(Habit h, String newName) async {
    final i = _items.indexWhere((x) => x.id == h.id);
    if (i == -1) return;
    _items[i] = h.copyWith(name: newName);
    await repo.save(_items);
    notifyListeners();
  }

  Future<void> toggleToday(Habit h) async {
    final i = _items.indexWhere((x) => x.id == h.id);
    if (i == -1) return;
    _items[i] = _items[i].toggleTodayImmutable();
    await repo.save(_items);
    notifyListeners();
  }

  Future<void> removeMany(Set<String> ids) async {
    _items.removeWhere((h) => ids.contains(h.id));
    await repo.save(_items);
    notifyListeners();
  }

  // 🔄 Undo için: silinenleri eski index’leriyle geri ekler
  Future<void> insertMany(List<MapEntry<int, Habit>> entries) async {
    entries.sort((a, b) => a.key.compareTo(b.key));
    for (final e in entries) {
      final idx = (e.key >= 0 && e.key <= _items.length) ? e.key : _items.length;
      _items.insert(idx, e.value);
    }
    await repo.save(_items);
    notifyListeners();
  }

Future<ImportResult> importHabits(List<Habit> incoming) async {
  final svc = ImportService();
  final res = svc.mergeInto(_items, incoming);
  await repo.save(_items);
  notifyListeners();
  return res;
}

Future<void> move(int oldIndex, int newIndex) async {
  // Flutter onReorder: newIndex, oldIndex'ten sonra ise bir kaydırma gerekir
  if (newIndex > oldIndex) newIndex -= 1;

  // Sınır kontrolleri (güvenli alan)
  if (oldIndex < 0 || oldIndex >= _items.length) return;
  if (newIndex < 0 || newIndex >= _items.length) return;

  // Değişiklik yoksa yazma/notify yapma
  if (oldIndex == newIndex) return;

  final item = _items.removeAt(oldIndex);
  _items.insert(newIndex, item);

  await repo.save(_items);
  notifyListeners();
}


}
