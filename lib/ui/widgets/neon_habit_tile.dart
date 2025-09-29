import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/widgets/glass_card.dart';
import 'package:habit_tracker/ui/theme/neon_theme.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/l10n/generated/app_localizations.dart';

class NeonHabitTile extends StatelessWidget {
  final Habit habit;
  final bool checkedToday;
  final VoidCallback onToggleToday;
  final VoidCallback onEdit;   // ⋯ altında toplanacak – parametre dışarıdan geliyor
  final VoidCallback onDetail; // ⋯ altında toplanacak – parametre dışarıdan geliyor
  final VoidCallback? onMore;

  // Seçim modu desteği
  final bool selectionMode;
  final bool selected;
  final VoidCallback? onTapSelect;
  final VoidCallback? onLongPress;

  const NeonHabitTile({
    super.key,
    required this.habit,
    required this.checkedToday,
    required this.onToggleToday,
    required this.onEdit,
    required this.onDetail,
    this.selectionMode = false,
    this.selected = false,
    this.onTapSelect,
    this.onLongPress,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final n = context.neon;

    final fg = scheme.onSurface;                 // ana yazı rengi
    final fgWeak = fg.withValues(alpha: isDark ? 0.8 : 0.65);

    Widget leftAvatar() {
      // Pastel neon halka (mockup benzeri)
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: n.gradPinkViolet,
        ),
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : Colors.white.withValues(alpha: 0.85),
          ),
          child: Icon(
            checkedToday ? Icons.check_rounded : Icons.circle_outlined,
            color: isDark ? Colors.white : scheme.primary,
            size: 22,
          ),
        ),
      );
    }

    final title = Text(
      habit.name,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      overflow: TextOverflow.ellipsis,
    );

    // 4) “Bugün” durumu için minik status chip
    final subtitleRow = Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            // DEPRECATION FIX: withOpacity -> withValues(alpha: ...)
            color: (checkedToday ? Colors.green : fgWeak)
                .withValues(alpha: checkedToday ? .18 : .12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            checkedToday ? l.todaySubtitleOn : l.todaySubtitleOff,
            style: TextStyle(
              fontSize: 11,
              color: checkedToday ? Colors.green : fgWeak,
            ),
          ),
        ),
      ],
    );

    // 3) Trailing: sadece ✓ ve ⋯
    final trailing = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: checkedToday ? l.todayUncheck : l.todayCheck,
          icon: Icon(
            checkedToday ? Icons.check_circle : Icons.circle_outlined,
            size: 20,
            color: fg,
          ),
          onPressed: onToggleToday,
        ),
        IconButton(
          tooltip: l.more,
          icon: Icon(Icons.more_vert, size: 20, color: fg),
          onPressed: onMore,
        ),
      ],
    );

    final textColumn = DefaultTextStyle(
      style: TextStyle(color: fg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: KeyedSubtree(
              key: ValueKey<bool>(checkedToday),
              child: subtitleRow,
            ),
          ),
        ],
      ),
    );

    final core = Row(
      children: [
        leftAvatar(),
        const SizedBox(width: 12),
        Expanded(child: textColumn),
        const SizedBox(width: 8),
        if (!selectionMode) trailing,
        if (selectionMode)
          Checkbox(
            value: selected,
            onChanged: (_) => onTapSelect?.call(),
          ),
      ],
    );

    // 8) Erişilebilirlik: Semantics
    return Semantics(
      label:
          '${habit.name} — ${checkedToday ? l.todaySubtitleOn : l.todaySubtitleOff}',
      button: true,
      child: GestureDetector(
        onLongPress: onLongPress, // seçim moduna geçiş için dışarıdan geliyor
        child: GlassCard(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          onTap: selectionMode ? onTapSelect : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              // 6) Kart gölgelerini yumuşat — DEPRECATION FIX
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.18),
                        blurRadius: 16,
                        spreadRadius: .5,
                      )
                    ]
                  : const [],
            ),
            child: core,
          ),
        ),
      ),
    );
  }
}
