import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/theme/neon_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double radius;
  final GestureTapCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.margin = EdgeInsets.zero,
    this.radius = 20,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.neon;
    final overlay = Colors.white.withValues(alpha: n.glassOverlay);

    // İç cam/blur + hafif üstten parıltı (gradient)
    final cardCore = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: n.glassBlur, sigmaY: n.glassBlur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: overlay,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: n.glassStroke, width: 1),
            // Üstten hafif highlight
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x11FFFFFF), // çok hafif beyaz
                Color(0x00000000), // tamamen saydam
              ],
            ),
          ),
          child: child,
        ),
      ),
    );

    // Dış glow (neon hissi)
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: n.glow,          // temadaki neon glow rengi
            blurRadius: 24,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: onTap == null
          ? cardCore
          : InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: onTap,
              child: cardCore,
            ),
    );
  }
}
