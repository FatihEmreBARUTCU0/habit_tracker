import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/theme/neon_theme.dart';

class NeonFab extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? icon;
  final String? label;        // null → daire FAB
  final Gradient? gradient;   // null → theme.gradPinkViolet
  final EdgeInsets margin;

  const NeonFab.extended({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.gradient,
    this.margin = const EdgeInsets.only(bottom: 16, right: 16),
  });

  const NeonFab.icon({
    super.key,
    required this.onPressed,
    required this.icon,
    this.gradient,
    this.margin = const EdgeInsets.only(bottom: 16, right: 16),
  }) : label = null;

  @override
  Widget build(BuildContext context) {
    final n = Theme.of(context).extension<NeonTheme>()!;
    final g = gradient ?? n.gradPinkViolet;

    final child = label == null
    ? Padding(
        padding: const EdgeInsets.all(14),
        child: Center(child: icon),
      )
    : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          icon ?? const SizedBox.shrink(),
          const SizedBox(width: 8),
          Text(
            label!,
            style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600,
            ),
          ),
        ]),
      );

final button = DecoratedBox(
  decoration: BoxDecoration(
    gradient: g,
    borderRadius: BorderRadius.circular(100),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.20), // ✅ güncel yöntem
        blurRadius: 18, spreadRadius: 0.5, offset: const Offset(0, 6),
      ),
    ],
  ),
  child: child,
);


    final semantics = Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onPressed,
          child: button,
        ),
      ),
    );

    return Container(
      margin: margin,
      decoration: const BoxDecoration(), // layout için
      child: semantics,
    );
  }
}
