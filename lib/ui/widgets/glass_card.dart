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

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: n.glassBlur, sigmaY: n.glassBlur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: overlay,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: n.glassStroke, width: 1),
          ),
          child: child,
        ),
      ),
    );

    return Container(
      margin: margin,
      child: onTap == null ? card : InkWell(borderRadius: BorderRadius.circular(radius), onTap: onTap, child: card),
    );
  }
}
