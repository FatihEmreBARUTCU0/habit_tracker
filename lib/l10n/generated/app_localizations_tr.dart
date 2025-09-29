// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get backup => 'Yedekleme';

  @override
  String get exportJsonFile => 'JSON yedeğini paylaş';

  @override
  String get exportJsonFileSub => 'Sistem paylaşım menüsü ile .json dosyası';

  @override
  String get sharedViaSystemSheet => 'Paylaşım menüsü açıldı';

  @override
  String get exportFailed => 'Dışa aktarma başarısız';

  @override
  String get nothingToExport => 'Dışa aktarılacak kayıt yok';

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

  @override
  String get importJsonFile => 'JSON yedeğini içe aktar';

  @override
  String get importJsonFileSub => 'Dosyadan .json yükle ve birleştir';

  @override
  String importSuccess(int count) {
    return '$count kayıt içe aktarıldı';
  }

  @override
  String get importNothing => 'İçe aktarılacak yeni kayıt yok';

  @override
  String get importFailed => 'İçe aktarma başarısız';

  @override
  String get invalidBackupFile => 'Geçersiz yedek dosyası';

  @override
  String get onbTitle1 => 'Alışkanlıklarını takip et';

  @override
  String get onbDesc1 => 'Günlük rutinler oluştur ve ✓ işaretle.';

  @override
  String get onbTitle2 => 'İlerlemeni gör';

  @override
  String get onbDesc2 => 'Haftalık çubuklar serilerini gösterir.';

  @override
  String get onbTitle3 => 'Yedekle & İçe Aktar';

  @override
  String get onbDesc3 =>
      'JSON yedeklerini dışa aktar, güvenle içe aktar ve birleştir.';

  @override
  String get onbNext => 'İleri';

  @override
  String get onbSkip => 'Atla';

  @override
  String get onbStart => 'Başla';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark2 => 'Koyu';

  @override
  String get downloadJsonFile => 'JSON yedeğini indir';

  @override
  String get downloadJsonFileSub => 'Downloads klasörüne kaydet';

  @override
  String get savedToDownloads => 'Downloads\'a kaydedildi';

  @override
  String get openAction => 'Aç';

  @override
  String get backupFailed => 'Yedekleme başarısız';

  @override
  String get cannotOpenFile => 'Bu cihazda dosya açılamadı.';

  @override
  String get openFilesApp => 'Dosyalar uygulamasını aç';

  @override
  String get shareFile => 'Paylaş';

  @override
  String get previewJson => 'JSON yedeğini önizle';

  @override
  String get previewJsonSub => 'JSON metnini bir pencerede göster';

  @override
  String get copyJson => 'JSON’u panoya kopyala';

  @override
  String get copyJsonSub => 'Uygulama olmadan hızlı test için';

  @override
  String get jsonCopied => 'JSON panoya kopyalandı';

  @override
  String importDetail(int added, int merged) {
    return '$added yeni, $merged birleştirildi';
  }

  @override
  String importSummary(int added, int merged) {
    return '$added yeni, $merged birleştirildi';
  }

  @override
  String get jsonActions => 'JSON İşlemleri';

  @override
  String get jsonActionsSub => 'Dışa aktar / indir / içe al / önizle';

  @override
  String get filterAll => 'Tümü';

  @override
  String get filterActive => 'Aktif';

  @override
  String get filterToday => 'Bugün ✓';

  @override
  String get todaySubtitleOn => 'Bugün ✓';

  @override
  String get todaySubtitleOff => 'Bugün işaretlenmedi';

  @override
  String get deleteOne => 'Sil';

  @override
  String get more => 'Daha fazla';
}
