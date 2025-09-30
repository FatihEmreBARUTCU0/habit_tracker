import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:habit_tracker/l10n/generated/app_localizations.dart';

import 'package:habit_tracker/features/habits/presentation/screens/habit_list_screen.dart';
import 'package:habit_tracker/features/onboarding/start_gate.dart';
import 'package:habit_tracker/features/onboarding/onboarding_screen.dart';
import 'package:habit_tracker/features/habits/data/habits_repository.dart';
import 'package:habit_tracker/features/habits/presentation/habits_controller.dart';
import 'package:habit_tracker/core/settings/app_settings.dart';

// ✨ NeonTheme eklentisi
import 'package:habit_tracker/ui/theme/neon_theme.dart';

// ✅ NeonFrame (dış glow çerçeve)
import 'package:habit_tracker/ui/widgets/neon_frame.dart';

// Opsiyonel debug aracı
import 'package:flutter/foundation.dart';
import 'debug/frame_stats.dart';

// ✅ Google Fonts
import 'package:google_fonts/google_fonts.dart';

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

  if (!kReleaseMode) {
    await showTestNotificationIn5s();
  }

  // Settings
  final settings = await AppSettings.load();

  // Habits repo + controller
  final prefs = await SharedPreferences.getInstance();
  final repo = HabitsRepository(prefs);

  if (!kReleaseMode) {
    // FrameStats.I.start();
    Future.delayed(const Duration(seconds: 15), () {
      FrameStats.I.stopAndPrint(label: 'Home idle+scroll');
    });
  }

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

// -----------------------------------------------------------------------------
// 🔧 Tema yardımcıları
// -----------------------------------------------------------------------------
ThemeData buildDarkTheme() {
  // Material 3 + seed tabanlı şema
  final baseScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF7A6BFF),
    brightness: Brightness.dark,
  );

  // Yeni yüzey alanları (Flutter M3 3.18+)
  final scheme = baseScheme.copyWith(
    surface: const Color(0xFF0F1426),
    // surfaceVariant yerine container hiyerarşisi:
    surfaceContainerHighest: const Color(0xFF131A2E),
    surfaceContainerHigh: const Color(0xFF111A2A),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
     scaffoldBackgroundColor: const Color(0xFF130C16),

    // Outfit tipografi
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),

    // ✨ NeonTheme eklentisi (dark)
    extensions: const <ThemeExtension<dynamic>>[
      NeonTheme.dark,
    ],

    // Hafif şeffaf AppBar
    appBarTheme: AppBarTheme(
      // withOpacity deprecated → withValues
      backgroundColor: scheme.surface.withValues(alpha: 0.10),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      foregroundColor: scheme.onPrimary,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
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
      fillColor: scheme.surfaceContainerHigh,
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
  );
}

// -----------------------------------------------------------------------------
// 🧱 HomeShell: StartGate'in 'home'una vereceğimiz kılıf
// -----------------------------------------------------------------------------
class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Dark modda dış çerçeveyi kapat (daha sade görünüm)
    if (isDark) {
      return const HabitListScreen();
    }

    // Light modda çerçeve var ama radials KAPALI
    return const NeonFrame(
      showRadials: false,  // 🔒 kapalı
      borderWidth: 1.5,    // biraz daha ince kenar
      child: HabitListScreen(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color _primary = Color(0xFF7C3AED);
  static const Color _secondary = Color(0xFFFF4D8D);
 static const Color _bgLight = Color(0xFFFFF3EF);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    // LIGHT ColorScheme
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
      // (İsteğe bağlı) Light için de container hiyerarşisini set edebilirsin:
      // surfaceContainerHighest: const Color(0xFFF2ECFF),
      // surfaceContainerHigh: const Color(0xFFF6F3FF),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('tr'), Locale('en')],
      locale: settings.locale,

      // ✅ LIGHT THEME
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: _bgLight,

        // Outfit tipografi
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),

        // ✨ NeonTheme eklentisi (light)
        extensions: const <ThemeExtension<dynamic>>[
          NeonTheme.light,
        ],

        appBarTheme: AppBarTheme(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          centerTitle: true,
          elevation: 1.5,
          titleTextStyle: GoogleFonts.outfit(
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

      // ✅ DARK THEME (fonksiyonla)
      darkTheme: buildDarkTheme(),

      themeMode: settings.themeMode,

      // StartGate akışı korunuyor; sadece 'home' artık HomeShell
      home: const StartGate(
        home: HomeShell(),
        onboarding: OnboardingScreen(),
      ),
    );
  }
}
