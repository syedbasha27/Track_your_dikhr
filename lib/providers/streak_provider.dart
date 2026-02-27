import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../models/streak_model.dart';
import '../services/firestore_service.dart';

/// Manages the user's streak data
class StreakProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();

  StreakModel _streak = StreakModel.empty();
  bool _isLoading = false;

  StreakModel get streak => _streak;
  bool get isLoading => _isLoading;

  String get _todayDate => DateFormat('yyyy-MM-dd').format(DateTime.now());

  String get _yesterdayDate => DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(const Duration(days: 1)));

  /// Load streak for a user and update if needed
  Future<void> loadStreak(String uid) async {
    _isLoading = true;
    notifyListeners();

    _streak = await _firestore.getStreak(uid);

    // Update streak based on last active date
    final today = _todayDate;
    final yesterday = _yesterdayDate;

    if (_streak.lastActiveDate == today) {
      // Already counted today — no change
    } else if (_streak.lastActiveDate == yesterday) {
      // Consecutive day — increment streak
      final newStreak = _streak.currentStreak + 1;
      _streak = _streak.copyWith(
        currentStreak: newStreak,
        longestStreak:
            newStreak > _streak.longestStreak ? newStreak : _streak.longestStreak,
        lastActiveDate: today,
      );
      await _firestore.saveStreak(uid, _streak);
    } else if (_streak.lastActiveDate != today) {
      // Streak broken — reset to 1
      _streak = _streak.copyWith(
        currentStreak: 1,
        lastActiveDate: today,
      );
      await _firestore.saveStreak(uid, _streak);
    }

    _isLoading = false;
    notifyListeners();
  }
}
