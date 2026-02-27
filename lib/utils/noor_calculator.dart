import '../constants/noor_config.dart';
import '../models/daily_log.dart';
import '../models/streak_model.dart';

/// Client-side Noor Score calculator — no cloud functions needed
class NoorCalculator {
  /// Calculate the Noor Score for a given daily log and streak
  static int calculate(DailyLog log, StreakModel streak) {
    int base = 0;

    // Fard prayers: 20 pts each
    for (final done in log.prayers.values) {
      if (done) base += NoorConfig.fardPrayerPoints;
    }

    // Dhikr completions: 15 pts each when count >= 100
    for (final count in log.dhikr.values) {
      if (count >= NoorConfig.dhikrTarget) {
        base += NoorConfig.dhikrCompletionPoints;
      }
    }

    // Character deeds: 25 pts each
    for (final done in log.character.values) {
      if (done) base += NoorConfig.characterDeedPoints;
    }

    // Apply streak multiplier if streak > threshold
    if (streak.currentStreak > NoorConfig.streakThreshold) {
      base = (base * (1 + NoorConfig.streakMultiplier)).round();
    }

    return base;
  }

  /// Count completed Fard prayers
  static int completedPrayers(DailyLog log) =>
      log.prayers.values.where((v) => v).length;

  /// Count completed character deeds
  static int completedCharacterDeeds(DailyLog log) =>
      log.character.values.where((v) => v).length;

  /// Count dhikr sets completed (reached target)
  static int completedDhikrSets(DailyLog log) =>
      log.dhikr.values.where((v) => v >= NoorConfig.dhikrTarget).length;
}
