import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../constants/hadith_data.dart';
import '../constants/app_strings.dart';

/// Modal shown after marking a prayer complete with post-prayer dhikr reminders
class PostPrayerModal extends StatelessWidget {
  const PostPrayerModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PostPrayerModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.backgroundBeige,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              '🌟 ${AppStrings.prayerComplete}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryDarkGreen,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              AppStrings.mashaAllah,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.accentGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Tasbeeh Fatimah card
          _ReminderCard(
            title: AppStrings.tasbeehFatimahTitle,
            body: HadithData.tasbeehFatimahText,
            reward: HadithData.tasbeehFatimahReward,
          ),
          const SizedBox(height: 12),
          // Ayatul Kursi card
          _ReminderCard(
            title: AppStrings.ayatulKursiTitle,
            body: HadithData.ayatulKursiText,
            reward: HadithData.ayatulKursiReward,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.close),
          ),
        ],
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final String title;
  final String body;
  final String reward;

  const _ReminderCard({
    required this.title,
    required this.body,
    required this.reward,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppTheme.primaryDarkGreen,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
          ),
          const SizedBox(height: 6),
          Text(
            reward,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
