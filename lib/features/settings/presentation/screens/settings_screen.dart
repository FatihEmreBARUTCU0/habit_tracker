import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard
import 'package:provider/provider.dart';

import 'package:habit_tracker/core/settings/app_settings.dart';
import 'package:habit_tracker/l10n/generated/app_localizations.dart';

import 'package:habit_tracker/core/backup/backup_service.dart';
import 'package:habit_tracker/core/backup/import_service.dart';
import 'package:habit_tracker/features/habits/presentation/habits_controller.dart';

import 'package:open_filex/open_filex.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.settingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ---------- Genel ----------
            Text(
              t.general,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

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

            const SizedBox(height: 8),

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

            const SizedBox(height: 24),

            // ---------- Yedekleme ----------
            Text(
              t.backup,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // 1) JSON yedeğini paylaş (share sheet)
            ListTile(
              leading: const Icon(Icons.ios_share_rounded),
              title: Text(t.exportJsonFile),
              subtitle: Text(t.exportJsonFileSub),
              dense: true,
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                final ctx = context;
                final c = ctx.read<HabitsController>();
                final t2 = AppLocalizations.of(ctx);
                final messenger = ScaffoldMessenger.of(ctx);

                if (c.items.isEmpty) {
                  messenger
                    ..clearSnackBars()
                    ..showSnackBar(SnackBar(content: Text(t2.nothingToExport)));
                  return;
                }

                try {
                  await BackupService().shareBackup(c.items);
                  if (!ctx.mounted) return;
                  messenger
                    ..clearSnackBars()
                    ..showSnackBar(SnackBar(content: Text(t2.sharedViaSystemSheet)));
                } catch (_) {
                  if (!ctx.mounted) return;
                  messenger
                    ..clearSnackBars()
                    ..showSnackBar(SnackBar(content: Text(t2.exportFailed)));
                }
              },
            ),

            // 2) JSON yedeğini indir (picker ile)
            ListTile(
              leading: const Icon(Icons.download_rounded),
              title: Text(t.downloadJsonFile),
              subtitle: Text(t.downloadJsonFileSub),
              dense: true,
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                final ctx = context;
                final c = ctx.read<HabitsController>();
                final t2 = AppLocalizations.of(ctx);
                final messenger = ScaffoldMessenger.of(ctx);

                if (c.items.isEmpty) {
                  messenger
                    ..clearSnackBars()
                    ..showSnackBar(SnackBar(content: Text(t2.nothingToExport)));
                  return;
                }

                try {
                  final saved = await BackupService().saveBackupWithPicker(c.items);
                  if (!ctx.mounted) return;

                  if (saved == null) {
                    messenger
                      ..clearSnackBars()
                      ..showSnackBar(SnackBar(content: Text(t2.backupFailed)));
                    return;
                  }

                  messenger
                    ..clearSnackBars()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('${t2.savedToDownloads}\n$saved'),
                        action: SnackBarAction(
                          label: t2.openAction,
                          onPressed: () async {
                            final r = await OpenFilex.open(saved);
                            if (r.type != ResultType.done) {
                              messenger
                                ..clearSnackBars()
                                ..showSnackBar(SnackBar(content: Text(t2.cannotOpenFile)));
                            }
                          },
                        ),
                        duration: const Duration(seconds: 4),
                      ),
                    );
                } catch (_) {
                  if (!ctx.mounted) return;
                  messenger
                    ..clearSnackBars()
                    ..showSnackBar(SnackBar(content: Text(t2.backupFailed)));
                }
              },
            ),

            // 3) JSON yedeğini içe aktar
            ListTile(
              leading: const Icon(Icons.file_download),
              title: Text(t.importJsonFile),
              subtitle: Text(t.importJsonFileSub),
              dense: true,
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                final ctx = context;
                final messenger = ScaffoldMessenger.of(ctx);
                final t2 = AppLocalizations.of(ctx);
                final c = ctx.read<HabitsController>();

                try {
                  final incoming = await ImportService().pickAndParse();

                  if (incoming.isEmpty) {
                    messenger
                      ..clearSnackBars()
                      ..showSnackBar(SnackBar(content: Text(t2.importNothing)));
                    return;
                  }

                  final res = await c.importHabits(incoming);

                  messenger
                    ..clearSnackBars()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          (res.added + res.merged) == 0
                              ? t2.importNothing
                              : t2.importSummary(res.added, res.merged)

                        ),
                      ),
                    );
                } catch (_) {
                  messenger
                    ..clearSnackBars()
                    ..showSnackBar(SnackBar(content: Text(t2.invalidBackupFile)));
                }
              },
            ),

            // 4) JSON önizle (dialog)
            ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: Text(t.previewJson),
              subtitle: Text(t.previewJsonSub),
              dense: true,
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                final ctx = context;
                final c = ctx.read<HabitsController>();
                final t2 = AppLocalizations.of(ctx);
                final messenger = ScaffoldMessenger.of(ctx);

                if (c.items.isEmpty) {
                  messenger
                    ..clearSnackBars()
                    ..showSnackBar(SnackBar(content: Text(t2.nothingToExport)));
                  return;
                }

                final json = await BackupService().buildBackupJson(c.items);
                if (!ctx.mounted) return;

                showDialog(
                  context: ctx,
                  builder: (_) => AlertDialog(
                    title: const Text('Backup JSON'),
                    content: SingleChildScrollView(
                      child: SelectableText(
                        json,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(t2.cancel),
                      ),
                    ],
                  ),
                );
              },
            ),

            // 5) JSON'u panoya kopyala (metin)
            ListTile(
              leading: const Icon(Icons.copy_all_outlined),
              title: Text(t.copyJson),
              subtitle: Text(t.copyJsonSub),
              dense: true,
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                final ctx = context;
                final c = ctx.read<HabitsController>();
                final t2 = AppLocalizations.of(ctx);
                final messenger = ScaffoldMessenger.of(ctx);

                if (c.items.isEmpty) {
                  messenger
                    ..clearSnackBars()
                    ..showSnackBar(SnackBar(content: Text(t2.nothingToExport)));
                  return;
                }

                final json = await BackupService().buildBackupJson(c.items);
                await Clipboard.setData(ClipboardData(text: json));
                if (!ctx.mounted) return;

                messenger
                  ..clearSnackBars()
                  ..showSnackBar(const SnackBar(content: Text('JSON copied')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
