/* lib/Views/course_detail_screen.dart */
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Service/progress_service.dart';
import 'lesson_screen.dart';
import 'course_quiz_screen.dart';

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
    final lessonsMap = courseData['lessons'] as Map<String, dynamic>? ?? {};
    final lessons = lessonsMap.entries.map((e) {
      final lesson = e.value as Map<String, dynamic>;
      return {
        'id': e.key,
        'title': lesson['title']?.toString() ?? 'Untitled',
        'content': lesson['content']?.toString() ?? '',
      };
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Course Lessons',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<Set<String>>(
          stream: ProgressService.lessonCompletionStream(
              fieldName, courseName),
          builder: (context, snapshot) {
            final completed = snapshot.data ?? <String>{};
            final completedCount = completed.length;
            final total = lessons.length;

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fieldName,
                        style: TextStyle(
                          color: Colors.indigo.shade400,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        courseName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: total == 0 ? 0 : completedCount / total,
                        backgroundColor: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$completedCount / $total lessons completed',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView.separated(
                    itemCount: lessons.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index < lessons.length) {
                        final lesson = lessons[index];
                        final done = completed.contains(lesson['id']);
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            leading: Icon(
                              done
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: done ? Colors.green : Colors.grey,
                            ),
                            title: Text(
                              lesson['title']!,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LessonScreen(
                                    fieldName: fieldName,
                                    courseName: courseName,
                                    lessonId: lesson['id']!,
                                    lessonTitle: lesson['title']!,
                                    lessonContent: lesson['content']!,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }

                      final allDone = completedCount == total && total > 0;
                      return Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.quiz),
                            label: Text(
                              allDone ? 'Start Quiz' : 'Finish lessons first',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            onPressed: allDone
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CourseQuizScreen(
                                          fieldName: fieldName,
                                          courseName: courseName,
                                          quizData:
                                              courseData['quiz'] as Map<String,
                                                  dynamic>? ??
                                                  {},
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor:
                                  allDone ? Colors.indigo : Colors.grey,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}