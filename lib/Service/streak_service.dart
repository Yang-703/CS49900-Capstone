/* lib/Service/streak_service.dart */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreakService {
  final FirebaseFirestore _fs;
  final FirebaseAuth _auth;

  StreakService({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _fs = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;
  User? get _user => _auth.currentUser;

  DocumentReference<Map<String, dynamic>> get _userDoc =>
      _fs.collection('users').doc(_user!.uid);

  Future<void> recordStudy() async {
    if (_user == null) return;
    final today = _todayString();

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

      if (lastDate == today) return;

      int newCurrent;
      if (lastDate != null &&
          DateTime.parse(today)
                  .difference(DateTime.parse(lastDate))
                  .inDays == 1) {
        newCurrent = current + 1;
      } else {
        newCurrent = 1;
      }

      final newHighest = newCurrent > highest ? newCurrent : highest;

      tx.set(_userDoc, {
        'currentStreak': newCurrent,
        'highestStreak': newHighest,
        'lastStudyDate': today,
      }, SetOptions(merge: true));
    });
  }

  Future<void> syncStreak() async {
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

  Stream<int> currentStreakStream() {
    if (_user == null) return const Stream.empty();
    return _userDoc.snapshots().map((snap) => snap.data()?['currentStreak'] ?? 0);
  }

  Stream<int> highestStreakStream() {
    if (_user == null) return const Stream.empty();
    return _userDoc.snapshots().map((snap) => snap.data()?['highestStreak'] ?? 0);
  }

  static String _todayString() {
    final now = DateTime.now();
    final localDate = DateTime(now.year, now.month, now.day);
    return '${localDate.year.toString().padLeft(4, '0')}-'
      '${localDate.month.toString().padLeft(2, '0')}-'
      '${localDate.day.toString().padLeft(2, '0')}';
  }
}