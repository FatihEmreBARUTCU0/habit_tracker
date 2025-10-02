import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard
import 'package:provider/provider.dart';

import 'package:habit_tracker/core/settings/app_settings.dart';
import 'package:habit_tracker/l10n/generated/app_localizations.dart';

import 'package:habit_tracker/core/backup/backup_service.dart';
import 'package:habit_tracker/core/backup/import_service.dart';
import 'package:habit_tracker/features/habits/presentation/habits_controller.dart';

// ✨ Neon bileşenleri
import 'package:habit_tracker/ui/widgets/neon_scaffold.dart';
import 'package:habit_tracker/ui/widgets/neon_app_bar.dart';
import 'package:habit_tracker/ui/widgets/glass_card.dart';
import 'package:habit_tracker/ui/widgets/neon_button.dart';
import 'package:habit_tracker/ui/widgets/neon_outline_card.dart'; // ✅ eklendi

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _openJsonActionsSheet() {
    final t = AppLocalizations.of(context);
    final c = context.read<HabitsController>();
    final messenger = ScaffoldMessenger.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GlassCard(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    t.backup,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),

                  // 1) Share
                  NeonButton(
                    text: t.exportJsonFile,
                    onPressed: () async {
                      if (c.items.isEmpty) {
                        messenger
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(content: Text(t.nothingToExport)));
                        return;
                      }
                      try {
                        await BackupService().shareBackup(c.items);
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        messenger
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(content: Text(t.sharedViaSystemSheet)));
                      } catch (_) {
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        messenger
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(content: Text(t.exportFailed)));
                      }
                    },
                  ),
                  const SizedBox(height: 8),

                  // 2) Download (picker ile)
                  NeonButton(
                    text: t.downloadJsonFile,
                    onPressed: () async {
                      if (c.items.isEmpty) {
                        messenger
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(content: Text(t.nothingToExport)));
                        return;
                      }

                      try {
                        final svc = BackupService();
                        final saved = await svc.saveBackupWithPicker(c.items);
                        if (!mounted) return;

                        Navigator.of(context).pop();

                        messenger
                          ..clearSnackBars()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                saved == null ? t.backupFailed : '${t.savedToDownloads}\n$saved',
                              ),
                              action: saved == null
                                  ? null
                                  : SnackBarAction(
                                      label: t.openAction, // "Aç"
                                      onPressed: () async {
                                        final ok = await svc.tryOpen(saved);
                                        if (!ok && mounted) {
                                          messenger
                                            ..clearSnackBars()
                                            ..showSnackBar(
                                              SnackBar(
                                                content: Text(t.cannotOpenFile),
                                                action: SnackBarAction(
                                                  label: t.shareFile, // "Paylaş"
                                                  onPressed: () async {
                                                    await svc.shareBackup(c.items);
                                                  },
                                                ),
                                              ),
                                            );
                                        }
                                      },
                                    ),
                            ),
                          );
                      } catch (_) {
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        messenger
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(content: Text(t.backupFailed)));
                      }
                    },
                  ),
                  const SizedBox(height: 8),

                  // 3) Import
                  NeonButton(
                    text: t.importJsonFile,
                    onPressed: () async {
                      try {
                        final incoming = await ImportService().pickAndParse();
                        if (!mounted) return;

                        if (incoming.isEmpty) {
                          Navigator.of(context).pop();
                          messenger
                            ..clearSnackBars()
                            ..showSnackBar(SnackBar(content: Text(t.importNothing)));
                          return;
                        }

                        final res = await c.importHabits(incoming);
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        messenger
                          ..clearSnackBars()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                (res.added + res.merged) == 0
                                    ? t.importNothing
                                    : t.importSummary(res.added, res.merged),
                              ),
                            ),
                          );
                      } catch (_) {
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        messenger
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(content: Text(t.invalidBackupFile)));
                      }
                    },
                  ),
                  const SizedBox(height: 8),

                  // 4) Preview
                  OutlinedButton.icon(
                    icon: const Icon(Icons.visibility_outlined),
                    label: Text(t.previewJson),
                    onPressed: () async {
                      if (c.items.isEmpty) {
                        messenger
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(content: Text(t.nothingToExport)));
                        return;
                      }
                      final json = await BackupService().buildBackupJson(c.items);
                      if (!mounted) return;

                      Navigator.of(context).pop(); // sheet
                      if (!mounted) return;
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(t.backupJsonTitle),
                          content: SingleChildScrollView(
                            child: SelectableText(
                              json,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(t.cancel),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),

                  // 5) Copy
                  OutlinedButton.icon(
                    icon: const Icon(Icons.copy_all_outlined),
                    label: Text(t.copyJson),
                    onPressed: () async {
                      if (c.items.isEmpty) {
                        messenger
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(content: Text(t.nothingToExport)));
                        return;
                      }
                      final json = await BackupService().buildBackupJson(c.items);
                      await Clipboard.setData(ClipboardData(text: json));
                      if (!mounted) return;
                      Navigator.of(context).pop();
                      messenger
                        ..clearSnackBars()
                        ..showSnackBar(SnackBar(content: Text(t.jsonCopied)));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final t = AppLocalizations.of(context);

    return NeonScaffold(
      appBar: NeonAppBar(
        title: Text(t.settingsTitle),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------- GENEL ----------
          NeonOutlineCard(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            radius: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.general,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                // Tema
                ListTile(
                  title: Text(t.theme),
                  trailing: DropdownButton<ThemeMode>(
                    value: settings.themeMode,
                    onChanged: (mode) {
                      if (mode == null) return;
                      settings.setThemeMode(mode);
                    },
                    items: [
                      DropdownMenuItem(value: ThemeMode.system, child: Text(t.themeSystem)),
                      DropdownMenuItem(value: ThemeMode.light, child: Text(t.themeLight)),
                      DropdownMenuItem(value: ThemeMode.dark, child: Text(t.themeDark2)),
                    ],
                    isDense: true,
                    underline: const SizedBox.shrink(),
                  ),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),

                // Dil
                ListTile(
                  title: Text(t.language),
                  trailing: DropdownButton<String>(
                    value: settings.languageCode,
                    onChanged: (code) {
                      if (code == null) return;
                      settings.setLanguage(code);
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

          // ---------- YEDEKLEME ----------
          NeonOutlineCard(
            padding: const EdgeInsets.all(12),
            radius: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.backup,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                // Tek “JSON actions” satırı
                ListTile(
                  leading: const Icon(Icons.auto_awesome),
                  title: Text(t.jsonActions),
                  subtitle: Text(t.jsonActionsSub),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  onTap: _openJsonActionsSheet,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
