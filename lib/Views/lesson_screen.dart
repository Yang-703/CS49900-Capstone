/* lib/Views/lesson_screen.dart */
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Service/progress_service.dart';

class LessonScreen extends StatefulWidget {
  final String fieldName;
  final String courseName;
  final String lessonId;
  final String lessonTitle;
  final String lessonContent;

  const LessonScreen({
    super.key,
    required this.fieldName,
    required this.courseName,
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonContent,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  @override
  void initState() {
    super.initState();
    // Mark as complete the moment the user opens the lesson
    ProgressService.markLessonComplete(
      widget.fieldName,
      widget.courseName,
      widget.lessonId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lessonTitle),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            widget.lessonContent,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}