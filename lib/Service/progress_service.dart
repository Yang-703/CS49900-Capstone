/* lib/Service/progress_service.dart */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'streak_service.dart';

class ProgressService {
  static final _fs = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  static User? get _user => _auth.currentUser;

  static DocumentReference<Map<String, dynamic>> _doc(
          String field, String course, String lessonId) =>
      _fs
          .collection('users')
          .doc(_user!.uid)
          .collection('progress')
          .doc('$field|$course|$lessonId');

  static Future<void> markLessonComplete(
      String field, String course, String lessonId) async {
    if (_user == null) return;

    await _doc(field, course, lessonId).set(
      {'completed': true, 'ts': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );

    await StreakService.recordStudy();
  }

  static Future<void> markQuizComplete(String field, String course) async {
    if (_user == null) return;
    final docRef = _fs
      .collection('users')
      .doc(_user!.uid)
      .collection('progress')
      .doc('$field|$course|quiz');
    await docRef.set(
      { 'completed': true, 'ts': FieldValue.serverTimestamp() },
      SetOptions(merge: true),
    );
    await StreakService.recordStudy();
  }

  static Stream<Set<String>> lessonCompletionStream(
      String field, String course) {
    if (_user == null) return const Stream.empty();
    return _fs
        .collection('users')
        .doc(_user!.uid)
        .collection('progress')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: '$field|$course')
        .snapshots()
        .map((snap) => snap.docs
            .where((d) => d.id.startsWith('$field|$course'))
            .map((d) => d.id.split('|').last)
            .toSet());
  }

  static Stream<bool> quizCompletionStream(String field, String course) {
    if (_user == null) return const Stream.empty();
    return _fs
      .collection('users')
      .doc(_user!.uid)
      .collection('progress')
      .doc('$field|$course|quiz')
      .snapshots()
      .map((snap) => snap.exists && (snap.data()?['completed'] ?? false) == true);
  }
}