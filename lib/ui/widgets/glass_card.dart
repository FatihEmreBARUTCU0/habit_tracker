import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/theme/neon_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double radius;
  final GestureTapCallback? onTap;
  final double? blurSigma;
  final bool highlight;
  final bool useBlur; // ✅

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.margin = EdgeInsets.zero,
    this.radius = 20,
    this.onTap,
    this.blurSigma,
    this.highlight = true,
    this.useBlur = true, // eski davranış
  });

  @override
  Widget build(BuildContext context) {
    final n = context.neon;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final double overlayAlpha = isDark ? n.glassOverlay : (n.glassOverlay * 0.8);
    final overlay = Colors.white.withValues(alpha: overlayAlpha.clamp(0.0, 1.0));

    final lightShadow = const Color(0xFFFFA8C2).withValues(alpha: 0.14);
    final darkShadow = n.glow;

    // İç çekirdek (blur opsiyonel)
    Widget core = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: overlay,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: n.glassStroke, width: 1),
        // Color + Gradient çakışmasını önlemek için parıltıyı foreground'a taşıyoruz
        // (foregroundDecoration aşağıda eklenecek)
      ),
      // foregroundDecoration = highlight ? … : null şeklinde verilecek
      foregroundDecoration: highlight
          ? const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x11FFFFFF), Color(0x00000000)],
              ),
              // borderRadius foreground'da da belirtilmeli
              borderRadius: BorderRadius.all(Radius.circular(20)),
            )
          : null,
      child: child,
    );

    if (useBlur) {
      core = BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurSigma ?? n.glassBlur,
          sigmaY: blurSigma ?? n.glassBlur,
        ),
        child: core,
      );
    }

    final cardCore = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: core,
    );

    final content = onTap == null
        ? cardCore
        : Material( // 👈 splash için
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: onTap,
              child: cardCore,
            ),
          );

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: isDark ? darkShadow : lightShadow,
            blurRadius: isDark ? 24 : 16,
            spreadRadius: isDark ? 1 : 0.2,
            offset: isDark ? const Offset(0, 8) : const Offset(0, 6),
          ),
        ],
      ),
      child: content,
    );
  }
}
