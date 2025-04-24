/* lib/Service/streak_service.dart */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Keeps track of consecutive days studied with current and highest for the signed‑in user.
// Set Firestore schema inside each user doc
class StreakService {
  static final _fs = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  static User? get _user => _auth.currentUser;

  static DocumentReference<Map<String, dynamic>> get _userDoc =>
      _fs.collection('users').doc(_user!.uid);

  // Call on any study action (lesson open, quiz finish).
  // Updates currentStreak, highestStreak, and lastStudyDate
  static Future<void> recordStudy() async {
    if (_user == null) return;
    final today = _todayString(); // YYYY‑MM‑DD in UTC

    await _fs.runTransaction((tx) async {
      final snap = await tx.get(_userDoc);
      int current = 0;
      int highest = 0;
      String? lastDate;
      if (snap.exists) {
        final data = snap.data()!;
        current = data['currentStreak'] ?? 0;
        highest = data['highestStreak'] ?? 0;
        lastDate = data['lastStudyDate'] as String?;
      }

      // If already recorded today, do nothing
      if (lastDate == today) return;

      // Determine new current streak
      int newCurrent;
      if (lastDate != null &&
          DateTime.parse(today)
                  .difference(DateTime.parse(lastDate))
                  .inDays ==
              1) {
        newCurrent = current + 1;
      } else {
        newCurrent = 1;
      }

      // Update highest if needed
      final newHighest = newCurrent > highest ? newCurrent : highest;

      tx.set(_userDoc, {
        'currentStreak': newCurrent,
        'highestStreak': newHighest,
        'lastStudyDate': today,
      }, SetOptions(merge: true));
    });
  }

  // Resets current streak to 0 if user missed >1 day since last study.
  // Call at app startup to keep currentStreak accurate
  static Future<void> syncStreak() async {
    if (_user == null) return;
    final snap = await _userDoc.get();
    if (!snap.exists) return;
    final data = snap.data()!;
    final lastDate = data['lastStudyDate'] as String?;
    final current = data['currentStreak'] ?? 0;
    if (lastDate == null) return;

    final diffDays = DateTime.now().toUtc().difference(DateTime.parse(lastDate)).inDays;
    if (diffDays > 1 && current != 0) {
      await _userDoc.update({'currentStreak': 0});
    }
  }

  // Live stream of current streak.
  static Stream<int> currentStreakStream() {
    if (_user == null) return const Stream.empty();
    return _userDoc.snapshots().map((snap) => snap.data()?['currentStreak'] ?? 0);
  }

  // Live stream of highest streak.
  static Stream<int> highestStreakStream() {
    if (_user == null) return const Stream.empty();
    return _userDoc.snapshots().map((snap) => snap.data()?['highestStreak'] ?? 0);
  }

  static String _todayString() {
    final now = DateTime.now().toUtc();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }
}