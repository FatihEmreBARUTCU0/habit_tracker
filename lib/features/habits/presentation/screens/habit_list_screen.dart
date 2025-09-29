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
import 'package:habit_tracker/ui/widgets/neon_fab.dart';
import 'package:habit_tracker/ui/widgets/neon_app_bar.dart';
// ✨
import 'package:habit_tracker/ui/widgets/neon_scaffold.dart';
import 'package:habit_tracker/ui/widgets/neon_habit_tile.dart';
import 'package:habit_tracker/ui/theme/neon_theme.dart';

// ✨ NeonButton & GlassCard
import 'package:habit_tracker/ui/widgets/neon_button.dart';
import 'package:habit_tracker/ui/widgets/glass_card.dart';

// ✅ HAPTIC için ekle
import 'package:flutter/services.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  bool _selectionMode = false;
  final Set<String> _selected = <String>{};

  // ✨ Filtre sekmesi: 0=Tümü, 1=Aktif (bugün işaretlenmemiş), 2=Bugün ✓
  int _tab = 0;

  // ✨ Sadece ekranda filtre uygular; veriyi değiştirmez
  List<Habit> _applyFilter(List<Habit> items) {
    switch (_tab) {
      case 1:
        // Aktif: bugün işaretlenmemişler
        return items.where((h) => !h.isCheckedToday).toList();
      case 2:
        // Bugün ✓: bugün işaretliler
        return items.where((h) => h.isCheckedToday).toList();
      default:
        return items;
    }
  }

  Widget _dismissBg(BuildContext context, {required bool toLeft}) {
    final n = context.neon; // NeonTheme
    return Container(
      decoration: BoxDecoration(gradient: n.gradPeachCoral), // 🔥 neon uyumlu
      alignment: toLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
    );
  }

  // ✅ HAPTIC: seçim moduna girerken hafif titreşim
  void _enterSelection(Habit h) {
    HapticFeedback.lightImpact(); // ✨
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
              await c.insertMany(removed);
            },
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  void _onTileLongPress(Habit h) {
    if (_selectionMode) {
      _toggleSelect(h); // seçim modundayken: seç/deseç
    } else {
      _enterSelection(h); // seçim modunda değilken: SEÇİM MODUNA GİR (haptic’li)
    }
  }

  void _showTileActions(Habit h) {
    final l = AppLocalizations.of(context);
    final c = context.read<HabitsController>();
    final messenger = ScaffoldMessenger.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: GlassCard(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Düzenle
              NeonButton(
                text: l.edit,
                onPressed: () async {
                  Navigator.pop(context);
                  await _goToEdit(context, h);
                },
              ),
              const SizedBox(height: 8),

              // Bugün ✓ / Geri Al
              NeonButton(
                text: h.isCheckedToday ? l.todayUncheck : l.todayCheck,
                onPressed: () async {
                  Navigator.pop(context);
                  await c.toggleToday(h);
                },
              ),
              const SizedBox(height: 8),

              // Detay
              NeonButton(
                text: l.detail,
                onPressed: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => HabitDetailScreen(habit: h)),
                  );
                },
              ),
              const SizedBox(height: 8),

              // Sil (tek öğe) + Geri Al
              OutlinedButton.icon(
                icon: const Icon(Icons.delete_forever_rounded),
                label: Text(l.deleteOne),
                onPressed: () async {
                  Navigator.pop(context);

                  // undo için index’i yakala
                  final idx = c.items.indexWhere((x) => x.id == h.id);
                  if (idx == -1) return;

                  await c.removeMany({h.id});

                  messenger
                    ..clearSnackBars()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(l.itemDeleted(h.name)),
                        action: SnackBarAction(
                          label: l.undo,
                          onPressed: () {
                            c.insertMany([MapEntry(idx, h)]);
                          },
                        ),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final c = context.watch<HabitsController>();
    final habits = c.items;
    final hasItems = habits.isNotEmpty;
    final n = context.neon;
    // ✨ Filtre uygulanmış liste (UI seviyesinde)
    final filtered = _applyFilter(habits);

    return NeonScaffold(
      appBar: NeonAppBar(
        title: Text(
            _selectionMode ? l.selectedCount(_selected.length) : l.habitListTitle),
        leading: _selectionMode
            ? IconButton(
                tooltip: l.cancel,
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: _exitSelection,
              )
            : null,
        actions: [
          if (_selectionMode)
            IconButton(
              tooltip: l.deleteSelected,
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: () => _removeSelectedWithUndo(context),
            )
          else
            IconButton(
              tooltip: l.settings,
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
        ],
      ),

      // ✨ Header + Segmented + Liste
      body: Column(
        children: [
          // ✨ Gradient başlık şeridi (metinsiz ince bant)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              gradient: n.gradPinkViolet, // ✅ sadece gradient
            ),
            child: const SafeArea(
              bottom: false,
              child: SizedBox(height: 8), // ince şerit
            ),
          ),

          // ✨ Segmented filter (GlassCard içinde)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: SegmentedButton<int>(
                segments: [
                  ButtonSegment(value: 0, label: Text(l.filterAll)),
                  ButtonSegment(value: 1, label: Text(l.filterActive)),
                  ButtonSegment(value: 2, label: Text(l.filterToday)),
                ],
                selected: {_tab},
                onSelectionChanged: (s) => setState(() => _tab = s.first),
                showSelectedIcon: false,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // ✨ Liste (filtre uygulanmış) veya boş durum
          Expanded(
            child: hasItems
                ? ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final habit = filtered[index];
                      final isSelected = _selected.contains(habit.id);

                      final tile = NeonHabitTile(
                        habit: habit,
                        checkedToday: habit.isCheckedToday,
                        // ✅ HAPTIC: ✓ tıklandığında hafif seçim hissi
                        onToggleToday: () {
                          HapticFeedback.selectionClick(); // ✨
                          c.toggleToday(habit);
                        },
                        onEdit: () => _goToEdit(context, habit),
                        onDetail: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  HabitDetailScreen(habit: habit),
                            ),
                          );
                          if (!mounted) return;
                        },
                        selectionMode: _selectionMode,
                        selected: isSelected,
                        onTapSelect: () => _toggleSelect(habit),
                        onLongPress: () => _onTileLongPress(habit),
                        onMore:
                            _selectionMode ? null : () => _showTileActions(habit),
                      );

                      if (_selectionMode) return tile;

                      return Dismissible(
                        key: ValueKey(habit.id),
                        direction: DismissDirection.horizontal,
                        background: _dismissBg(context, toLeft: true),
                        secondaryBackground: _dismissBg(context, toLeft: false),
                        onDismissed: (_) => c.removeMany({habit.id}),
                        child: tile,
                      );
                    },
                  )
                : const _EmptyState(),
          ),
        ],
      ),

      // 7) FAB metni kısa ve sabit: l.add (zaten böyleydi)
      floating: _selectionMode
          ? null
          : NeonFab.extended(
              icon: const Icon(Icons.add, color: Colors.white),
              label: l.add, // kısa ve sabit
              onPressed: () async {
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
                    (h) =>
                        h.name.trim().toLowerCase() ==
                        newName.toLowerCase(),
                  );
                  if (exists) {
                    messenger.clearSnackBars();
                    messenger.showSnackBar(
                        SnackBar(content: Text(l.duplicateName)));
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
            // ✨ Cam efektli büyük ikon + metin
            GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.inbox_outlined, size: 72),
                  const SizedBox(height: 12),
                  Text(l.noHabitsHint, textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ✨ NeonButton ile birincil CTA
            NeonButton(
              text: l.addHabit,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddHabitScreen()),
                );
                if (result is String && result.trim().isNotEmpty) {
                  final name = result.trim();
                  final exists = c.items.any(
                    (h) =>
                        h.name.trim().toLowerCase() ==
                        name.toLowerCase(),
                  );
                  if (exists) {
                    messenger
                      ..clearSnackBars()
                      ..showSnackBar(
                          SnackBar(content: Text(l.duplicateName)));
                    return;
                  }
                  await c.addHabit(name);
                }
              },
            ),
            const SizedBox(height: 10),

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
                        ..showSnackBar(
                            SnackBar(content: Text(l.importNothing)));
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
                      ..showSnackBar(
                          SnackBar(content: Text(l.invalidBackupFile)));
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
