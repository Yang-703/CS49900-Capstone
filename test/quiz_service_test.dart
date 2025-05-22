/* test/quiz_service_test.dart */
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_study_app/Service/quiz_service.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late FakeFirebaseFirestore mockFirestore;
  late QuizService service;
  const quizId = 'field1_courseA';

  setUp(() {
    mockAuth = MockFirebaseAuth(signedIn: true);
    mockFirestore = FakeFirebaseFirestore();
    service = QuizService(auth: mockAuth, firestore: mockFirestore);
  });

  test('getQuizStatus returns false/false when no doc exists', () async {
    final status = await service.getQuizStatus(quizId);
    expect(status.firstCompleted, isFalse);
    expect(status.extraLifeActive, isFalse);
  });

  test('markFirstCompleted then getQuizStatus shows firstCompleted=true', () async {
    await service.markFirstCompleted(quizId);
    final status = await service.getQuizStatus(quizId);
    expect(status.firstCompleted, isTrue);
    expect(status.extraLifeActive, isFalse);
  });

  test('activateExtraLife then getQuizStatus shows extraLifeActive=true', () async {
    await service.activateExtraLife(quizId);
    final status = await service.getQuizStatus(quizId);
    expect(status.firstCompleted, isFalse);
    expect(status.extraLifeActive, isTrue);
  });

  test('consumeExtraLife sets extraLifeActive back to false', () async {
    await service.activateExtraLife(quizId);
    var status = await service.getQuizStatus(quizId);
    expect(status.extraLifeActive, isTrue);

    await service.consumeExtraLife(quizId);
    status = await service.getQuizStatus(quizId);
    expect(status.extraLifeActive, isFalse);
  });
}
