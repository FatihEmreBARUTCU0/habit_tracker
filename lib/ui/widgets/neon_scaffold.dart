import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/theme/neon_theme.dart';

class NeonScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floating;

  /// İstersen çok hafif kararma için aç (edge’lerde 2025 tarzı vignette).
  final bool withVignette;

  const NeonScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floating,
    this.withVignette = false,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.neon;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Arka plan: referanstaki gibi sade, yumuşak bir dikey degrade.
    final background = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [Color(0xFF0B0F1F), Color(0xFF091226)]
              : const [Color(0xFFF6F2FF), Color(0xFFF2FBFF)],
        ),
      ),
    );

    // Çok hafif vignette (isteğe bağlı) — mümkün olan yerlerde const
    const vignette = IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.1), // const Alignment
            radius: 1.15,
            colors: [Colors.transparent, Color(0x1A000000)], // const liste
            stops: [0.75, 1.0], // const liste
          ),
        ),
      ),
    );

    return DecoratedBox( // Container->DecoratedBox (hafif)
      decoration: BoxDecoration(color: n.baseBg),
      child: Stack(
        children: [
          Positioned.fill(child: background),
          if (withVignette) const Positioned.fill(child: vignette),
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
