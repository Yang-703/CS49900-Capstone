/* lib/Service/my_courses_service.dart */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseProgress {
  final String fieldName;
  final String courseName;
  final int completedItems;
  final int totalItems;
  final String imageUrl;
  final Map<String, dynamic> courseData;

  CourseProgress({
    required this.fieldName,
    required this.courseName,
    required this.completedItems,
    required this.totalItems,
    required this.imageUrl,
    required this.courseData,
  });
}

class MyCoursesService {
  final FirebaseFirestore _fs;
  final FirebaseAuth _auth;

  MyCoursesService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _fs = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  User? get _user => _auth.currentUser;

  Stream<List<CourseProgress>> myCoursesStream() {
    if (_user == null) return const Stream.empty();

    return _fs
        .collection('users')
        .doc(_user!.uid)
        .collection('progress')
        .snapshots()
        .asyncMap((snap) async {
      final Map<String, int> completedMap = {};
      for (var doc in snap.docs) {
        final parts = doc.id.split('|');
        if (parts.length != 3) continue;
        final key = '${parts[0]}|${parts[1]}';
        completedMap[key] = (completedMap[key] ?? 0) + 1;
      }

      final List<CourseProgress> list = [];
      for (var entry in completedMap.entries) {
        final parts = entry.key.split('|');
        final field = parts[0];
        final course = parts[1];
        final completedCount = entry.value;

        final qDoc = await _fs.collection('questions').doc(field).get();
        final data = (qDoc.data()?['courses'][course] as Map<String, dynamic>?) ?? <String, dynamic>{};
        final lessonsCount = (data['lessons'] as Map?)?.length ?? 0;
        final quizCount = data.containsKey('quiz') ? 1 : 0;
        final totalCount = lessonsCount + quizCount;

        list.add(CourseProgress(
          fieldName: field,
          courseName: course,
          completedItems: completedCount,
          totalItems: totalCount,
          imageUrl: data['image_url'] as String? ?? '',
          courseData: data,
        ));
      }
      return list;
    });
  }
}