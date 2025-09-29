import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/theme/neon_theme.dart';

class NeonScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floating;
  final bool withTopGlow;

  const NeonScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floating,
    this.withTopGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.neon;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: n.baseBg, // #0B0F1F (dark) / #F6F2FF (light)
      child: Stack(
        children: [
          // 🔵 / 💜 daireler sadece light'ta kalsın
          if (!isDark) ...[
            // 🔵 Aqua-Teal leke (sol-alt) — küçült + opaklık
            Positioned(
              left: -140, bottom: -140,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.70, // daha yumuşak
                  child: Container(
                    width: 300, height: 300, // küçültüldü
                    decoration: BoxDecoration(
                      gradient: n.gradAquaTeal,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            // 💜 Pink-Violet leke (sağ-üst) — küçült + opaklık
            if (withTopGlow)
              Positioned(
                right: -60, top: -70, // sahnenin dışına biraz daha yakın
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.55, // yumuşak
                    child: Container(
                      width: 220, height: 220, // küçültüldü
                      decoration: BoxDecoration(
                        gradient: n.gradPinkViolet,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
          ],

          // 🌞 Light modda pastel degrade film (mevcut davranış korunur)
          if (!isDark)
            const Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [Color(0xFFF6F2FF), Color(0xFFF2FBFF)],
                    ),
                  ),
                ),
              ),
            ),

          // 🌙 Dark modda minimal degrade (yuvarlak yok)
          if (isDark)
            const Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0B0F1F), // üst
                        Color(0xFF091226), // alt (bir ton daha koyu)
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // İçerik
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
