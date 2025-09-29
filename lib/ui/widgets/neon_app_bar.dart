import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/ui/theme/neon_theme.dart';

class NeonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final double height;
  final Gradient? gradient;

  const NeonAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.height = kToolbarHeight,
    this.gradient,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final n = context.neon;
    final g = gradient ?? n.gradPinkViolet;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: leading,
      actions: actions,
      title: DefaultTextStyle.merge(
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        child: title ?? const SizedBox.shrink(),
      ),
      flexibleSpace: Container(decoration: BoxDecoration(gradient: g)),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}
