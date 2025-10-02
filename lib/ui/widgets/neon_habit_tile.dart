import 'package:flutter/material.dart';
// import 'package:habit_tracker/ui/widgets/glass_card.dart'; // ❌ artık kullanılmıyor
import 'package:habit_tracker/ui/widgets/neon_outline_card.dart'; // ✅ kullanılıyor
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

  // 1) Chip’i okunur yap (kontrast + kalınlık)
  Widget _statusChip(BuildContext context, bool on, String onText, String offText) {
    final cs = Theme.of(context).colorScheme;
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = on
        ? (dark ? cs.primary.withValues(alpha: 0.22) : cs.primary.withValues(alpha: 0.18))
        : (dark ? cs.onSurface.withValues(alpha: 0.08) : cs.onSurface.withValues(alpha: 0.06));

    final Color fg = on ? (dark ? cs.onPrimary : cs.primary) : cs.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: on ? cs.primary.withValues(alpha: 0.35) : cs.outline.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        on ? onText : offText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700, // kalın
          color: fg,
          letterSpacing: .1,
        ),
      ),
    );
  }

  // 2) Sade avatar
  Widget leftAvatar(BuildContext context, bool on) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: on ? cs.primary : cs.surfaceContainerHighest,
        border: Border.all(color: cs.outline.withValues(alpha: 0.30)),
      ),
      child: Icon(
        on ? Icons.check_rounded : Icons.circle_outlined,
        color: on ? cs.onPrimary : cs.onSurfaceVariant,
        size: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    final fg = scheme.onSurface; // ana yazı rengi

    final title = Text(
      habit.name,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      overflow: TextOverflow.ellipsis,
    );

    // Chip: _statusChip ile oluşturuluyor
    final subtitle = _statusChip(context, checkedToday, l.todaySubtitleOn, l.todaySubtitleOff);

    // 4) İkon renkleri: tek renge sabitle
    final iconColor = Theme.of(context).colorScheme.onSurface;

    // Trailing: sadece ✓ ve ⋯
    final trailing = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: checkedToday ? l.todayUncheck : l.todayCheck,
          icon: Icon(
            checkedToday ? Icons.check_circle : Icons.circle_outlined,
            size: 20,
            color: iconColor,
          ),
          onPressed: onToggleToday,
        ),
        IconButton(
          tooltip: l.more,
          icon: Icon(Icons.more_vert, size: 20, color: iconColor),
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
              child: subtitle,
            ),
          ),
        ],
      ),
    );

    final core = Row(
      children: [
        leftAvatar(context, checkedToday),
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

    // ✅ Dış sarmalayıcı: NeonOutlineCard + InkWell (tıklama davranışı)
    final tile = Semantics(
      label: '${habit.name} — ${checkedToday ? l.todaySubtitleOn : l.todaySubtitleOff}',
      button: true,
      child: GestureDetector(
        onLongPress: onLongPress, // seçim moduna geçiş için dışarıdan geliyor
        child: NeonOutlineCard(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: const EdgeInsets.all(12),
          radius: 22,
           glow: false,
            blurSigma: 8,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: selectionMode ? onTapSelect : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                // İç arka plan nötr: sadece opsiyonel hafif gölge
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: .16),
                          blurRadius: 14,
                          spreadRadius: .4,
                        ),
                      ]
                    : const [],
              ),
              child: core,
            ),
          ),
        ),
      ),
    );

    // Giriş animasyonu: hafif aşağıdan süzülme + opaklık
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.05, end: 0.0),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      builder: (ctx, v, child) => Transform.translate(
        offset: Offset(0, 24 * v),
        child: Opacity(
          opacity: 1 - v * 8, // 1 -> ~0.6 arasında hızlıca görünür olur
          child: child,
        ),
      ),
      child: tile,
    );
  }
}
