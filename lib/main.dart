import 'package:flutter/material.dart';
import 'package:habit_tracker/features/habits/presentation/screens/habit_list_screen.dart';
import 'package:habit_tracker/core/settings/app_settings.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker/features/habits/data/habits_repository.dart';
import 'package:habit_tracker/features/habits/presentation/habits_controller.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:habit_tracker/l10n/generated/app_localizations.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> showTestNotificationIn5s() async {
  await Future.delayed(const Duration(seconds: 5));
  const androidDetails = AndroidNotificationDetails(
    'test_channel_id',
    'Test Channel',
    channelDescription: 'Deneme bildirimi kanalı',
    importance: Importance.max,
    priority: Priority.high,
  );
  const details = NotificationDetails(android: androidDetails);
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

  // Timezone + bildirim init
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  final androidPlugin = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.requestNotificationsPermission();
  await androidPlugin?.createNotificationChannel(
    const AndroidNotificationChannel(
      'test_channel_id',
      'Test Channel',
      description: 'Deneme bildirimi kanalı',
      importance: Importance.max,
    ),
  );

  await showTestNotificationIn5s();

  // Settings
  final settings = await AppSettings.load();

  // Habits repo + controller
  final prefs = await SharedPreferences.getInstance();
  final repo  = HabitsRepository(prefs);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppSettings>.value(value: settings),
        ChangeNotifierProvider<HabitsController>(
          create: (_) => HabitsController(repo)..init(),
        ),
      ],
      child: const MyApp(),
    ),
  );
} // ←←← ÖNEMLİ: main() BURADA KAPANIYOR

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color _primary = Color(0xFF7C3AED);
  static const Color _secondary = Color(0xFFFF4D8D);
  static const Color _bg = Color(0xFFFBF4FF);
  static const Color _bgDark = Color(0xFF0F0D14);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: _primary,
      onPrimary: Colors.white,
      secondary: _secondary,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: const Color(0xFF1F1A24),
      secondaryContainer: const Color(0xFFFFE1EC),
      onSecondaryContainer: const Color(0xFF451A2A),
      primaryContainer: const Color(0xFFE9D5FF),
      onPrimaryContainer: const Color(0xFF2E1065),
    );

    final darkScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
    ).copyWith(
      surface: _bgDark,
      onSurface: const Color(0xFFE8E3F4),
      primary: _primary,
      onPrimary: Colors.white,
      secondary: _secondary,
      onSecondary: Colors.white,
      primaryContainer: const Color(0xFF3B2A63),
      onPrimaryContainer: Colors.white,
      secondaryContainer: const Color(0xFF5A1F3A),
      onSecondaryContainer: Colors.white,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('tr'), Locale('en')],
      locale: settings.locale,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: _bg,
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          centerTitle: true,
          elevation: 1.5,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: scheme.secondary,
          foregroundColor: scheme.onSecondary,
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

      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        scaffoldBackgroundColor: darkScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: darkScheme.primary,
          foregroundColor: darkScheme.onPrimary,
          centerTitle: true,
          elevation: 1.5,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: darkScheme.secondary,
          foregroundColor: darkScheme.onSecondary,
          elevation: 2,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkScheme.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: darkScheme.primary, width: 1.4),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: darkScheme.secondaryContainer,
          contentTextStyle: TextStyle(color: darkScheme.onSecondaryContainer),
          actionTextColor: darkScheme.primary,
        ),
      ),

      themeMode: settings.themeMode,
      home: const HabitListScreen(),
    );
  }
}
