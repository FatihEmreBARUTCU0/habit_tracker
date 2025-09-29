import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/widgets/glass_card.dart';
import 'package:habit_tracker/ui/theme/neon_theme.dart';

class NeonOutlineCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final EdgeInsetsGeometry margin;

  const NeonOutlineCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.radius = 20,
    this.margin = const EdgeInsets.all(0), // ✅ margin parametresi net tanımlı
  });

  @override
  Widget build(BuildContext context) {
    final n = context.neon;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius + 2),
        // Not: n.glow runtime olduğu için burada const kullanamayız
        boxShadow: [
          BoxShadow(
            color: n.glow,
            blurRadius: 28,
            spreadRadius: .5,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF74F9FF),
            Color(0xFF9B87FF),
            Color(0xFFFF8DF2),
          ],
        ),
      ),
      padding: const EdgeInsets.all(1.2), // 1–2px neon “stroke”
      child: GlassCard(
        padding: padding,
        radius: radius,
        child: child,
      ),
    );
  }
}
