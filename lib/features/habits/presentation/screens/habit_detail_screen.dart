import 'package:flutter/material.dart';
import '../../domain/habit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:habit_tracker/l10n/generated/app_localizations.dart';

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
  String _ymd(DateTime d) {
    String two(int n) => n < 10 ? '0$n' : '$n';
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  // history -> 7 elemanlı 1/0 listesi
  List<double> _weeklyValues(Habit h) {
    final days = _last7Days();
    return days.map((d) {
      final key = _ymd(d);
      final checked = h.history[key] == true;
      return checked ? 1.0 : 0.0;
    }).toList();
  }

  // TR kısa gün etiketleri (şimdilik TR sabit; istersek sonra locale’e göre yaparız)
  String _weekdayTrShort(DateTime d) {
    // DateTime.weekday: 1=Mon ... 7=Sun
    const names = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return names[d.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final last7 = _lastNDatesYmd(7); // bugün dahil geriye 6 gün = 7 gün
    final checks =
        last7.map((d) => widget.habit.history[d] == true).toList();
    final doneCount = checks.where((x) => x).length;
    final percent = (doneCount / 7.0);
    final percentInt = (percent * 100).round();

    final values = _weeklyValues(widget.habit); // [1.0/0.0], uzunluk 7
    final days = _last7Days(); // DateTime listesi, uzunluk 7

    return Scaffold(
      appBar: AppBar(
        title: Text(l.detailTitleFor(widget.habit.name)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 7 günlük şerit (soldan sağa: eski -> yeni)
            Text(l.last7Days, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: last7.map((date) {
                final done = widget.habit.history[date] == true;
                return _DayBadge(date: date, done: done);
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Yüzde bilgi
            Text(
              l.successLabel(doneCount, percentInt),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),

            // GRAFİK: Son 7 gün bar chart
            Container(
              height: 200,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: BarChart(
                BarChartData(
                  maxY: 1,
                  minY: 0,
                  gridData: const FlGridData(show: false),   // ← const
                  borderData:  FlBorderData(show: false), // ← const
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles( // ← const
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles( // ← const
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles( // ← const
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i < 0 || i >= days.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              _weekdayTrShort(days[i]), // Pzt/Sal/Çar...
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(values.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: values[i], // 0.0 veya 1.0
                          width: 14,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            const Spacer(),

            // Bugün Toggle butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(
                  widget.habit.isCheckedToday
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                ),
                label: Text(
                  widget.habit.isCheckedToday
                      ? l.toggleTodayOff
                      : l.toggleTodayOn,
                ),
                onPressed: () {
                  setState(() {
                    widget.habit.toggleToday();
                  });
                  widget.onPersist?.call(); // kalıcı kaydet (varsa)
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayBadge extends StatelessWidget {
  final String date; // YYYY-MM-DD
  final bool done;

  const _DayBadge({required this.date, required this.done});

  @override
  Widget build(BuildContext context) {
    // Görsel olarak sadece gün numarasını gösterelim
    final day = date.substring(8, 10);
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          child: done
              ? const Icon(Icons.check, size: 20)
              : const Icon(Icons.remove, size: 20),
        ),
        const SizedBox(height: 6),
        Text(day, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

/// Bugün dahil geriye [n] günün YYYY-MM-DD listesi (soldan sağa eski -> yeni)
List<String> _lastNDatesYmd(int n) {
  final now = DateTime.now();
  final dates = <String>[];
  for (int i = n - 1; i >= 0; i--) {
    final d = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: i));
    dates.add(_fmtYmd(d));
  }
  return dates;
}

String _fmtYmd(DateTime d) {
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$m-$day';
}
