// lib/features/habits/presentation/screens/habit_detail_screen.dart
import 'package:flutter/material.dart';
import '../../domain/habit.dart';
import 'package:habit_tracker/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:habit_tracker/ui/widgets/neon_7day_chart.dart';
import 'package:habit_tracker/ui/widgets/neon_scaffold.dart';
import 'package:habit_tracker/ui/widgets/neon_app_bar.dart';
import 'package:habit_tracker/ui/widgets/glass_card.dart';
import 'package:habit_tracker/ui/widgets/neon_button.dart';
import 'package:habit_tracker/core/utils/date_utils.dart' as dtu;
import 'package:provider/provider.dart';
import 'package:habit_tracker/features/habits/presentation/habits_controller.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;
  final VoidCallback? onPersist;

  const HabitDetailScreen({
    super.key,
    required this.habit,
    this.onPersist,
  });

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  String _weekdayShort(BuildContext context, DateTime d) {
    final locale = AppLocalizations.of(context).localeName; // 'tr', 'en', ...
    return DateFormat.E(locale).format(d); // Pzt / Mon gibi
  }

  @override
  Widget build(BuildContext context) {
    // 👇 Güncel habit'i store'dan izle (toggle sonrası anında rebuild)
    final habit = context
        .watch<HabitsController>()
        .items
        .firstWhere(
          (h) => h.id == widget.habit.id,
          orElse: () => widget.habit,
        );

    final l = AppLocalizations.of(context);

    // Günün başını baz al (00:00)
    final now = DateTime.now();
    final today00 = DateTime(now.year, now.month, now.day);

    // Tek kaynak: 7 gün (eski -> yeni)
    final last7Dates =
        List.generate(7, (i) => today00.subtract(Duration(days: 6 - i)));

    // History: 'YYYY-MM-DD' key'leri ile kontrol
    final checks = last7Dates
        .map((d) => habit.history[dtu.ymdFormat(d)] == true)
        .toList();

    // Grafikte gösterilecek kısaltmalar
    final weekdayShort =
        last7Dates.map((d) => _weekdayShort(context, d)).toList();

    final doneCount = checks.where((x) => x).length;
    final percent = (doneCount / 7.0);
    final percentInt = (percent * 100).round();

    // 🔢 Seriler
    final currentNearest = dtu.currentStreakNearest(habit.history);
    final bestEver = dtu.bestStreak(habit.history);

    return NeonScaffold(
      appBar: NeonAppBar(
        title: Text(l.detailTitleFor(habit.name)),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.last7Days, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: Neon7DayChart(
                      checks: checks,
                      weekdayShort: weekdayShort,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(l.successLabel(doneCount, percentInt)),
                  const SizedBox(height: 4),
                  // 🔥 İki farklı seri bilgisi
                  Text(l.streakCurrent(currentNearest)),
                  const SizedBox(height: 2),
                  Text(l.streakBest(bestEver)),
                ],
              ),
            ),
            const Spacer(),
            GlassCard(
              padding: const EdgeInsets.all(12),
              child: NeonButton(
                text: habit.isCheckedToday ? l.toggleTodayOff : l.toggleTodayOn,
                onPressed: () async {
                  final c = context.read<HabitsController>();
                  await c.toggleToday(habit);

                  // Üst katmana "persist" sinyali gönder (opsiyonel)
                  widget.onPersist?.call();

                  // setState gerek yok; watch() tetikleyecek
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
