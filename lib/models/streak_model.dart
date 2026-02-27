/// Represents the user's streak data
class StreakModel {
  final int currentStreak;
  final int longestStreak;
  final String lastActiveDate; // 'yyyy-MM-dd'

  const StreakModel({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActiveDate,
  });

  factory StreakModel.empty() => const StreakModel(
        currentStreak: 0,
        longestStreak: 0,
        lastActiveDate: '',
      );

  factory StreakModel.fromMap(Map<String, dynamic> map) => StreakModel(
        currentStreak: (map['current_streak'] as num?)?.toInt() ?? 0,
        longestStreak: (map['longest_streak'] as num?)?.toInt() ?? 0,
        lastActiveDate: map['last_active_date'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'current_streak': currentStreak,
        'longest_streak': longestStreak,
        'last_active_date': lastActiveDate,
      };

  StreakModel copyWith({
    int? currentStreak,
    int? longestStreak,
    String? lastActiveDate,
  }) =>
      StreakModel(
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      );
}
