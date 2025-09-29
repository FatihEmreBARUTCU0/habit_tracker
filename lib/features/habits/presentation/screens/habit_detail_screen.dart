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
  // 0..6 indeksli 7 tarih: today-6 .. today
  List<DateTime> _last7Days() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final d = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - i));
      return d;
    });
  }

  // YYYY-MM-DD formatı


  // history -> 7 elemanlı 1/0 listesi
  

 String _weekdayShort(BuildContext context, DateTime d) {
  final locale = AppLocalizations.of(context).localeName; // örn: 'tr', 'en'
  return DateFormat.E(locale).format(d); // Pzt / Mon gibi
}


  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

   final last7 = dtu.lastNDatesYmd(7); // bugün dahil geriye 6 gün = 7 gün
    final checks = last7.map((d) => widget.habit.history[d] == true).toList();
        
    final doneCount = checks.where((x) => x).length;
    final percent = (doneCount / 7.0);
    final percentInt = (percent * 100).round();

   

    return NeonScaffold(
  appBar: NeonAppBar(title: Text(l.detailTitleFor(widget.habit.name)),
   leading: const BackButton(color: Colors.white),
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
              
              const SizedBox(height: 12),
              SizedBox(height: 180, child: Neon7DayChart(
                 key: ValueKey(widget.habit.history.length),
                checks: checks,
               weekdayShort: _last7Days().map((d)=>_weekdayShort(context, d)).toList(),
              )),
              const SizedBox(height: 8),
              Text(l.successLabel(doneCount, percentInt)),
            ],
          ),
        ),
        const Spacer(),
        GlassCard(
          padding: const EdgeInsets.all(12),
          child: NeonButton(
            text: widget.habit.isCheckedToday ? l.toggleTodayOff : l.toggleTodayOn,
            onPressed: () async {
               final c = context.read<HabitsController>();
          await c.toggleToday(widget.habit); 
          if (!mounted) return;
          setState(() {});   
            },
          ),
        ),
      ],
    ),
  ),
);

  }
}



/// Bugün dahil geriye [n] günün YYYY-MM-DD listesi (soldan sağa eski -> yeni)

