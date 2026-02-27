// Noor Score configuration — edit point values here to adjust scoring
class NoorConfig {
  // Points per completed Fard prayer (5 prayers max = 100 points)
  static const int fardPrayerPoints = 20;

  // Points per completed Dhikr set (reached 100 count) (3 sets max = 45 points)
  static const int dhikrCompletionPoints = 15;

  // Points per character deed done (4 deeds max = 100 points)
  static const int characterDeedPoints = 25;

  // Maximum base score per day
  static const int maxDailyBase = 245;

  // Streak multiplier bonus percentage (e.g. 0.10 = +10%)
  static const double streakMultiplier = 0.10;

  // Minimum streak days to receive multiplier
  static const int streakThreshold = 1;

  // Dhikr target count
  static const int dhikrTarget = 100;
}
