import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/core/settings/app_settings.dart';

import 'package:habit_tracker/l10n/generated/app_localizations.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.settingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Basit bölüm başlığı (istersen arb'ye taşıyabilirsin)
            Text(
  t.general,
  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
),
            const SizedBox(height: 12),

            // === Tema seçimi (Dark / Light) ===
            SwitchListTile(
              title: Text(t.themeDark), // "Koyu"
              value: settings.themeMode == ThemeMode.dark,
              onChanged: (val) {
                settings.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),

            // === Dil seçimi (TR/EN) ===
            ListTile(
              title: Text(t.language),
              trailing: DropdownButton<String>(
                value: settings.languageCode, // 'tr' | 'en'
                onChanged: (code) {
                  if (code == null) return;
                  settings.setLanguage(code); // persist + notifyListeners
                },
                items: [
                  DropdownMenuItem(value: 'tr', child: Text(t.turkish)),
                  DropdownMenuItem(value: 'en', child: Text(t.english)),
                ],
                isDense: true,
                underline: const SizedBox.shrink(),
              ),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
