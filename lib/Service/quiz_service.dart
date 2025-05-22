/* lib/Service/quiz_service.dart */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizStatus {
  final bool firstCompleted;
  final bool extraLifeActive;
  const QuizStatus({ required this.firstCompleted, required this.extraLifeActive });
}

class QuizService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  QuizService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;


  DocumentReference<Map<String, dynamic>> _docRef(String quizId) {
    final uid = _auth.currentUser!.uid;
    return _firestore
      .collection('users')
      .doc(uid)
      .collection('quizAttempts')
      .doc(quizId)
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snap, _) => snap.data() ?? {},
        toFirestore: (map, _) => map,
      );
  }

  Future<QuizStatus> getQuizStatus(String quizId) async {
    final snap = await _docRef(quizId).get();
    if (!snap.exists) return const QuizStatus(firstCompleted: false, extraLifeActive: false);
    final data = snap.data();
    return QuizStatus(
      firstCompleted: data?['firstCompleted'] as bool? ?? false,
      extraLifeActive: data?['extraLifeActive'] as bool? ?? false,
    );
  }

  Future<void> markFirstCompleted(String quizId) {
    return _docRef(quizId).set({'firstCompleted': true}, SetOptions(merge: true));
  }

  Future<void> activateExtraLife(String quizId) {
    return _docRef(quizId).set({'extraLifeActive': true}, SetOptions(merge: true));
  }

  Future<void> consumeExtraLife(String quizId) {
    return _docRef(quizId).update({'extraLifeActive': false});
  }
}