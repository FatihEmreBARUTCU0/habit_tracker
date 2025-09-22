import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker/l10n/generated/app_localizations.dart';
import 'package:habit_tracker/core/settings/prefs_keys.dart';
import 'package:habit_tracker/features/habits/presentation/screens/habit_list_screen.dart';

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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => pages[i],
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
                        : Theme.of(context).colorScheme.primary.withValues(alpha:0.4),
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
                  ElevatedButton(
                    onPressed: () async {
                      if (_index < pages.length - 1) {
                        _controller.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
                      } else {
                        await _finish();
                      }
                    },
                    child: Text(_index < pages.length - 1 ? t.onbNext : t.onbStart),
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 96),
          const SizedBox(height: 24),
          Text(title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(desc, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
