import 'package:flutter/widgets.dart';
import 'package:habit_tracker/l10n/generated/app_localizations.dart';

typedef StrValidator = String? Function(String?);

StrValidator validateHabitName(BuildContext context) {
  final l = AppLocalizations.of(context);
  return (value) {
    final t = (value ?? '').trim();
    if (t.isEmpty) return l.nameEmptyError; // ← l10n'dan
    return null;
  };
}