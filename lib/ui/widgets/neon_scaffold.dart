import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/theme/neon_theme.dart';

/// 2025 pastel-neon: Arka planı NeonTheme token'larından çeken scaffold.
/// - Light: bgLight (+ pastel field)
/// - Dark : bgDark  (+ pastel field dark)
class NeonScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floating;

  /// İsteğe bağlı hafif kenar karartması (vignette). Varsayılan: kapalı.
  final bool withVignette;

  // ---- D) Hızlı ayar bayrakları (opsiyonel) ----
  /// Dark'ı daha sıcak yap (fuşya tonu artırılmış).
  final bool darkWarmer;

  /// Dark'ı daha serin yap (lilak tonu biraz yukarı).
  final bool darkCooler;

  /// Dark sweep opaklığını +0.02 artır (daha görünür).
  final bool darkMoreVisible;

  /// Alt linear kararmayı 0x14000000 → 0x0F000000 yap (daha düz).
  final bool darkFlatter;

  const NeonScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floating,
    this.withVignette = false,
    this.darkWarmer = false,
    this.darkCooler = false,
    this.darkMoreVisible = false,
    this.darkFlatter = false,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.neon;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Background from tokens (peach for light, warm plum for dark)
    final background = DecoratedBox(
      decoration: BoxDecoration(
        gradient: isDark ? n.bgDark : n.bgLight, // ← NeonTheme tokenları
      ),
    );

    // İsteğe bağlı vignette (kenarlarda yumuşak kararma)
    const vignette = IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.1),
            radius: 1.15,
            colors: [Colors.transparent, Color(0x1A000000)], // ~%10 siyah
            stops: [0.75, 1.0],
          ),
        ),
      ),
    );

    return DecoratedBox(
      // Base ton (peach/plum) — gradient altta bunun üstünde.
      decoration: BoxDecoration(color: n.baseBg),
      child: Stack(
        children: [
          // Statik gradient layer'ını cache'le
          Positioned.fill(child: RepaintBoundary(child: background)),

          // A) mod’a göre iki farklı pastel alan
          if (isDark)
            Positioned.fill(
              child: RepaintBoundary(
                child: _PastelFieldDark(
                  warmer: darkWarmer,
                  cooler: darkCooler,
                  moreVisible: darkMoreVisible,
                  flatter: darkFlatter,
                ),
              ),
            )
          else
            const Positioned.fill(
              child: RepaintBoundary(child: _PastelField()),
            ),

          if (withVignette)
            const Positioned.fill(
              child: RepaintBoundary(child: vignette),
            ),

          // Şeffaf Scaffold → arka plandaki token gradyanı görünür kalır
          Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: appBar,
            body: SafeArea(child: body),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: floating,
          ),
        ],
      ),
    );
  }
}

// ---- Light: ŞEKİLSİZ pastel dağılım (sweep katmanları) ----
class _PastelField extends StatelessWidget {
  const _PastelField();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          // Katman 1: üst-sol kaynaklı sweep (pembe dokunuş)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  center: const Alignment(-0.92, -0.92),
                  startAngle: -0.20,   // hafif eğim
                  endAngle:   3.10,
                  colors: [
                    Colors.transparent,
                    const Color(0xFFFFBBD6).withValues(alpha: 0.22),
                    Colors.transparent,
                  ],
                  stops: const [0.00, 0.35, 1.00],
                ),
              ),
            ),
          ),

          // Katman 2: alt-sağ kaynaklı sweep (şeftali dokunuş)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  center: const Alignment(0.95, 0.95),
                  startAngle: 0.50,
                  endAngle:   3.80,
                  colors: [
                    Colors.transparent,
                    const Color(0xFFFFCBA6).withValues(alpha: 0.20),
                    Colors.transparent,
                  ],
                  stops: const [0.00, 0.42, 1.00],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---- B) Dark: şekilsiz pastel alan (sweep + linear katmanlar) ----
class _PastelFieldDark extends StatelessWidget {
  const _PastelFieldDark({
    this.warmer = false,
    this.cooler = false,
    this.moreVisible = false,
    this.flatter = false,
  });

  final bool warmer;
  final bool cooler;
  final bool moreVisible;
  final bool flatter;

  @override
  Widget build(BuildContext context) {
    
    // Renkler
    final Color fuchsiaBase = warmer ? const Color(0xFFFF8BF0) : const Color(0xFFEA8CFF);
    final Color lilacBase   = cooler ? const Color(0xFF7C65FF) : const Color(0xFF6E4BFF);

    // Opaklıklar
    final double fuchsiaAlpha = moreVisible ? 0.14 : 0.12; // +0.02
    final double lilacAlpha   = moreVisible ? 0.12 : 0.10; // +0.02

    // Alt linear kararma rengi
    final Color bottomShade = flatter ? const Color(0x0F000000) : const Color(0x14000000);

    return IgnorePointer(
      child: Stack(
        children: [
          // Üst–sol: fuşya-mor parıltı
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  center: const Alignment(-0.92, -0.92),
                  startAngle: -0.40,
                  endAngle:   3.20,
                  colors: [
                    Colors.transparent,
                    fuchsiaBase.withValues(alpha: fuchsiaAlpha), // fuşya
                    Colors.transparent,
                  ],
                  stops: const [0.00, 0.45, 1.00],
                ),
              ),
            ),
          ),

          // Alt–sağ: mor efekt (daha serin)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  center: const Alignment(0.95, 0.95),
                  startAngle: 0.40,
                  endAngle:   3.60,
                  colors: [
                    Colors.transparent,
                    lilacBase.withValues(alpha: lilacAlpha), 
                    Colors.transparent,
                  ],
                  stops: const [0.00, 0.40, 1.00],
                ),
              ),
            ),
          ),

         
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0x00000000), bottomShade],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
