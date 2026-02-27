import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../constants/app_strings.dart';
import '../constants/hadith_data.dart';
import '../constants/noor_config.dart';
import '../providers/daily_log_provider.dart';
import '../providers/streak_provider.dart';
import '../widgets/dhikr_counter.dart';

/// Daily Dhikr screen — three counters with bead-style buttons
class DhikrScreen extends StatelessWidget {
  const DhikrScreen({super.key});

  static const List<Map<String, String>> _dhikrList = [
    {
      'key': 'subhanallah',
      'text': 'SubhanAllahi wa bihamdihi',
      'reward': HadithData.subhanallahReward,
    },
    {
      'key': 'astaghfirullah',
      'text': 'Astaghfirullah',
      'reward': HadithData.astaghfirullahReward,
    },
    {
      'key': 'la_ilaha',
      'text': 'La ilaha illa Allah wahdahu la sharika lah',
      'reward': HadithData.laIlahaReward,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final log = context.watch<DailyLogProvider>().log;
    final dhikr = log?.dhikr ?? {};
    final streak = context.watch<StreakProvider>().streak;
    final logProvider = context.read<DailyLogProvider>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundBeige,
      appBar: AppBar(
        title: const Text(AppStrings.dhikrTitle),
      ),
      body: Column(
        children: [
          Container(
            color: AppTheme.primaryDarkGreen,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: const Text(
              AppStrings.resetDaily,
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _dhikrList.length,
              itemBuilder: (context, i) {
                final item = _dhikrList[i];
                final key = item['key']!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DhikrCounter(
                    dhikrText: item['text']!,
                    rewardText: item['reward']!,
                    count: dhikr[key] ?? 0,
                    onIncrement: () => logProvider.incrementDhikr(
                      key,
                      streak,
                      NoorConfig.dhikrTarget,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
