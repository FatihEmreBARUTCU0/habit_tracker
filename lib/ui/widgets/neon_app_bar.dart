import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/ui/theme/neon_theme.dart';

class NeonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final double height;
  final Gradient? gradient;

  // Ayarlar
  final double bottomRadius;      // başlık eğrisi
  final bool enableRadials;       // hafif glow vurguları (her iki mod)
  final double lightRadialAlpha;  // light modda parıltı şiddeti
  final double darkRadialAlpha;   // dark modda parıltı şiddeti

  const NeonAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.height = kToolbarHeight,
    this.gradient,
    this.bottomRadius = 24,       // 24–32 arası zevkine göre ayarla
    this.enableRadials = true,
    this.lightRadialAlpha = 0.08, // light: çok hafif
    this.darkRadialAlpha  = 0.18, // dark: biraz daha belirgin
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final n = context.neon;
    final g = gradient ?? n.gradPinkViolet;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Radials her iki modda da kullanılabilir
    final showRadials = enableRadials;
    final double radialA = isDark ? darkRadialAlpha : lightRadialAlpha;

    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: leading,
      actions: actions,
      title: DefaultTextStyle.merge(
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        child: title ?? const SizedBox.shrink(),
      ),

      // Yuvarlak şekil + gradient’in eğriyi takip etmesi için clip
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(bottomRadius)),
      ),
      flexibleSpace: ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(bottomRadius)),
        child: Stack(
          children: [
            // Ana gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: g),
              ),
            ),

            // Hafif radial highlight’lar → her iki modda (ışığa göre şiddet)
            if (showRadials) ...[
              Positioned(
                top: -60, left: -20,
                child: _HeaderRadial(color: Colors.white.withValues(alpha: radialA), size: 180),
              ),
              Positioned(
                top: -80, right: -10,
                child: _HeaderRadial(color: Colors.white.withValues(alpha: radialA * 0.7), size: 240),
              ),
            ],

            // İçerikten başlığı ayırmak için tema-duyarlı alt scrim
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: isDark
                          ? const [Color(0x14000000), Color(0x00000000)] // dark: %8
                          : const [Color(0x11000000), Color(0x00000000)], // light: %6
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}

// neon_app_bar.dart  (NeonAppBar sınıfının ALTINA koy)
class _HeaderRadial extends StatelessWidget {
  final Color color;
  final double size;
  const _HeaderRadial({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color, Colors.transparent],
              stops: const [0.0, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}
