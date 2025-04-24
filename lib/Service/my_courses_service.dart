/* lib/Service/my_courses_service.dart */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// A user’s in‑progress course plus progress counts
class CourseProgress {
  final String fieldName;
  final String courseName;
  final int completedLessons;
  final int totalLessons;
  final String imageUrl;
  final Map<String, dynamic> courseData;

  CourseProgress({
    required this.fieldName,
    required this.courseName,
    required this.completedLessons,
    required this.totalLessons,
    required this.imageUrl,
    required this.courseData,
  });
}

// Streams a list of the user’s courses where at least one lesson is complete
class MyCoursesService {
  static final _fs = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  static User? get _user => _auth.currentUser;

  static Stream<List<CourseProgress>> myCoursesStream() {
    if (_user == null) return const Stream.empty();

    // Any change inside /progress triggers a rebuild
    return _fs
        .collection('users')
        .doc(_user!.uid)
        .collection('progress')
        .snapshots()
        .asyncMap((snap) async {
      // Add completed counts per “field|course”
      final Map<String, int> completedMap = {};
      for (var doc in snap.docs) {
        final parts = doc.id.split('|'); // field|course|lessonId
        if (parts.length != 3) continue;
        final key = '${parts[0]}|${parts[1]}';
        completedMap[key] = (completedMap[key] ?? 0) + 1;
      }

      // Build a CourseProgress for each entry
      final List<CourseProgress> list = [];
      for (var entry in completedMap.entries) {
        final parts = entry.key.split('|');
        final field = parts[0];
        final course = parts[1];
        final completed = entry.value;

        // Fetch course meta & lesson count
        final qDoc = await _fs.collection('questions').doc(field).get();
        int total = 0;
        String imgUrl = '';
        Map<String, dynamic> courseData = {};
        if (qDoc.exists) {
          final data = qDoc.data()!;
          courseData =
              Map<String, dynamic>.from(data['courses'][course] ?? {});
          total = (courseData['lessons'] as Map?)?.length ?? 0;
          imgUrl = courseData['image_url'] ?? '';
        }

        list.add(CourseProgress(
          fieldName: field,
          courseName: course,
          completedLessons: completed,
          totalLessons: total,
          imageUrl: imgUrl,
          courseData: courseData,
        ));
      }

      return list;
    });
  }
}
