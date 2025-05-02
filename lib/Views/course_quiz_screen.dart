/* lib/Views/course_quiz_screen.dart */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Widgets/my_button.dart';
import 'result_screen.dart';

class CourseQuizScreen extends StatefulWidget {
  final String fieldName;
  final String courseName;
  final Map<String, dynamic> quizData;

  const CourseQuizScreen({
    super.key,
    required this.fieldName,
    required this.courseName,
    required this.quizData,
  });

  @override
  State<CourseQuizScreen> createState() => _CourseQuizScreenState();
}

class _CourseQuizScreenState extends State<CourseQuizScreen> {
  static const int _coinRate = 5; // coins per correct answer

  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  int stars = 0;
  int? selectedOption;
  bool hasAnswered = false;

  @override
  void initState() {
    super.initState();
    _prepareQuestions();
  }

  void _prepareQuestions() {
    // Convert quizData map into a list of questions sorted by key (keys start at index 0)
    final quizMap = widget.quizData;
    List<Map<String, dynamic>> qs = quizMap.entries.map((entry) {
      final q = entry.value as Map<String, dynamic>;
      // Ensure the options are in the correct order by sorting their keys
      final optionsMap = q['options'] as Map<String, dynamic>;
      final optionList = optionsMap.entries.toList()
        ..sort((a, b) => int.parse(a.key).compareTo(int.parse(b.key)));
      final options = optionList.map((e) => e.value.toString()).toList();
      return {
        'questionText': q['questionText'] ?? "No Question",
        'options': options,
        'correctOptionKey': int.tryParse(q['correctOptionKey'].toString()) ?? 0,
      };
    }).toList();
    // Optionally, we can shuffle or sort further. For a course quiz with a fixed order, we assume sorted by key.
    setState(() {
      questions = qs;
    });
  }

  void _checkAnswer(int index) {
    setState(() {
      hasAnswered = true;
      selectedOption = index;
      if (questions[currentIndex]['correctOptionKey'] == index + 1) {
        stars++;
      }
    });
  }

  Future<void> _nextQuestion() async {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        hasAnswered = false;
        selectedOption = null;
      });
    } else {
      await _updateUserStars();
      await _updateUserCoins(); // award coins after quiz
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            stars: stars,
            totalQuestions: questions.length,
          ),
        ),
      );
    }
  }

  Future<void> _updateUserStars() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final userRef = FirebaseFirestore.instance.collection("users").doc(user.uid);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        if (!snapshot.exists) return;
        int existingStars = snapshot['stars'] ?? 0;
        transaction.update(userRef, {'stars': existingStars + stars});
      });
    } catch (e) {
      debugPrint('Error updating stars: $e');
    }
  }

  Future<void> _updateUserCoins() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        if (!snapshot.exists) return;
        int existingCoins = snapshot['coins'] ?? 0;
        transaction.update(userRef, {
          'coins': existingCoins + (stars * _coinRate),
        });
      });
    } catch (e) {
      debugPrint('Error updating coins: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("${widget.courseName} Quiz"),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(child: Text("No Questions Available")),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.courseName} Quiz (${currentIndex + 1}/${questions.length})"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (currentIndex + 1) / questions.length,
              backgroundColor: Colors.grey.shade400,
              color: Colors.green,
              minHeight: 8,
            ),
            const SizedBox(height: 20),
            // Question Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  questions[currentIndex]['questionText'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Answer Options
            Expanded(
              child: ListView.separated(
                itemCount: questions[currentIndex]['options'].length,
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  return _buildOption(index);
                },
              ),
            ),
            // Next / Finish Button
            if (hasAnswered)
              SizedBox(
                width: double.infinity,
                child: MyButton(
                  onTap: _nextQuestion,
                  buttonText: currentIndex == questions.length - 1 ? "Finish" : "Next",
                ),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(int index) {
    bool isCorrect = questions[currentIndex]['correctOptionKey'] == index + 1;
    bool isSelected = selectedOption == index;
    Color bgColor;
    if (hasAnswered) {
      bgColor = isCorrect
          ? Colors.green.shade300
          : isSelected
              ? Colors.red.shade300
              : Colors.grey.shade200;
    } else {
      bgColor = Colors.grey.shade200;
    }
    Color textColor = hasAnswered && (isCorrect || isSelected) ? Colors.white : Colors.black;
    return InkWell(
      onTap: hasAnswered ? null : () => _checkAnswer(index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          questions[currentIndex]['options'][index],
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
      ),
    );
  }
}