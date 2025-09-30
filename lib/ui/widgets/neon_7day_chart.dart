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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ——— Palette (dark & light) ———
    // Aktif bar degrade taban/tepe tonları
    final Color onA = isDark
        ? const Color(0xFFB68CFF) // dark: alt ton (plum)
        : const Color(0xFFFFCBA6); // light: alt ton (rich peach)

    final Color onB = isDark
        ? const Color(0xFFFF96E5) // dark: üst ton (magenta/pink)
        : const Color(0xFFFF9FD2); // light: üst ton (peach→pink highlight)

    // Pasif bar şeffaflığı
    final double offAlpha = isDark ? 0.22 : 0.26;

    // Etiket rengi (alt eksen gün kısaltmaları)
    final Color tick = cs.onSurface.withValues(alpha: isDark ? 0.70 : 0.60);
    // (isteğe bağlı) ince grid çizgisi rengi
    final Color guide = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05);

    final values = checks.map((e) => e ? 1.0 : 0.001).toList();

    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 1,

        // Çerçeve/grid sade
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(color: guide, strokeWidth: 1),
          checkToShowHorizontalLine: (value) => value == 0 || value == 1,
        ),
        borderData: FlBorderData(show: false),

        barTouchData: BarTouchData(enabled: false),

        titlesData: FlTitlesData(
          leftTitles:  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= weekdayShort.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    weekdayShort[i],
                    style: TextStyle(fontSize: 11, color: tick, fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),
          ),
        ),

        barGroups: List.generate(values.length, (i) {
          final bool on = checks[i];
          final Color a = on ? onA : onA.withValues(alpha: offAlpha);
          final Color b = on ? onB : onB.withValues(alpha: offAlpha);

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
                // Dikey degrade (alttan üstte)
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [a, b],
                ),
                // fallback: color (gradient desteklemeyen sürüm olursa)
                color: b,
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
