import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../models/daily_log.dart';
import '../models/streak_model.dart';
import '../services/firestore_service.dart';
import '../utils/noor_calculator.dart';

/// Manages the daily log (prayers, dhikr, character) for the current user
class DailyLogProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();

  DailyLog? _log;
  bool _isLoading = false;
  String? _uid;

  DailyLog? get log => _log;
  bool get isLoading => _isLoading;

  String get todayDate => DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// Load today's log for the given user. Creates an empty log if none exists.
  Future<void> loadTodayLog(String uid) async {
    _uid = uid;
    _isLoading = true;
    notifyListeners();

    final existing = await _firestore.getDailyLog(uid, todayDate);
    _log = existing ?? DailyLog.empty(todayDate);

    _isLoading = false;
    notifyListeners();
  }

  /// Toggle a prayer's completion status and save
  Future<void> togglePrayer(String prayer, StreakModel streak) async {
    if (_log == null || _uid == null) return;
    final updated = Map<String, bool>.from(_log!.prayers);
    updated[prayer] = !(updated[prayer] ?? false);

    _log = _log!.copyWith(prayers: updated);
    _recalcScore(streak);
    notifyListeners();
    await _save();
  }

  /// Increment a dhikr counter by 1 (capped at dhikr target)
  Future<void> incrementDhikr(
      String dhikrKey, StreakModel streak, int target) async {
    if (_log == null || _uid == null) return;
    final updated = Map<String, int>.from(_log!.dhikr);
    updated[dhikrKey] = ((updated[dhikrKey] ?? 0) + 1).clamp(0, target);

    _log = _log!.copyWith(dhikr: updated);
    _recalcScore(streak);
    notifyListeners();
    await _save();
  }

  /// Toggle a character deed and save
  Future<void> toggleCharacter(String key, StreakModel streak) async {
    if (_log == null || _uid == null) return;
    final updated = Map<String, bool>.from(_log!.character);
    updated[key] = !(updated[key] ?? false);

    _log = _log!.copyWith(character: updated);
    _recalcScore(streak);
    notifyListeners();
    await _save();
  }

  void _recalcScore(StreakModel streak) {
    if (_log == null) return;
    final score = NoorCalculator.calculate(_log!, streak);
    _log = _log!.copyWith(noorScore: score);
  }

  Future<void> _save() async {
    if (_log == null || _uid == null) return;
    await _firestore.saveDailyLog(_uid!, _log!);
  }
}
