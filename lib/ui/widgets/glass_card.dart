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

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.margin = EdgeInsets.zero,
    this.radius = 20,
    this.onTap,
    this.blurSigma,
    this.highlight = true,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.neon;

    // Tema farkı
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Opsiyonel: Light modda cam film (overlay) biraz daha temiz (−%20)
    final double overlayAlpha = isDark
        ? n.glassOverlay
        : (n.glassOverlay * 0.8); // 0..1 aralığında
    final overlay = Colors.white.withValues(
      alpha: overlayAlpha.clamp(0.0, 1.0),
    );

    // Dış glow (neon hissi) — tema bazlı
    final lightShadow = const Color(0xFFFFA8C2).withValues(alpha: 0.14); // sıcak şeftali
    final darkShadow = n.glow; // dark modda neon plum kalsın

    // İç cam/blur + (opsiyonel) üstten parıltı (gradient)
    final cardCore = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurSigma ?? n.glassBlur,
          sigmaY: blurSigma ?? n.glassBlur,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: overlay,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: n.glassStroke, width: 1),
            // Highlight kapatılabilir
            gradient: highlight
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x11FFFFFF), // çok hafif beyaz
                      Color(0x00000000), // tamamen saydam
                    ],
                  )
                : null,
          ),
          child: child,
        ),
      ),
    );

    // Dış glow (tema bazlı ayarlı)
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: isDark ? darkShadow : lightShadow,
            blurRadius: isDark ? 24 : 16,     // light’ta daha az blur
            spreadRadius: isDark ? 1 : 0.2,   // light’ta daha dar penumbra
            offset: isDark ? const Offset(0, 8) : const Offset(0, 6),
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
