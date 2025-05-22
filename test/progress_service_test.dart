/* test/progress_service_test.dart */
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_study_app/Service/progress_service.dart';
import 'package:flutter_study_app/Service/streak_service.dart';

void main() {
  group('ProgressService', () {
    late FakeFirebaseFirestore fs;
    late MockFirebaseAuth auth;
    late StreakService ss;
    late ProgressService ps;

    setUp(() {
      fs = FakeFirebaseFirestore();
      auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'uid123'),
      );
      ss = StreakService(firestore: fs, auth: auth);
      ps = ProgressService(
        firestore:    fs,
        auth:         auth,
        streakService: ss,
      );
    });

    test('markLessonComplete writes progress and updates streak', () async {
      await ps.markLessonComplete('Math', 'Alg1', 'lesson1');
      final doc = await fs
          .collection('users')
          .doc('uid123')
          .collection('progress')
          .doc('Math|Alg1|lesson1')
          .get();
      expect(doc.exists, isTrue);
      expect(doc.data()!['completed'], true);

      final userDoc = await fs.collection('users').doc('uid123').get();
      expect(userDoc.data()!['currentStreak'], 1);
      expect(userDoc.data()!['highestStreak'], 1);
      expect(userDoc.data()!['lastStudyDate'], isNotNull);
    });

    test('markQuizComplete behaves similarly', () async {
      await ps.markQuizComplete('Sci', 'Bio1');

      final doc = await fs
          .collection('users')
          .doc('uid123')
          .collection('progress')
          .doc('Sci|Bio1|quiz')
          .get();
      expect(doc.exists, isTrue);
      expect(doc.data()!['completed'], true);

      final userDoc = await fs.collection('users').doc('uid123').get();
      expect(userDoc.data()!['currentStreak'], 1);
    });
  });
}
