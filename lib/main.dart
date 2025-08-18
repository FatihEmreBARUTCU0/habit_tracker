import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/habit_list_screen.dart';

void main() {
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
