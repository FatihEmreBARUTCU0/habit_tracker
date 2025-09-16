// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get habitListTitle => 'Alışkanlıklarım';

  @override
  String get cancel => 'İptal';

  @override
  String get settings => 'Ayarlar';

  @override
  String selectedCount(int count) {
    return '$count seçildi';
  }

  @override
  String get deleteSelected => 'Seçilenleri Sil';

  @override
  String get todayCheck => 'Bugün ✓';

  @override
  String get todayUncheck => 'Bugün işareti kaldır';

  @override
  String get edit => 'Düzenle';

  @override
  String get detail => 'Detay';

  @override
  String get noSelection => 'Seçili öğe yok';

  @override
  String itemsDeleted(int count) {
    return '$count öğe silindi';
  }

  @override
  String get undo => 'Geri Al';

  @override
  String itemDeleted(String name) {
    return '\"$name\" silindi';
  }

  @override
  String get addHabit => 'Alışkanlık Ekle';

  @override
  String get add => 'Ekle';

  @override
  String get noHabitsHint =>
      'Henüz alışkanlık yok.\nSağ alttaki + ile ekleyebilirsin.';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get themeDark => 'Koyu Tema';

  @override
  String get language => 'Dil';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'İngilizce';

  @override
  String get general => 'Genel';

  @override
  String get addHabitTitle => 'Alışkanlık Ekle';

  @override
  String get habitName => 'Alışkanlık adı';

  @override
  String get habitNameHint => 'Örn: Su içmek';

  @override
  String get save => 'Kaydet';

  @override
  String get editHabitTitle => 'Alışkanlık Düzenle';

  @override
  String get newName => 'Yeni ad';

  @override
  String get newNameHint => 'Örn: Sabah su içmek';

  @override
  String get updateButton => 'Güncelle';

  @override
  String get updated => 'Güncellendi.';

  @override
  String get noChange => 'Bir değişiklik yapmadın.';

  @override
  String get nameEmptyError => 'İsim boş olamaz.';

  @override
  String detailTitleFor(String name) {
    return 'Detay: $name';
  }

  @override
  String get last7Days => 'Son 7 Gün';

  @override
  String successLabel(int done, int percent) {
    return 'Başarı: $done/7  (%$percent)';
  }

  @override
  String get toggleTodayOn => 'Bugün ✓ İşaretle';

  @override
  String get toggleTodayOff => 'Bugün ✓ (Geri Al)';

  @override
  String get update => 'Güncelle';

  @override
  String get duplicateName => 'Bu alışkanlık adı zaten var.';
}
