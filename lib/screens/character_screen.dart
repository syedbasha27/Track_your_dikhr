import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../constants/app_strings.dart';
import '../constants/hadith_data.dart';
import '../providers/daily_log_provider.dart';
import '../providers/streak_provider.dart';
import '../widgets/character_toggle.dart';

/// Character Reflection (Muhasabah) screen — daily yes/no toggles
class CharacterScreen extends StatelessWidget {
  const CharacterScreen({super.key});

  static const List<Map<String, String>> _deeds = [
    {
      'key': 'anger',
      'label': AppStrings.angerLabel,
      'reward': HadithData.angerReward,
    },
    {
      'key': 'forgive',
      'label': AppStrings.forgiveLabel,
      'reward': HadithData.forgiveReward,
    },
    {
      'key': 'help',
      'label': AppStrings.helpLabel,
      'reward': HadithData.helpReward,
    },
    {
      'key': 'backbiting',
      'label': AppStrings.backbitingLabel,
      'reward': HadithData.backbitingReward,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final log = context.watch<DailyLogProvider>().log;
    final character = log?.character ?? {};
    final streak = context.watch<StreakProvider>().streak;
    final logProvider = context.read<DailyLogProvider>();

    final doneCount = character.values.where((v) => v).length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundBeige,
      appBar: AppBar(title: const Text(AppStrings.characterTitle)),
      body: Column(
        children: [
          Container(
            color: AppTheme.primaryDarkGreen,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.characterSubtitle,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  '$doneCount/4 reflections done today',
                  style: const TextStyle(
                    color: AppTheme.accentGold,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _deeds.length,
              itemBuilder: (context, i) {
                final deed = _deeds[i];
                final key = deed['key']!;
                return CharacterToggle(
                  label: deed['label']!,
                  rewardText: deed['reward']!,
                  isDone: character[key] ?? false,
                  onTap: () => logProvider.toggleCharacter(key, streak),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
