import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../constants/app_strings.dart';
import '../providers/auth_provider.dart' as app_auth;
import '../providers/daily_log_provider.dart';
import '../providers/streak_provider.dart';
import '../widgets/prayer_card.dart';
import '../widgets/post_prayer_modal.dart';

/// Salah Tracker — mark Fard prayers complete for today
class SalahTrackerScreen extends StatelessWidget {
  const SalahTrackerScreen({super.key});

  static const List<Map<String, String>> _prayers = [
    {'key': 'fajr', 'name': AppStrings.fajr},
    {'key': 'dhuhr', 'name': AppStrings.dhuhr},
    {'key': 'asr', 'name': AppStrings.asr},
    {'key': 'maghrib', 'name': AppStrings.maghrib},
    {'key': 'isha', 'name': AppStrings.isha},
  ];

  Future<void> _toggle(BuildContext context, String prayerKey) async {
    final uid = context.read<app_auth.AuthProvider>().firebaseUser?.uid;
    if (uid == null) return;

    final logProvider = context.read<DailyLogProvider>();
    final streak = context.read<StreakProvider>().streak;

    final wasCompleted = logProvider.log?.prayers[prayerKey] ?? false;
    await logProvider.togglePrayer(prayerKey, streak);

    // Show post-prayer modal when marking complete (not incomplete)
    if (!wasCompleted && context.mounted) {
      PostPrayerModal.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final log = context.watch<DailyLogProvider>().log;
    final prayers = log?.prayers ?? {};
    final completedCount = prayers.values.where((v) => v).length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundBeige,
      appBar: AppBar(title: const Text(AppStrings.salahTitle)),
      body: Column(
        children: [
          // Header bar
          Container(
            color: AppTheme.primaryDarkGreen,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$completedCount/5 prayers completed',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  completedCount == 5 ? '🌟 All done!' : '${5 - completedCount} remaining',
                  style: const TextStyle(
                    color: AppTheme.accentGold,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _prayers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 2),
              itemBuilder: (context, i) {
                final p = _prayers[i];
                final key = p['key']!;
                return PrayerCard(
                  prayerName: p['name']!,
                  isCompleted: prayers[key] ?? false,
                  onTap: () => _toggle(context, key),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
