import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../constants/noor_config.dart';

/// Bead-style dhikr counter card
class DhikrCounter extends StatelessWidget {
  final String dhikrText;
  final String rewardText;
  final int count;
  final VoidCallback onIncrement;

  const DhikrCounter({
    super.key,
    required this.dhikrText,
    required this.rewardText,
    required this.count,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = count >= NoorConfig.dhikrTarget;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dhikrText,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        rewardText,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Bead-style circular button
                GestureDetector(
                  onTap: isComplete ? null : onIncrement,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isComplete
                          ? AppTheme.accentGold.withOpacity(0.2)
                          : AppTheme.primaryDarkGreen,
                      boxShadow: isComplete
                          ? []
                          : [
                              BoxShadow(
                                color: AppTheme.primaryDarkGreen.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ],
                    ),
                    child: Center(
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isComplete
                              ? AppTheme.accentGold
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (count / NoorConfig.dhikrTarget).clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                color: isComplete ? AppTheme.accentGold : AppTheme.primaryDarkGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isComplete
                  ? '✓ Completed! ($count/${NoorConfig.dhikrTarget})'
                  : '$count / ${NoorConfig.dhikrTarget}',
              style: TextStyle(
                fontSize: 12,
                color: isComplete ? AppTheme.accentGold : AppTheme.textMuted,
                fontWeight:
                    isComplete ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
