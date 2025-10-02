import 'package:flutter/material.dart';
import 'dart:math' as math;

@immutable
class NeonTheme extends ThemeExtension<NeonTheme> {
  final Color baseBg;                 // arka plan temel rengi
  final Gradient gradPinkViolet;      // pembe->mor
  final Gradient gradAquaTeal;        // aqua->teal
  final Gradient gradPeachCoral;      // şeftali->mercan
  final double glassBlur;             // blur miktarı
  final double glassOverlay;          // beyaz film opaklığı (0..1)
  final Color glassStroke;            // ince iç çizgi
  final double radius;                // kart/button köşe yarıçapı
  final Color glow;                   // yumuşak dış gölge rengi

  // Cam yüzey renkleri
  final Color surfaceGlass;           // cam yüzey (arka plan beyaz overlay)
  final Color surfaceBorder;          // cam kenar çizgisi

  // Uygulama arka plan gradyanları (token)
  final Gradient bgLight;             // light mod arka planı
  final Gradient bgDark;              // dark mod arka planı

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
    required this.surfaceGlass,
    required this.surfaceBorder,
    required this.bgLight,
    required this.bgDark,
  });

  // DARK — warm pink-plum (not black)
  static const NeonTheme dark = NeonTheme(
    baseBg: Color(0xFF1C0F29), // deep plum base (no pure black)

    // (Mevcut geliştirilmiş gradyanını koruyoruz)
    gradPinkViolet: LinearGradient(
      begin: Alignment(-1.05, -0.90),
      end: Alignment(1.05, 0.90),
      colors: <Color>[
        Color(0xFFFF8DF2),
        Color(0xFFFFB3F6),
        Color(0xFFB894FF),
        Color(0xFF9C7CFF),
      ],
      stops: <double>[0.00, 0.42, 0.70, 1.00],
      transform: GradientRotation(0.10 * math.pi),
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

    surfaceGlass: Color(0x0FFFFFFF),  // beyaz %6
    surfaceBorder: Color(0x14FFFFFF), // beyaz %8

    // NEW/STRONGER background
    bgDark: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF351252), // plum with magenta tone
        Color(0xFF1C0F29), // base
        Color(0xFF150B20), // deep end – still warm, not black
      ],
      stops: [0.0, 0.55, 1.0],
    ),

    // required (unused in dark)
    bgLight: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFEFE3), Color(0xFFFFF7F1)],
    ),
  );

  // LIGHT — sweeter rosy-peach (clearly noticeable)
  static const NeonTheme light = NeonTheme(
    // sweeter base (noticeably rosy)
    baseBg: Color(0xFFFFE8F2),

    // improved header gradient (multi-stop)
    gradPinkViolet: LinearGradient(
      begin: Alignment(-1.05, -0.90),
      end: Alignment(1.05, 0.90),
      colors: <Color>[
        Color(0xFFFF8DF2),
        Color(0xFFFFB3F6),
        Color(0xFFB894FF),
        Color(0xFF9C7CFF),
      ],
      stops: <double>[0.00, 0.42, 0.70, 1.00],
      transform: GradientRotation(0.10 * math.pi),
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

    // ✅ Daha temiz opsiyon uygulandı
    glassOverlay: 0.08,               // önce 0.10 → biraz daha az puslu
    glassStroke: Color(0x0D000000),   // önerilen ince iç çizgi (siyah %5)
    radius: 22,
    glow: Color(0x14FFA8C2),          // sıcak, hafif şeftali glow (%8 alfa)

    surfaceGlass: Color(0x4DFFFFFF),  // beyaz %30
    surfaceBorder: Color(0x0D000000), // siyah %5

    // ✨ stronger, sweeter mix (pink → blush → peach)
    bgLight: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFFE8F2), // cotton-candy pink
        Color(0xFFFFDDEB), // blush
        Color(0xFFFFE7D6), // soft peach at bottom
      ],
      stops: [0.0, 0.55, 1.0],
    ),

    // required placeholder for API symmetry (unused in light)
    bgDark: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF2A1040), Color(0xFF150B20)],
    ),
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
    Color? surfaceGlass,
    Color? surfaceBorder,
    Gradient? bgLight,
    Gradient? bgDark,
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
      surfaceGlass: surfaceGlass ?? this.surfaceGlass,
      surfaceBorder: surfaceBorder ?? this.surfaceBorder,
      bgLight: bgLight ?? this.bgLight,
      bgDark: bgDark ?? this.bgDark,
    );
  }

  @override
  ThemeExtension<NeonTheme> lerp(ThemeExtension<NeonTheme>? other, double t) => this;
}

extension NeonX on BuildContext {
  NeonTheme get neon => Theme.of(this).extension<NeonTheme>()!;
}
