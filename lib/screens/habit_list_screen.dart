// lib/screens/habit_list_screen.dart
import 'package:flutter/foundation.dart'; // debugPrint, kDebugMode
import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/screens/add_habit_screen.dart';
import 'package:habit_tracker/screens/edit_habit_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // JSON encode/decode için
import 'package:habit_tracker/screens/habit_detail_screen.dart';
import 'package:habit_tracker/screens/settings_screen.dart';
import 'package:habit_tracker/l10n/generated/app_localizations.dart';



// === PERSISTENCE HELPERS ===
const _prefsKey = 'habits_v1';

String _encodeHabits(List<Habit> habits) {
  final list = habits.map((h) => h.toMap()).toList();
  return jsonEncode(list);
}

List<Habit> _decodeHabits(String jsonStr) {
  final raw = jsonDecode(jsonStr) as List<dynamic>;
  return raw
      .map((e) => Habit.fromMap(Map<String, dynamic>.from(e as Map)))
      .toList();
}
// === /PERSISTENCE HELPERS ===

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

  // ⬇️ Kalıcı depolama: yükle & kaydet
  Future<void> _loadHabits() async {
    if (kDebugMode) debugPrint('[load] called');
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_prefsKey);
    if (jsonStr == null) {
      if (kDebugMode) debugPrint('[load] nothing saved');
      return; // ilk çalıştırmada veri olmayabilir
    }
    final loaded = _decodeHabits(jsonStr);
    if (kDebugMode) debugPrint('[load] loaded ${loaded.length} items');
    setState(() {
      _habits
        ..clear()
        ..addAll(loaded);
    });
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _encodeHabits(_habits));
    if (kDebugMode) debugPrint('[save] wrote ${_habits.length} items');
  }



void _toggleToday(Habit habit) {
  setState(() {
    habit.toggleToday(); // modeldeki history tabanlı toggle
  });
  _saveHabits(); // kalıcı depolama
}




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

      // önce kullanıcıya geri bildirim ver (context burada güvenli)
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
       ..showSnackBar(
  SnackBar(content: Text(AppLocalizations.of(context)!.updated)),
);


      // sonra kaydet (buradan sonra context kullanılmıyor, uyarı yok)
      await _saveHabits();
    }
  }

  // --- Toplu sil: seçim modundaki öğeleri sil + Undo ---
  void _removeSelectedWithUndo() async {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.noSelection)));
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

    await _saveHabits(); // async gap
    if (!mounted) return; // context guard

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.itemsDeleted(removed.length)),

          action: SnackBarAction(
            label: AppLocalizations.of(context)!.undo,

            onPressed: () {
              setState(() {
                removed.sort(
                  (a, b) => (a['index'] as int).compareTo(b['index'] as int),
                );
                for (final r in removed) {
                  final idx = r['index'] as int;
                  final item = r['item'] as Habit;
                  final safeIndex =
                      (idx >= 0 && idx <= _habits.length) ? idx : _habits.length;
                  _habits.insert(safeIndex, item);
                }
              });
              _saveHabits(); // await etmiyoruz; uyarı yok
            },
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    _loadHabits(); // uygulama açılır açılmaz kayıtlı veriyi getir
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final hasItems = _habits.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: _selectionMode
            ? IconButton(
                tooltip: l.cancel,
                icon: const Icon(Icons.close),
                onPressed: _exitSelection,
              )
            : null,
        title: Text(_selectionMode ? l.selectedCount(_selected.length) : l.habitListTitle),
        centerTitle: true,
       actions: [
  if (_selectionMode)
    IconButton(
       tooltip: l.deleteSelected,
      icon: const Icon(Icons.delete_outline),
      onPressed: _removeSelectedWithUndo,
    )
  else ...[
    // ⚙️ Ayarlar ikonu
    IconButton(
      tooltip: l.settings,
      icon: const Icon(Icons.settings),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        );
      },
    ),
  ],
],

      ),
      body: hasItems
          ? ListView.separated(
              itemCount: _habits.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final habit = _habits[index];
                final isSelected = _selected.contains(habit.id);

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
                  trailing: _selectionMode
    ? const SizedBox.shrink()
    : Row(
      
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: habit.isCheckedToday ? l.todayUncheck : l.todayCheck,
            icon: Icon(
              habit.isCheckedToday
                  ? Icons.check_circle
                  : Icons.circle_outlined,
            ),
            onPressed: () => _toggleToday(habit),
          ),
          IconButton(
            tooltip: l.edit,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _goToEdit(habit),
          ),
           const SizedBox(width: 4),
    TextButton.icon(
      icon: const Icon(Icons.insights_outlined),
      label: Text(l.detail),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HabitDetailScreen(
              habit: habit,
              onPersist: _saveHabits,
            ),
          ),
        );
        if (!mounted) return;
        setState(() {}); // Detaydan dönünce UI yenilensin
      },
    ),
  ],
),
       

                  dense: true,
                );

                if (_selectionMode) return tile; // seçim modunda swipe kapalı

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

                    _saveHabits(); // await etmiyoruz; context güvenli

                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(l.itemDeleted(removedName)),
                          action: SnackBarAction(
                            label: l.undo,
                            onPressed: () {
                              setState(() {
                                final safeIndex =
                                    (removedIndex >= 0 && removedIndex <= _habits.length)
                                        ? removedIndex
                                        : 0;
                                _habits.insert(safeIndex, removedItem);
                              });
                              _saveHabits();
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
      floatingActionButton: _selectionMode
          ? null
          : FloatingActionButton.extended(
              tooltip: l.addHabit,
              icon: const Icon(Icons.add),
              label: Text(l.add),
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
                  _saveHabits();
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
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          l.noHabitsHint,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

