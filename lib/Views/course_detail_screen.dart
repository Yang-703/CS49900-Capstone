/* lib/Views/course_detail_screen.dart */
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Views/lesson_screen.dart';
import 'package:flutter_study_app/Views/course_quiz_screen.dart';

class CourseDetailScreen extends StatelessWidget {
  final String fieldName;
  final String courseName;
  final Map<String, dynamic> courseData;
  
  const CourseDetailScreen({
    super.key,
    required this.fieldName,
    required this.courseName,
    required this.courseData,
  });
  
  @override
  Widget build(BuildContext context) {
    // Extract lessons data from the course. Ensure it's a map.
    final lessonsMap = courseData["lessons"] as Map<String, dynamic>? ?? {};
    // Convert the lessons map into a list for display.
    final List<Map<String, String>> lessons =
        lessonsMap.entries.map<Map<String, String>>((entry) {
      final lesson = entry.value as Map<String, dynamic>;
      return {
        "title": lesson["title"]?.toString() ?? "Untitled Lesson",
        "content": lesson["content"]?.toString() ?? "",
      };
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(courseName),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          // Increase itemCount by 1 to add the quiz button as the last item.
          itemCount: lessons.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            if (index < lessons.length) {
              final lesson = lessons[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(lesson["title"]!),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LessonScreen(
                          lessonTitle: lesson["title"]!,
                          lessonContent: lesson["content"]!,
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              // Quiz button placed below the last lesson with additional vertical spacing.
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseQuizScreen(
                            fieldName: fieldName,
                            courseName: courseName,
                            quizData: courseData["quiz"] as Map<String, dynamic>? ?? {},
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Start Quiz",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
