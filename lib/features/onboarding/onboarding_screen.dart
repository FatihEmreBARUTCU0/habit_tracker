import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker/l10n/generated/app_localizations.dart';
import 'package:habit_tracker/core/settings/prefs_keys.dart';
import 'package:habit_tracker/features/habits/presentation/screens/habit_list_screen.dart';

// ✨ Eklendi: Neon bileşenleri
import 'package:habit_tracker/ui/widgets/neon_scaffold.dart';
import 'package:habit_tracker/ui/widgets/glass_card.dart';
import 'package:habit_tracker/ui/widgets/neon_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kOnboardingSeenKey, true); // ✅ sabit anahtar
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HabitListScreen()),
    ); // ✅ named route yok, import kullanıldı
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final pages = [
      _OnbPage(title: t.onbTitle1, desc: t.onbDesc1, icon: Icons.check_circle_outline),
      _OnbPage(title: t.onbTitle2, desc: t.onbDesc2, icon: Icons.insights_outlined),
      _OnbPage(title: t.onbTitle3, desc: t.onbDesc3, icon: Icons.ios_share_rounded),
    ];

    return NeonScaffold(
      withTopGlow: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => pages[i], // _OnbPage widget'ını kullanıyoruz
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (i) {
                final isActive = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  height: 8,
                  width: isActive ? 20 : 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _finish,
                    child: Text(t.onbSkip),
                  ),
                  const Spacer(),
                  NeonButton(
                    text: _index < pages.length - 1 ? t.onbNext : t.onbStart,
                    onPressed: () async {
                      if (_index < pages.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOut,
                        );
                      } else {
                        await _finish();
                      }
                    },
                    expanded: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnbPage extends StatelessWidget {
  final String title;
  final String desc;
  final IconData icon;
  const _OnbPage({required this.title, required this.desc, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 96),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
