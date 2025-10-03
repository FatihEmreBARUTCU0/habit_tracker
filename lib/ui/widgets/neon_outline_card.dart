import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/widgets/glass_card.dart';
import 'package:habit_tracker/ui/theme/neon_theme.dart';

class NeonOutlineCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final EdgeInsetsGeometry margin;

  final bool coolHint;
  final bool glow;
  final double? blurSigma;
  final bool useBlur; // performans anahtarı

  const NeonOutlineCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.radius = 20,
    this.margin = EdgeInsets.zero,
    this.coolHint = false,
    this.glow = true,
    this.blurSigma,
    this.useBlur = true, // eski davranış (blur açık)
  });

  // Önerilen paletler
  static const List<Color> _softTrio = <Color>[
    Color(0xFFF7BFE8), // blush
    Color(0xFFB9A7FF), // lilac
    Color(0xFFFF9CF0), // pink
  ];

  static const List<Color> _skyTrio = <Color>[
    Color(0xFFCADBFF), // sky-lilac
    Color(0xFFB9A7FF), // lilac
    Color(0xFFFF9CF0), // pink
  ];

  @override
  Widget build(BuildContext context) {
    final n = context.neon;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Tema bazlı dış ışıma
    final Color lightShadow = const Color(0xFFFFA8C2).withValues(alpha: 0.12);
    final Color darkShadow = n.glow;

    // Blur kapalıysa gölgeyi kıs (fast-path)
    final double blurRadius = useBlur ? (isDark ? 28 : 18) : (isDark ? 18 : 12);
    final double spreadRadius = useBlur ? (isDark ? 0.5 : 0.2) : (isDark ? 0.3 : 0.1);
    final Offset offset =
        useBlur ? (isDark ? const Offset(0, 10) : const Offset(0, 8)) : (isDark ? const Offset(0, 8) : const Offset(0, 6));

    final List<Color> gradientColors = coolHint ? _skyTrio : _softTrio;

    return RepaintBoundary(
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius + 2),
          boxShadow: glow
              ? [
                  BoxShadow(
                    color: isDark ? darkShadow : lightShadow,
                    blurRadius: blurRadius,
                    spreadRadius: spreadRadius,
                    offset: offset,
                  ),
                ]
              : const [],
          // DİKKAT: const kullanmıyoruz; colors dinamik
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.55, 1.0],
            colors: gradientColors,
          ),
        ),
        // 1–2 px neon “stroke”
        padding: EdgeInsets.all(useBlur ? 1.2 : 1.0),
        child: GlassCard(
          padding: padding,
          radius: radius,
          blurSigma: blurSigma,
          useBlur: useBlur, // cam blur aç/kapat
          child: child,
        ),
      ),
    );
  }
}
