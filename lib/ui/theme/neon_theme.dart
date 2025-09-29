import 'package:flutter/material.dart';

@immutable
class NeonTheme extends ThemeExtension<NeonTheme> {
  final Color baseBg;                 // #0B0F1F (dark)
  final Gradient gradPinkViolet;      // #FF72E1 -> #A16BFE
  final Gradient gradAquaTeal;        // #4BE1EC -> #2BC0D9
  final Gradient gradPeachCoral;      // #FFC6A8 -> #FF8FB1
  final double glassBlur;             // 8..16
  final double glassOverlay;          // 0..1  (white overlay opacity)
  final Color glassStroke;            // inner stroke

  const NeonTheme({
    required this.baseBg,
    required this.gradPinkViolet,
    required this.gradAquaTeal,
    required this.gradPeachCoral,
    required this.glassBlur,
    required this.glassOverlay,
    required this.glassStroke,
  });

  // Tamamen sabit -> const
  static const NeonTheme dark = NeonTheme(
    baseBg: Color(0xFF0B0F1F),
    gradPinkViolet: LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFFF72E1), Color(0xFFA16BFE)],
    ),
    gradAquaTeal: LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFF4BE1EC), Color(0xFF2BC0D9)],
    ),
    gradPeachCoral: LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFFFC6A8), Color(0xFFFF8FB1)],
    ),
    glassBlur: 12,
    glassOverlay: 0.16,                  // 16% beyaz
    glassStroke: Color(0x22FFFFFF),      // #FFFFFF22
  );

  // dark.* referansı nedeniyle const OLAMAZ -> final
  static final NeonTheme light = NeonTheme(
    baseBg: const Color(0xFFF6F2FF),     // çok soluk pastel (light base)
    gradPinkViolet: dark.gradPinkViolet,
    gradAquaTeal: dark.gradAquaTeal,
    gradPeachCoral: dark.gradPeachCoral,
    glassBlur: 12,
    glassOverlay: 0.12,                  // light’ta biraz daha az overlay
    glassStroke: const Color(0x10000000),// #00000010
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
  }) => NeonTheme(
        baseBg: baseBg ?? this.baseBg,
        gradPinkViolet: gradPinkViolet ?? this.gradPinkViolet,
        gradAquaTeal: gradAquaTeal ?? this.gradAquaTeal,
        gradPeachCoral: gradPeachCoral ?? this.gradPeachCoral,
        glassBlur: glassBlur ?? this.glassBlur,
        glassOverlay: glassOverlay ?? this.glassOverlay,
        glassStroke: glassStroke ?? this.glassStroke,
      );

  @override
  ThemeExtension<NeonTheme> lerp(ThemeExtension<NeonTheme>? other, double t) => this;
}

extension NeonX on BuildContext {
  NeonTheme get neon => Theme.of(this).extension<NeonTheme>()!;
}
