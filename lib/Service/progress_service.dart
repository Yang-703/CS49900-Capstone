/* lib/Service/progress_service.dart */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'streak_service.dart';

class ProgressService {
  final FirebaseFirestore _fs;
  final FirebaseAuth _auth;
  final StreakService streakService;

  ProgressService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    StreakService? streakService,
  })  : _fs = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        streakService = streakService ?? StreakService();

  DocumentReference<Map<String, dynamic>> _doc(
    String field,
    String course,
    String lessonId,
  ) =>
    _fs
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('progress')
      .doc('$field|$course|$lessonId');

  Future<void> markLessonComplete(
    String field, String course, String lessonId) async {
    if (_auth.currentUser == null) return;
    await _doc(field, course, lessonId).set(
      {'completed': true, 'ts': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
    await streakService.recordStudy();
  }

  Future<void> markQuizComplete(String field, String course) async {
    if (_auth.currentUser == null) return;
    await _fs
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('progress')
      .doc('$field|$course|quiz')
      .set(
        {'completed': true, 'ts': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );
    await streakService.recordStudy();
  }

  Stream<Set<String>> lessonCompletionStream(String field, String course) {
    if (_auth.currentUser == null) return const Stream.empty();
    return _fs
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('progress')
      .where(FieldPath.documentId, isGreaterThanOrEqualTo: '$field|$course')
      .snapshots()
      .map((snap) => snap.docs
        .where((d) => d.id.startsWith('$field|$course'))
        .map((d) => d.id.split('|').last)
        .toSet());
  }

  Stream<bool> quizCompletionStream(String field, String course) {
    if (_auth.currentUser == null) return const Stream.empty();
    return _fs
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('progress')
      .doc('$field|$course|quiz')
      .snapshots()
      .map((snap) => snap.exists && (snap.data()?['completed'] ?? false));
  }
}