/* test/streak_service_test.dart */
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_study_app/Service/streak_service.dart';

void main() {
  group('StreakService', () {
    late FakeFirebaseFirestore fs;
    late MockFirebaseAuth auth;
    late StreakService ss;

    setUp(() {
      fs = FakeFirebaseFirestore();
      auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'uid123'),
      );
      ss = StreakService(firestore: fs, auth: auth);
    });

    test('recordStudy sets initial streaks', () async {
      await ss.recordStudy();

      final userDoc = await fs.collection('users').doc('uid123').get();
      final data = userDoc.data()!;
      expect(data['currentStreak'], 1);
      expect(data['highestStreak'], 1);
      expect(data['lastStudyDate'], isNotNull);
    });

    test('recordStudy does not increment twice in same day', () async {
      await ss.recordStudy();
      await ss.recordStudy();

      final data = (await fs.collection('users').doc('uid123').get()).data()!;
      expect(data['currentStreak'], 1);
      expect(data['highestStreak'], 1);
    });

    test('syncStreak resets if lastStudyDate >1 day ago', () async {
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
      final ds = '${twoDaysAgo.year.toString().padLeft(4,'0')}-'
               '${twoDaysAgo.month.toString().padLeft(2,'0')}-'
               '${twoDaysAgo.day.toString().padLeft(2,'0')}';

      await fs.collection('users').doc('uid123').set({
        'currentStreak': 5,
        'highestStreak': 10,
        'lastStudyDate': ds,
      });

      await ss.syncStreak();

      final data = (await fs.collection('users').doc('uid123').get()).data()!;
      expect(data['currentStreak'], 0);
      expect(data['highestStreak'], 10);
    });

    test('currentStreakStream & highestStreakStream emit after update', () async {
      final currFuture = ss.currentStreakStream().firstWhere((v) => v == 1);
      final highFuture = ss.highestStreakStream().firstWhere((v) => v == 1);
      await ss.recordStudy();
      expect(await currFuture, 1);
      expect(await highFuture, 1);
    });
  });
}