/* test/course_screen_test.dart */
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_study_app/views/course_screen.dart';

void main() {
  group('CourseScreen.getCrossAxisCount', () {
    final screen = CourseScreen(fieldName: 'Math');

    test('returns 1 when width < 600', () {
      expect(screen.getCrossAxisCount(599), 1);
    });

    test('returns 2 when 600 ≤ width < 1024', () {
      expect(screen.getCrossAxisCount(600), 2);
      expect(screen.getCrossAxisCount(1023), 2);
    });

    test('returns 3 when width ≥ 1024', () {
      expect(screen.getCrossAxisCount(1024), 3);
      expect(screen.getCrossAxisCount(2000), 3);
    });
  });
}