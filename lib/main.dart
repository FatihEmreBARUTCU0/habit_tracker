import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/habit_list_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> showTestNotificationIn5s() async {
  // 5 sn bekle
  await Future.delayed(const Duration(seconds: 5));

  const androidDetails = AndroidNotificationDetails(
    'test_channel_id',
    'Test Channel',
    channelDescription: 'Deneme bildirimi kanalı',
    importance: Importance.max,
    priority: Priority.high,
  );
  const details = NotificationDetails(android: androidDetails);

  // Anında göster (biz zaten 5 sn bekledik)
  await flutterLocalNotificationsPlugin.show(
    1,
    'Alışkanlık Hatırlatma',
    'Bu bir test bildirimi (5 sn sonra).',
    details,
    payload: 'test',
  );
}




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Zaman dilimi ayarı (planlı bildirimlerde doğru zaman için)
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

  // Bildirim plugin’ini initialize et
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

    // ⬇️ Android 13+ runtime izin + kanal
  final androidPlugin = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  await androidPlugin?.requestNotificationsPermission();

  await androidPlugin?.createNotificationChannel(const AndroidNotificationChannel(
    'test_channel_id',
    'Test Channel',
    description: 'Deneme bildirimi kanalı',
     importance: Importance.max,
  ));

await showTestNotificationIn5s(); // 5 sn sonra bildirimi görmelisin


  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Palette
  static const Color _primary = Color(0xFF7C3AED);   // mor
  static const Color _secondary = Color(0xFFFF4D8D); // pembe (canlı)
  static const Color _bg = Color(0xFFFBF4FF);        // çok açık lila arka plan

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: _primary,
      onPrimary: Colors.white,
      secondary: _secondary,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: const Color(0xFF1F1A24), // koyu morumsu gri metin
      secondaryContainer: const Color(0xFFFFE1EC), // pembe yumuşak alanlar
      onSecondaryContainer: const Color(0xFF451A2A),
      primaryContainer: const Color(0xFFE9D5FF),   // mor yumuşak alanlar
      onPrimaryContainer: const Color(0xFF2E1065),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alışkanlık Takip',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: _bg, // 💜 lila arka plan

        appBarTheme: AppBarTheme(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          centerTitle: true,
          elevation: 1.5,
          titleTextStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white,
          ),
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: scheme.secondary,     // 💖 pembe FAB
          foregroundColor: scheme.onSecondary,   // beyaz ikon
          elevation: 2,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: scheme.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: scheme.primary, width: 1.4),
          ),
        ),

        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: scheme.secondaryContainer,
          contentTextStyle: TextStyle(color: scheme.onSecondaryContainer),
          actionTextColor: scheme.primary,
        ),
      ),
      home: const HabitListScreen(),
    );
  }
}
