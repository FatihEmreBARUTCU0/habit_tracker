import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/presentation/screens/add_habit_screen.dart';
import 'package:habit_tracker/features/habits/presentation/screens/edit_habit_screen.dart';
import 'package:habit_tracker/features/habits/presentation/screens/habit_detail_screen.dart';
import 'package:habit_tracker/features/settings/presentation/screens/settings_screen.dart';
import 'package:habit_tracker/l10n/generated/app_localizations.dart';
import 'package:habit_tracker/features/habits/presentation/habits_controller.dart';
import 'package:habit_tracker/core/backup/import_service.dart';


class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
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
        if (_selected.isEmpty) _selectionMode = false;
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

  Future<void> _goToEdit(BuildContext context, Habit habit) async {
    // PRE-AWAIT: context'ten ihtiyacın olanları al
    final l = AppLocalizations.of(context);
    final c = context.read<HabitsController>();
    final messenger = ScaffoldMessenger.of(context);

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
      final newName = result.trim();
      final exists = c.items.any((h) =>
          h.id != habit.id &&
          h.name.trim().toLowerCase() == newName.toLowerCase());

      if (exists) {
        messenger.clearSnackBars();
        messenger.showSnackBar(SnackBar(content: Text(l.duplicateName)));
        return;
      }

      await c.renameHabit(habit, newName);

      if (!mounted) return;
      messenger.clearSnackBars();
      messenger.showSnackBar(SnackBar(content: Text(l.updated)));
    }
  }

void _removeSelectedWithUndo(BuildContext context) async {
  final c = context.read<HabitsController>();
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);

  if (_selected.isEmpty) {
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(l.noSelection)));
    return;
  }

  // Silinecekleri (item + index) topla
  final removed = <MapEntry<int, Habit>>[];
  for (int i = 0; i < c.items.length; i++) {
    final h = c.items[i];
    if (_selected.contains(h.id)) {
      removed.add(MapEntry(i, h));
    }
  }

  setState(() {
    _selectionMode = false;
    _selected.clear();
  });

  await c.removeMany(removed.map((e) => e.value.id).toSet());

  if (!mounted) return;

  messenger
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(l.itemsDeleted(removed.length)),
        action: SnackBarAction(
          label: l.undo,
          onPressed: () async {
            await c.insertMany(removed); // 🔄 geri yükle
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
}


  

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final c = context.watch<HabitsController>();
    final habits = c.items;
    final hasItems = habits.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: _selectionMode
            ? IconButton(
                tooltip: l.cancel,
                icon: const Icon(Icons.close),
                onPressed: _exitSelection,
              )
            : null,
        title: Text(_selectionMode
            ? l.selectedCount(_selected.length)
            : l.habitListTitle),
        centerTitle: true,
        actions: [
          if (_selectionMode)
            IconButton(
              tooltip: l.deleteSelected,
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _removeSelectedWithUndo(context),
            )
          else
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
      ),
      body: hasItems
          ? ListView.separated(
              itemCount: habits.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final habit = habits[index];
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
                              tooltip: habit.isCheckedToday
                                  ? l.todayUncheck
                                  : l.todayCheck,
                              icon: Icon(
                                habit.isCheckedToday
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                              ),
                              onPressed: () => c.toggleToday(habit),
                            ),
                            IconButton(
                              tooltip: l.edit,
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _goToEdit(context, habit),
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
                                      onPersist: () => c.init(),
                                    ),
                                  ),
                                );
                                // await sonrası context kullanmıyoruz; istersen güvenlik için:
                                if (!mounted) return;
                              },
                            ),
                          ],
                        ),
                  dense: true,
                );

                if (_selectionMode) return tile;

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
                  onDismissed: (_) => c.removeMany({habit.id}),
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
                // PRE-AWAIT: context'ten ihtiyaçlar
                final l = AppLocalizations.of(context);
                final c = context.read<HabitsController>();
                final messenger = ScaffoldMessenger.of(context);

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddHabitScreen()),
                );

                if (!mounted) return;

                if (result is String && result.trim().isNotEmpty) {
                  final newName = result.trim();
                  final exists = c.items.any(
                    (h) => h.name.trim().toLowerCase() == newName.toLowerCase(),
                  );
                  if (exists) {
                    messenger.clearSnackBars();
                    messenger.showSnackBar(
                      SnackBar(content: Text(l.duplicateName)),
                    );
                    return;
                  }
                  await c.addHabit(newName);
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
    final l = AppLocalizations.of(context);
    final c = context.read<HabitsController>();
    final messenger = ScaffoldMessenger.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 64),
            const SizedBox(height: 12),
            Text(l.noHabitsHint, textAlign: TextAlign.center),
            const SizedBox(height: 16),

            // ➕ Alışkanlık Ekle
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(l.addHabit),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddHabitScreen()),
                  );
                  if (result is String && result.trim().isNotEmpty) {
                    final name = result.trim();
                    final exists = c.items.any(
                      (h) => h.name.trim().toLowerCase() == name.toLowerCase(),
                    );
                    if (exists) {
                      messenger
                        ..clearSnackBars()
                        ..showSnackBar(SnackBar(content: Text(l.duplicateName)));
                      return;
                    }
                    await c.addHabit(name);
                  }
                },
              ),
            ),
            const SizedBox(height: 8),

            // 📥 JSON’dan İçe Aktar
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.file_upload_outlined),
                label: Text(l.importJsonFile),
                onPressed: () async {
                  try {
                    final incoming = await ImportService().pickAndParse();

                    if (incoming.isEmpty) {
                      messenger
                        ..clearSnackBars()
                        ..showSnackBar(SnackBar(content: Text(l.importNothing)));
                      return;
                    }

                    final res = await c.importHabits(incoming);

                    messenger
                      ..clearSnackBars()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            (res.added + res.merged) == 0
                              ? l.importNothing
                              : l.importSuccess(res.added + res.merged),
                          ),
                        ),
                      );
                  } catch (_) {
                    messenger
                      ..clearSnackBars()
                      ..showSnackBar(SnackBar(content: Text(l.invalidBackupFile)));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

