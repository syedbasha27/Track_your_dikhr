import 'package:flutter_test/flutter_test.dart';
import 'package:track_your_nekhi/constants/noor_config.dart';
import 'package:track_your_nekhi/models/daily_log.dart';
import 'package:track_your_nekhi/models/streak_model.dart';
import 'package:track_your_nekhi/utils/noor_calculator.dart';

void main() {
  group('NoorCalculator', () {
    test('returns 0 for empty log', () {
      final log = DailyLog.empty('2026-02-27');
      final streak = StreakModel.empty();
      expect(NoorCalculator.calculate(log, streak), 0);
    });

    test('counts fard prayers correctly', () {
      final log = DailyLog.empty('2026-02-27').copyWith(
        prayers: {
          'fajr': true,
          'dhuhr': true,
          'asr': false,
          'maghrib': false,
          'isha': false,
        },
      );
      final streak = StreakModel.empty();
      // 2 prayers * 20 pts = 40
      expect(NoorCalculator.calculate(log, streak), 40);
    });

    test('counts dhikr completions correctly', () {
      final log = DailyLog.empty('2026-02-27').copyWith(
        dhikr: {
          'subhanallah': 100,
          'astaghfirullah': 50,
          'la_ilaha': 0,
        },
      );
      final streak = StreakModel.empty();
      // 1 completed set * 15 pts = 15
      expect(NoorCalculator.calculate(log, streak), 15);
    });

    test('counts character deeds correctly', () {
      final log = DailyLog.empty('2026-02-27').copyWith(
        character: {
          'anger': true,
          'forgive': true,
          'help': false,
          'backbiting': false,
        },
      );
      final streak = StreakModel.empty();
      // 2 deeds * 25 pts = 50
      expect(NoorCalculator.calculate(log, streak), 50);
    });

    test('applies streak multiplier when streak > threshold', () {
      final log = DailyLog.empty('2026-02-27').copyWith(
        prayers: {
          'fajr': true,
          'dhuhr': false,
          'asr': false,
          'maghrib': false,
          'isha': false,
        },
      );
      // streak > 1 triggers +10%
      final streak = StreakModel(
        currentStreak: 3,
        longestStreak: 3,
        lastActiveDate: '2026-02-27',
      );
      // base = 20, with 10% = 22
      expect(NoorCalculator.calculate(log, streak), 22);
    });

    test('max daily score without streak', () {
      final log = DailyLog.empty('2026-02-27').copyWith(
        prayers: {
          'fajr': true,
          'dhuhr': true,
          'asr': true,
          'maghrib': true,
          'isha': true,
        },
        dhikr: {
          'subhanallah': 100,
          'astaghfirullah': 100,
          'la_ilaha': 100,
        },
        character: {
          'anger': true,
          'forgive': true,
          'help': true,
          'backbiting': true,
        },
      );
      final streak = StreakModel.empty();
      expect(NoorCalculator.calculate(log, streak),
          NoorConfig.maxDailyBase); // 245
    });

    test('completedPrayers counts correctly', () {
      final log = DailyLog.empty('2026-02-27').copyWith(
        prayers: {
          'fajr': true,
          'dhuhr': true,
          'asr': false,
          'maghrib': false,
          'isha': true,
        },
      );
      expect(NoorCalculator.completedPrayers(log), 3);
    });

    test('completedDhikrSets counts correctly', () {
      final log = DailyLog.empty('2026-02-27').copyWith(
        dhikr: {
          'subhanallah': 100,
          'astaghfirullah': 99,
          'la_ilaha': 100,
        },
      );
      expect(NoorCalculator.completedDhikrSets(log), 2);
    });

    test('completedCharacterDeeds counts correctly', () {
      final log = DailyLog.empty('2026-02-27').copyWith(
        character: {
          'anger': true,
          'forgive': false,
          'help': true,
          'backbiting': true,
        },
      );
      expect(NoorCalculator.completedCharacterDeeds(log), 3);
    });
  });

  group('DailyLog', () {
    test('empty() initialises all fields to false/zero', () {
      final log = DailyLog.empty('2026-02-27');
      expect(log.prayers.values.every((v) => v == false), true);
      expect(log.dhikr.values.every((v) => v == 0), true);
      expect(log.character.values.every((v) => v == false), true);
      expect(log.noorScore, 0);
    });

    test('fromMap() and toMap() round-trip', () {
      final original = DailyLog(
        date: '2026-02-27',
        prayers: {'fajr': true, 'dhuhr': false, 'asr': true, 'maghrib': false, 'isha': true},
        dhikr: {'subhanallah': 33, 'astaghfirullah': 0, 'la_ilaha': 100},
        character: {'anger': true, 'forgive': false, 'help': true, 'backbiting': false},
        noorScore: 155,
      );
      final map = original.toMap();
      final restored = DailyLog.fromMap(map);
      expect(restored.date, original.date);
      expect(restored.prayers, original.prayers);
      expect(restored.dhikr, original.dhikr);
      expect(restored.character, original.character);
      expect(restored.noorScore, original.noorScore);
    });
  });

  group('StreakModel', () {
    test('empty() returns zero streak', () {
      final streak = StreakModel.empty();
      expect(streak.currentStreak, 0);
      expect(streak.longestStreak, 0);
      expect(streak.lastActiveDate, '');
    });

    test('fromMap() and toMap() round-trip', () {
      final original = StreakModel(
        currentStreak: 5,
        longestStreak: 12,
        lastActiveDate: '2026-02-27',
      );
      final map = original.toMap();
      final restored = StreakModel.fromMap(map);
      expect(restored.currentStreak, original.currentStreak);
      expect(restored.longestStreak, original.longestStreak);
      expect(restored.lastActiveDate, original.lastActiveDate);
    });
  });
}
