import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/daily_log.dart';
import '../models/streak_model.dart';
import '../models/user_model.dart';

/// Handles all Firestore CRUD operations — kept minimal to stay within free daily limits
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── User profile ──────────────────────────────────────────────────────────

  /// Create or update the user profile document
  Future<void> saveUserProfile(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  /// Fetch user profile
  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  // ── Daily log ─────────────────────────────────────────────────────────────

  /// Save (merge) the daily log for a specific date
  Future<void> saveDailyLog(String uid, DailyLog log) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('daily_logs')
        .doc(log.date)
        .set(log.toMap());
  }

  /// Fetch the daily log for a specific date; returns null if not found
  Future<DailyLog?> getDailyLog(String uid, String date) async {
    final doc = await _db
        .collection('users')
        .doc(uid)
        .collection('daily_logs')
        .doc(date)
        .get();
    if (!doc.exists) return null;
    return DailyLog.fromMap(doc.data()!);
  }

  // ── Streak ────────────────────────────────────────────────────────────────

  /// Save streak data (single document 'current')
  Future<void> saveStreak(String uid, StreakModel streak) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('streaks')
        .doc('current')
        .set(streak.toMap());
  }

  /// Fetch streak data; returns empty if not found
  Future<StreakModel> getStreak(String uid) async {
    final doc = await _db
        .collection('users')
        .doc(uid)
        .collection('streaks')
        .doc('current')
        .get();
    if (!doc.exists) return StreakModel.empty();
    return StreakModel.fromMap(doc.data()!);
  }
}
