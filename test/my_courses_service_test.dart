/* test/my_courses_service_test.dart */
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_study_app/Service/my_courses_service.dart';

void main() {
  group('MyCoursesService', () {
    late FakeFirebaseFirestore fs;
    late MockFirebaseAuth auth;
    late MyCoursesService svc;

    setUp(() async {
      fs = FakeFirebaseFirestore();
      auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'uid123'),
      );
      svc = MyCoursesService(firestore: fs, auth: auth);

      await fs.collection('questions').doc('Math').set({
        'courses': {
          'Algebra 1': {
            'lessons': {
              'lesson1': {'title': 'Intro', 'content': ''}
            },
            'quiz': { '0': {} }
          }
        }
      });

      final prog = fs
          .collection('users')
          .doc('uid123')
          .collection('progress');
      await prog.doc('Math|Algebra 1|lesson1').set({'completed': true});
      await prog.doc('Math|Algebra 1|quiz').set({'completed': true});
    });

    test('myCoursesStream returns correct CourseProgress', () async {
      final list = await svc.myCoursesStream().first;
      expect(list, hasLength(1));
      final cp = list.first;
      expect(cp.fieldName, 'Math');
      expect(cp.courseName, 'Algebra 1');
      expect(cp.completedItems, 2);
      expect(cp.totalItems, 2);
    });
  });
}