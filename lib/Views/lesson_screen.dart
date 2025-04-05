/* lib/Views/lesson_screen.dart */
import 'package:flutter/material.dart';

class LessonScreen extends StatelessWidget {
  final String lessonTitle;
  final String lessonContent;

  const LessonScreen({
    super.key,
    required this.lessonTitle,
    required this.lessonContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lessonTitle),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            lessonContent,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
