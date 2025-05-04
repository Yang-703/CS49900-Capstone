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
            stream: ProgressService.lessonCompletionStream(fieldName, courseName),
            builder: (context, lessonSnap) {
              final doneLessons = lessonSnap.data ?? <String>{};
              final lessonIds = lessons.map((e) => e['id'] as String).toSet();
              final lessonsDone = lessonIds.where(doneLessons.contains).length;
              final totalLessons = lessons.length;

              return StreamBuilder<bool>(
                stream: ProgressService.quizCompletionStream(fieldName, courseName),
                builder: (context, quizSnap) {
                  final quizDone = quizSnap.data == true ? 1 : 0;
                  final totalItems = totalLessons + 1;
                  final completedItems = lessonsDone + quizDone;
                  final overallProg = totalItems == 0
                    ? 0.0
                    : completedItems / totalItems;
                  final canStartQuiz = totalLessons > 0 && lessonsDone == totalLessons;
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical:20, horizontal:16),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(fieldName, style: TextStyle(
                              color: Colors.indigo.shade400,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            )),
                            const SizedBox(height: 4),
                            Text(courseName, style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87
                            )),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(value: overallProg, backgroundColor: Colors.grey.shade300),
                            const SizedBox(height: 4),
                            Text(
                              '$completedItems / $totalItems completed',
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
                          itemBuilder: (context, idx) {
                            if (idx < lessons.length) {
                              final lesson = lessons[idx];
                              final done   = doneLessons.contains(lesson['id']);
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    done ? Icons.check_circle : Icons.radio_button_unchecked,
                                    color: done ? Colors.green : Colors.grey,
                                  ),
                                  title: Text(
                                    lesson['title']!,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                  onTap: () => Navigator.push(
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
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.quiz),
                                  label: Text(
                                    canStartQuiz ? 'Start Quiz' : 'Finish lessons first',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: canStartQuiz
                                    ? () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CourseQuizScreen(
                                              fieldName: fieldName,
                                              courseName: courseName,
                                              quizData: courseData['quiz'] as Map<String, dynamic>,
                                            ),
                                          ),
                                        )
                                    : null,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: canStartQuiz ? Colors.indigo : Colors.grey,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              );
            },
          ),
      ),
    );
  }
}