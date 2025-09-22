import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @exportJsonFile.
  ///
  /// In en, this message translates to:
  /// **'Share JSON backup'**
  String get exportJsonFile;

  /// No description provided for @exportJsonFileSub.
  ///
  /// In en, this message translates to:
  /// **'Share a .json file via system sheet'**
  String get exportJsonFileSub;

  /// No description provided for @sharedViaSystemSheet.
  ///
  /// In en, this message translates to:
  /// **'Share sheet opened'**
  String get sharedViaSystemSheet;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// No description provided for @nothingToExport.
  ///
  /// In en, this message translates to:
  /// **'Nothing to export'**
  String get nothingToExport;

  /// No description provided for @habitListTitle.
  ///
  /// In en, this message translates to:
  /// **'My Habits'**
  String get habitListTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// How many items are selected
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @deleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get deleteSelected;

  /// No description provided for @todayCheck.
  ///
  /// In en, this message translates to:
  /// **'Today ✓'**
  String get todayCheck;

  /// No description provided for @todayUncheck.
  ///
  /// In en, this message translates to:
  /// **'Remove today\'s check'**
  String get todayUncheck;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @noSelection.
  ///
  /// In en, this message translates to:
  /// **'No selected item'**
  String get noSelection;

  /// No description provided for @itemsDeleted.
  ///
  /// In en, this message translates to:
  /// **'{count} item(s) deleted'**
  String itemsDeleted(int count);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @itemDeleted.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" deleted'**
  String itemDeleted(String name);

  /// No description provided for @addHabit.
  ///
  /// In en, this message translates to:
  /// **'Add Habit'**
  String get addHabit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @noHabitsHint.
  ///
  /// In en, this message translates to:
  /// **'No habits yet.\nUse the + button below to add.'**
  String get noHabitsHint;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get turkish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @addHabitTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Habit'**
  String get addHabitTitle;

  /// No description provided for @habitName.
  ///
  /// In en, this message translates to:
  /// **'Habit name'**
  String get habitName;

  /// No description provided for @habitNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Drink water'**
  String get habitNameHint;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @editHabitTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Habit'**
  String get editHabitTitle;

  /// No description provided for @newName.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get newName;

  /// No description provided for @newNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Morning water'**
  String get newNameHint;

  /// No description provided for @updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateButton;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @noChange.
  ///
  /// In en, this message translates to:
  /// **'You didn’t change anything.'**
  String get noChange;

  /// No description provided for @nameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty.'**
  String get nameEmptyError;

  /// No description provided for @detailTitleFor.
  ///
  /// In en, this message translates to:
  /// **'Detail: {name}'**
  String detailTitleFor(String name);

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get last7Days;

  /// No description provided for @successLabel.
  ///
  /// In en, this message translates to:
  /// **'Success: {done}/7  (%{percent})'**
  String successLabel(int done, int percent);

  /// No description provided for @toggleTodayOn.
  ///
  /// In en, this message translates to:
  /// **'Mark Today ✓'**
  String get toggleTodayOn;

  /// No description provided for @toggleTodayOff.
  ///
  /// In en, this message translates to:
  /// **'Today ✓ (Undo)'**
  String get toggleTodayOff;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @duplicateName.
  ///
  /// In en, this message translates to:
  /// **'This habit name already exists.'**
  String get duplicateName;

  /// No description provided for @importJsonFile.
  ///
  /// In en, this message translates to:
  /// **'Import JSON backup'**
  String get importJsonFile;

  /// No description provided for @importJsonFileSub.
  ///
  /// In en, this message translates to:
  /// **'Load and merge from a .json file'**
  String get importJsonFileSub;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'{count} records imported'**
  String importSuccess(int count);

  /// No description provided for @importNothing.
  ///
  /// In en, this message translates to:
  /// **'No new records to import'**
  String get importNothing;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed'**
  String get importFailed;

  /// No description provided for @invalidBackupFile.
  ///
  /// In en, this message translates to:
  /// **'Invalid backup file'**
  String get invalidBackupFile;

  /// No description provided for @onbTitle1.
  ///
  /// In en, this message translates to:
  /// **'Track your habits'**
  String get onbTitle1;

  /// No description provided for @onbDesc1.
  ///
  /// In en, this message translates to:
  /// **'Create daily routines and mark them ✓.'**
  String get onbDesc1;

  /// No description provided for @onbTitle2.
  ///
  /// In en, this message translates to:
  /// **'See your progress'**
  String get onbTitle2;

  /// No description provided for @onbDesc2.
  ///
  /// In en, this message translates to:
  /// **'Weekly bars show your streaks.'**
  String get onbDesc2;

  /// No description provided for @onbTitle3.
  ///
  /// In en, this message translates to:
  /// **'Backup & Import'**
  String get onbTitle3;

  /// No description provided for @onbDesc3.
  ///
  /// In en, this message translates to:
  /// **'Export JSON backups, import and merge safely.'**
  String get onbDesc3;

  /// No description provided for @onbNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onbNext;

  /// No description provided for @onbSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onbSkip;

  /// No description provided for @onbStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onbStart;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark2.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark2;

  /// No description provided for @downloadJsonFile.
  ///
  /// In en, this message translates to:
  /// **'Download JSON backup'**
  String get downloadJsonFile;

  /// No description provided for @downloadJsonFileSub.
  ///
  /// In en, this message translates to:
  /// **'Save to the Downloads folder'**
  String get downloadJsonFileSub;

  /// No description provided for @savedToDownloads.
  ///
  /// In en, this message translates to:
  /// **'Saved to Downloads'**
  String get savedToDownloads;

  /// No description provided for @openAction.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openAction;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed'**
  String get backupFailed;

  /// No description provided for @cannotOpenFile.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t open the file on this device.'**
  String get cannotOpenFile;

  /// No description provided for @openFilesApp.
  ///
  /// In en, this message translates to:
  /// **'Open Files app'**
  String get openFilesApp;

  /// No description provided for @shareFile.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareFile;

  /// No description provided for @previewJson.
  ///
  /// In en, this message translates to:
  /// **'Preview JSON backup'**
  String get previewJson;

  /// No description provided for @previewJsonSub.
  ///
  /// In en, this message translates to:
  /// **'View the JSON text in a dialog'**
  String get previewJsonSub;

  /// No description provided for @copyJson.
  ///
  /// In en, this message translates to:
  /// **'Copy JSON to clipboard'**
  String get copyJson;

  /// No description provided for @copyJsonSub.
  ///
  /// In en, this message translates to:
  /// **'Use for quick testing without apps'**
  String get copyJsonSub;

  /// No description provided for @importDetail.
  ///
  /// In en, this message translates to:
  /// **'{added} added, {merged} merged'**
  String importDetail(int added, int merged);

  /// No description provided for @importSummary.
  ///
  /// In en, this message translates to:
  /// **'{added} new, {merged} merged'**
  String importSummary(int added, int merged);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
