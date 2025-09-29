// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get backup => 'Backup';

  @override
  String get exportJsonFile => 'Share JSON backup';

  @override
  String get exportJsonFileSub => 'Share a .json file via system sheet';

  @override
  String get sharedViaSystemSheet => 'Share sheet opened';

  @override
  String get exportFailed => 'Export failed';

  @override
  String get nothingToExport => 'Nothing to export';

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
  String get nameEmptyError => 'Name cannot be empty.';

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

  @override
  String get update => 'Update';

  @override
  String get duplicateName => 'This habit name already exists.';

  @override
  String get importJsonFile => 'Import JSON backup';

  @override
  String get importJsonFileSub => 'Load and merge from a .json file';

  @override
  String importSuccess(int count) {
    return '$count records imported';
  }

  @override
  String get importNothing => 'No new records to import';

  @override
  String get importFailed => 'Import failed';

  @override
  String get invalidBackupFile => 'Invalid backup file';

  @override
  String get onbTitle1 => 'Track your habits';

  @override
  String get onbDesc1 => 'Create daily routines and mark them ✓.';

  @override
  String get onbTitle2 => 'See your progress';

  @override
  String get onbDesc2 => 'Weekly bars show your streaks.';

  @override
  String get onbTitle3 => 'Backup & Import';

  @override
  String get onbDesc3 => 'Export JSON backups, import and merge safely.';

  @override
  String get onbNext => 'Next';

  @override
  String get onbSkip => 'Skip';

  @override
  String get onbStart => 'Get started';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark2 => 'Dark';

  @override
  String get downloadJsonFile => 'Download JSON backup';

  @override
  String get downloadJsonFileSub => 'Save to the Downloads folder';

  @override
  String get savedToDownloads => 'Saved to Downloads';

  @override
  String get openAction => 'Open';

  @override
  String get backupFailed => 'Backup failed';

  @override
  String get cannotOpenFile => 'Couldn’t open the file on this device.';

  @override
  String get openFilesApp => 'Open Files app';

  @override
  String get shareFile => 'Share';

  @override
  String get previewJson => 'Preview JSON backup';

  @override
  String get previewJsonSub => 'View the JSON text in a dialog';

  @override
  String get copyJson => 'Copy JSON to clipboard';

  @override
  String get copyJsonSub => 'Use for quick testing without apps';

  @override
  String get jsonCopied => 'JSON copied to clipboard';

  @override
  String importDetail(int added, int merged) {
    return '$added added, $merged merged';
  }

  @override
  String importSummary(int added, int merged) {
    return '$added new, $merged merged';
  }

  @override
  String get jsonActions => 'JSON actions';

  @override
  String get jsonActionsSub => 'Export / download / import / preview';

  @override
  String get filterAll => 'All';

  @override
  String get filterActive => 'Active';

  @override
  String get filterToday => 'Today ✓';

  @override
  String get todaySubtitleOn => 'Today ✓';

  @override
  String get todaySubtitleOff => 'Not checked';

  @override
  String get deleteOne => 'Delete';

  @override
  String get more => 'More';
}
