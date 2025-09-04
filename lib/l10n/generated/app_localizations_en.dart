// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get habitListTitle => 'My Habits';

  @override
  String get cancel => 'Cancel';

  @override
  String get settings => 'Settings';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get deleteSelected => 'Delete selected';

  @override
  String get todayCheck => 'Today ✓';

  @override
  String get todayUncheck => 'Remove today\'s check';

  @override
  String get edit => 'Edit';

  @override
  String get detail => 'Detail';

  @override
  String get noSelection => 'No selected item';

  @override
  String itemsDeleted(int count) {
    return '$count item(s) deleted';
  }

  @override
  String get undo => 'Undo';

  @override
  String itemDeleted(String name) {
    return '\"$name\" deleted';
  }

  @override
  String get addHabit => 'Add Habit';

  @override
  String get add => 'Add';

  @override
  String get noHabitsHint => 'No habits yet.\nUse the + button below to add.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get themeDark => 'Dark Theme';

  @override
  String get language => 'Language';

  @override
  String get turkish => 'Turkish';

  @override
  String get english => 'English';

  @override
  String get general => 'General';

  @override
  String get addHabitTitle => 'Add Habit';

  @override
  String get habitName => 'Habit name';

  @override
  String get habitNameHint => 'e.g., Drink water';

  @override
  String get save => 'Save';

  @override
  String get editHabitTitle => 'Edit Habit';

  @override
  String get newName => 'New name';

  @override
  String get newNameHint => 'e.g., Morning water';

  @override
  String get updateButton => 'Update';

  @override
  String get updated => 'Updated';

  @override
  String get noChange => 'You didn’t change anything.';

  @override
  String detailTitleFor(String name) {
    return 'Detail: $name';
  }

  @override
  String get last7Days => 'Last 7 Days';

  @override
  String successLabel(int done, int percent) {
    return 'Success: $done/7  (%$percent)';
  }

  @override
  String get toggleTodayOn => 'Mark Today ✓';

  @override
  String get toggleTodayOff => 'Today ✓ (Undo)';
}
