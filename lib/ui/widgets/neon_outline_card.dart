import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/widgets/glass_card.dart';
import 'package:habit_tracker/ui/theme/neon_theme.dart';

class NeonOutlineCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final EdgeInsetsGeometry margin;


  final bool coolHint;
  final bool glow;  
  final double? blurSigma;

  const NeonOutlineCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.radius = 20,
    this.margin = const EdgeInsets.all(0),
    this.coolHint = false,
    this.glow = true,
    this.blurSigma,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.neon;

    // Tema: Light/Dark ayrımı
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light için sıcak şeftali ışıma (%12 alfa), Dark için tema glowy (plum)
    final lightShadow = const Color(0xFFFFA8C2).withValues(alpha: 0.12);
    final darkShadow  = n.glow;

    // Önerilen palet: blush → lilac → pink
    const softTrio = <Color>[
      Color(0xFFF7BFE8), // blush (yumuşak, cyan/yeşil değil)
      Color(0xFFB9A7FF), // lilac (9B87FF'ten daha yumuşak)
      Color(0xFFFF9CF0), // pink (FF8DF2'den biraz daha açık)
    ];

    // Alternatif: sky-lilac → lilac → pink (mavi dokunuş, yeşilsiz)
    const skyTrio = <Color>[
      Color(0xFFCADBFF), // sky-lilac (mavi; kesinlikle yeşil/cyan değil)
      Color(0xFFB9A7FF), // lilac
      Color(0xFFFF9CF0), // pink
    ];

    final gradientColors = coolHint ? skyTrio : softTrio;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius + 2),
        // Neon yumuşak ışıma — tema bazlı
        boxShadow: glow
            ? [
                BoxShadow(
                  color: isDark ? darkShadow : lightShadow,
                  blurRadius: isDark ? 28 : 18,
                  spreadRadius: isDark ? 0.5 : 0.2,
                  offset: isDark ? const Offset(0, 10) : const Offset(0, 8),
                ),
              ]
            : const [],
        
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
      // 1–2px neon “stroke”
      padding: const EdgeInsets.all(1.2),
      child: GlassCard(
        padding: padding,
        radius: radius,
        blurSigma: blurSigma,
        child: child,

      ),
    );
  }
}
