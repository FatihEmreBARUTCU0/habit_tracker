import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/theme/neon_theme.dart';

class NeonFrame extends StatelessWidget {
  final Widget child;
  final double borderWidth;
 
  final bool showRadials;

  const NeonFrame({
    super.key,
    required this.child,
    this.borderWidth = 2.0,
    this.showRadials = true,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.neon;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Çerçeve kıvrımı: temadaki radius üzerine biraz ek.
    final radius = n.radius + 6;

    return DecoratedBox(
      decoration: BoxDecoration( 
        // Dış neon çerçeve gradyanı
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6FE7FF), // aqua
            Color(0xFFFA77E1), // pink
          ],
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        decoration: BoxDecoration(
          color: n.baseBg, // temadan koyu zemin
          borderRadius: BorderRadius.circular(radius - borderWidth),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - borderWidth),
          child: Stack(
            children: [
             
              if (showRadials && !isDark) ...[
                Positioned(
                  top: -140, right: -140,
                  child: IgnorePointer(
                    child: Container(
                      width: 360, height: 360,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          radius: 0.6,
                          colors: [
                            const Color(0xFF6FE7FF).withValues(alpha: 0.50),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -140, left: -140,
                  child: IgnorePointer(
                    child: Container(
                      width: 320, height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          radius: 0.6,
                          colors: [
                            const Color(0xFFFA77E1).withValues(alpha: 0.45),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              // İçerik + sistem çentikleri
              // SafeArea container
              SafeArea(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
