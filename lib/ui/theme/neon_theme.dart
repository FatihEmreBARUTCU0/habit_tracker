import 'package:flutter/material.dart';

@immutable
class NeonTheme extends ThemeExtension<NeonTheme> {
  final Color baseBg;                 // arka plan
  final Gradient gradPinkViolet;      // pembe->mor
  final Gradient gradAquaTeal;        // aqua->teal
  final Gradient gradPeachCoral;      // şeftali->mercan
  final double glassBlur;             // blur miktarı
  final double glassOverlay;          // beyaz film opaklığı (0..1)
  final Color glassStroke;            // ince iç çizgi
  final double radius;                // kart/button köşe yarıçapı
  final Color glow;                   // yumuşak dış gölge rengi

  const NeonTheme({
    required this.baseBg,
    required this.gradPinkViolet,
    required this.gradAquaTeal,
    required this.gradPeachCoral,
    required this.glassBlur,
    required this.glassOverlay,
    required this.glassStroke,
    required this.radius,
    required this.glow,
  });

  // DARK tema tokenları (2025 pastel-neon)
  static const NeonTheme dark = NeonTheme(
    baseBg: Color(0xFF0B0F1F),
    gradPinkViolet: LinearGradient(
      begin: Alignment(-1, -1),
      end: Alignment(1, 1),
      colors: [Color(0xFFFF8DF2), Color(0xFF9C7CFF)],
    ),
    gradAquaTeal: LinearGradient(
      begin: Alignment(-1, -1),
      end: Alignment(1, 1),
      colors: [Color(0xFF53E6F3), Color(0xFF3CCAD9)],
    ),
    gradPeachCoral: LinearGradient(
      begin: Alignment(-1, -1),
      end: Alignment(1, 1),
      colors: [Color(0xFFFFD4B8), Color(0xFFFF97B7)],
    ),
    glassBlur: 14,
    glassOverlay: 0.14,
    glassStroke: Color(0x26FFFFFF),
    radius: 22,
    glow: Color(0x663C2E7E),
  );

  // LIGHT tema tokenları
  static final NeonTheme light = NeonTheme(
    baseBg: const Color(0xFFF7F5FF),
    gradPinkViolet: dark.gradPinkViolet,
    gradAquaTeal: dark.gradAquaTeal,
    gradPeachCoral: dark.gradPeachCoral,
    glassBlur: 14,
    glassOverlay: 0.10,
    glassStroke: const Color(0x14000000),
    radius: 22,
    glow: const Color(0x334B3AA3),
  );

  @override
  NeonTheme copyWith({
    Color? baseBg,
    Gradient? gradPinkViolet,
    Gradient? gradAquaTeal,
    Gradient? gradPeachCoral,
    double? glassBlur,
    double? glassOverlay,
    Color? glassStroke,
    double? radius,
    Color? glow,
  }) {
    return NeonTheme(
      baseBg: baseBg ?? this.baseBg,
      gradPinkViolet: gradPinkViolet ?? this.gradPinkViolet,
      gradAquaTeal: gradAquaTeal ?? this.gradAquaTeal,
      gradPeachCoral: gradPeachCoral ?? this.gradPeachCoral,
      glassBlur: glassBlur ?? this.glassBlur,
      glassOverlay: glassOverlay ?? this.glassOverlay,
      glassStroke: glassStroke ?? this.glassStroke,
      radius: radius ?? this.radius,
      glow: glow ?? this.glow,
    );
  }

  @override
  ThemeExtension<NeonTheme> lerp(ThemeExtension<NeonTheme>? other, double t) => this;
}

extension NeonX on BuildContext {
  NeonTheme get neon => Theme.of(this).extension<NeonTheme>()!;
}
