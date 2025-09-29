import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/theme/neon_theme.dart';

class NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Gradient? gradient; // null → gradPinkViolet
  final bool expanded;
  final double radius;

  const NeonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.expanded = true,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.neon;
    final g = gradient ?? n.gradPinkViolet;

    final btn = DecoratedBox(
  decoration: BoxDecoration(
    gradient: g,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(color: context.neon.glow, blurRadius: 24, spreadRadius: 1, offset: const Offset(0,10)),
    ],
  ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16, fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );

    final w = expanded ? SizedBox(width: double.infinity, child: btn) : btn;

    return Opacity(
      opacity: onPressed == null ? 0.6 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onPressed,
        child: w,
      ),
    );
  }
}
