import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// 7-günlük minimal neon çubuk grafik
class Neon7DayChart extends StatelessWidget {
  final List<bool> checks;           // 7 eleman
  final List<String> weekdayShort;   // 7 eleman
  final double barWidth;

  const Neon7DayChart({
    super.key,
    required this.checks,
    required this.weekdayShort,
    this.barWidth = 14,
  })  : assert(weekdayShort.length == 7),
        assert(checks.length == 7);

  Color _barColor(int i, bool on) {
    const Color start = Color(0xFFFF72E1);
    const Color end   = Color(0xFFA16BFE);
    final t = i / 6.0;
    final mix = Color.lerp(start, end, t)!;
    return on ? mix : mix.withValues(alpha: 0.28);
  }

  @override
  Widget build(BuildContext context) {
    final values = checks.map((e) => e ? 1.0 : 0.0).toList();

    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 1,

        // fl_chart 0.68.0: BU İKİSİ CONST DEĞİL → const KULLANMA
        // ignore: prefer_const_constructors
        gridData: FlGridData(show: false),
        // ignore: prefer_const_constructors
        borderData: FlBorderData(show: false),

        barTouchData: BarTouchData(enabled: false),

        titlesData: FlTitlesData(
          // Bunlar genelde const destekliyor; sende hata vermezse const bırak
          leftTitles:  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= weekdayShort.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    weekdayShort[i],
                    style: const TextStyle(fontSize: 11),
                  ),
                );
              },
            ),
          ),
        ),

        barGroups: List.generate(values.length, (i) {
          final on = checks[i];
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: values[i],
                width: barWidth,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                color: _barColor(i, on),
              ),
            ],
          );
        }),
      ),
      swapAnimationDuration: const Duration(milliseconds: 600),
      swapAnimationCurve: Curves.easeOutCubic,
    );
  }
}
