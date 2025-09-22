import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker/core/settings/prefs_keys.dart';

class StartGate extends StatelessWidget {
  final Widget home;
  final Widget onboarding;
  const StartGate({super.key, required this.home, required this.onboarding});

  Future<bool> _seen(BuildContext context) async {
    
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kOnboardingSeenKey) == true;

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _seen(context),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snap.data == true ? home : onboarding;
      },
    );
  }
}
