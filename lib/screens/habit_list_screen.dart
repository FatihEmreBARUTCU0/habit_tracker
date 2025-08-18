// lib/screens/habit_list_screen.dart
import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/screens/add_habit_screen.dart';
import 'package:habit_tracker/screens/edit_habit_screen.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  final List<Habit> _habits = <Habit>[
    Habit(id: genId(), name: 'Su içmek 💧'),
    Habit(id: genId(), name: 'Kitap okumak 📚'),
    Habit(id: genId(), name: 'Spor yapmak 🏃‍♂️'),
  ];

  // --- Seçim modu durumu ---
  bool _selectionMode = false;
  final Set<String> _selected = <String>{};

  void _enterSelection(Habit h) {
    setState(() {
      _selectionMode = true;
      _selected.add(h.id);
    });
  }

  void _toggleSelect(Habit h) {
    setState(() {
      if (_selected.contains(h.id)) {
        _selected.remove(h.id);
        if (_selected.isEmpty) _selectionMode = false; // hiç kalmadıysa moddan çık
      } else {
        _selected.add(h.id);
      }
    });
  }

  void _exitSelection() {
    setState(() {
      _selectionMode = false;
      _selected.clear();
    });
  }

  // --- Düzenleme ekranına git ---
  Future<void> _goToEdit(Habit habit) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditHabitScreen(initialName: habit.name),
      ),
    );

    if (!mounted) return;

    if (result is String &&
        result.trim().isNotEmpty &&
        result.trim() != habit.name.trim()) {
      setState(() => habit.name = result.trim());
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(content: Text('Güncellendi.')));
    }
  }

  // --- Toplu sil: seçim modundaki öğeleri sil + Undo ---
  void _removeSelectedWithUndo() {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(content: Text('Seçili öğe yok')));
      return;
    }

    final removed = <Map<String, dynamic>>[];
    for (int i = 0; i < _habits.length; i++) {
      if (_selected.contains(_habits[i].id)) {
        removed.add({'item': _habits[i], 'index': i});
      }
    }

    setState(() {
      _habits.removeWhere((h) => _selected.contains(h.id));
      _selectionMode = false;
      _selected.clear();
    });

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('${removed.length} öğe silindi'),
          action: SnackBarAction(
            label: 'Geri Al',
            onPressed: () {
              setState(() {
                removed.sort((a, b) => (a['index'] as int).compareTo(b['index'] as int));
                for (final r in removed) {
                  final idx = r['index'] as int;
                  final item = r['item'] as Habit;
                  final safeIndex =
                      (idx >= 0 && idx <= _habits.length) ? idx : _habits.length;
                  _habits.insert(safeIndex, item);
                }
              });
            },
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasItems = _habits.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: _selectionMode
            ? IconButton(
                tooltip: 'İptal',
                icon: const Icon(Icons.close),
                onPressed: _exitSelection,
              )
            : null,
        title: Text(_selectionMode
            ? '${_selected.length} seçildi'
            : 'Alışkanlıklarım'),
        centerTitle: true,
        actions: [
          if (_selectionMode)
            IconButton(
              tooltip: 'Seçilenleri Sil',
              icon: const Icon(Icons.delete_outline),
              onPressed: _removeSelectedWithUndo,
            )
          else
            const SizedBox.shrink(), // normal modda sağ taraf boş kalsın
        ],
      ),

      body: hasItems
          ? ListView.separated(
              itemCount: _habits.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final habit = _habits[index];
                final isSelected = _selected.contains(habit.id);

                // List tile (tek yerde tanımlayalım)
                final tile = ListTile(
                  onLongPress: () => _enterSelection(habit),
                  onTap: _selectionMode ? () => _toggleSelect(habit) : null,
                  leading: _selectionMode
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (_) => _toggleSelect(habit),
                        )
                      : null,
                  title: Text(habit.name),
                  trailing: IconButton(
                    tooltip: 'Düzenle',
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _goToEdit(habit),
                  ),
                  dense: true,
                );

                // Seçim modunda swipe kapalı; normal modda açık
                if (_selectionMode) {
                  return tile;
                }

                return Dismissible(
                  key: ValueKey(habit.id),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    color: scheme.errorContainer,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(Icons.delete_outline),
                  ),
                  secondaryBackground: Container(
                    color: scheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(Icons.delete_outline),
                  ),
                  onDismissed: (_) {
                    final removedId = habit.id;
                    final removedName = habit.name;
                    final removedIndex = index;
                    final removedItem = habit;

                    setState(() {
                      _habits.removeWhere((h) => h.id == removedId);
                    });

                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('"$removedName" silindi'),
                          action: SnackBarAction(
                            label: 'Geri Al',
                            onPressed: () {
                              setState(() {
                                final safeIndex = (removedIndex >= 0 && removedIndex <= _habits.length)
                                    ? removedIndex
                                    : 0;
                                _habits.insert(safeIndex, removedItem);
                              });
                            },
                          ),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                  },
                  child: tile,
                );
              },
            )
          : const _EmptyState(),

      // Seçim modundayken FAB gizli
      floatingActionButton: _selectionMode
          ? null
          : FloatingActionButton.extended(
              tooltip: 'Alışkanlık Ekle',
              icon: const Icon(Icons.add),
              label: const Text('Ekle'),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddHabitScreen()),
                );

                if (!mounted) return;

                if (result is String && result.trim().isNotEmpty) {
                  setState(() {
                    _habits.add(Habit(id: genId(), name: result.trim()));
                  });
                }
              },
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Henüz alışkanlık yok.\nSağ alttaki + ile ekleyebilirsin.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
