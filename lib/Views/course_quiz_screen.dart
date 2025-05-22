/* lib/Views/course_quiz_screen.dart */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Widgets/my_button.dart';
import 'package:flutter_study_app/Service/quiz_service.dart';
import 'package:flutter_study_app/Service/progress_service.dart';
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
  static const int _coinRate = 5;

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
    final quizMap = widget.quizData;
    List<Map<String, dynamic>> qs = quizMap.entries.map((entry) {
      final q = entry.value as Map<String, dynamic>;
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
    setState(() {
      questions = qs;
    });
  }

  void _checkAnswer() {
    if (selectedOption == null) return;
    setState(() {
      hasAnswered = true;
      if (questions[currentIndex]['correctOptionKey'] == selectedOption! + 1) {
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
      await _handleFinish();
    }
  }

  Future<void> _updateUserStars() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final userRef = FirebaseFirestore.instance.collection("users").doc(user.uid);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }
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

  Future<void> _handleFinish() async {
  final quizId = '${widget.fieldName}_${widget.courseName}';
  final status = await QuizService.getQuizStatus(quizId);
  final canReward = !status.firstCompleted || status.extraLifeActive;
  final bool didReward = canReward && stars > 0;

  if (didReward) {
    await _updateUserStars();
    await _updateUserCoins();

    if (!status.firstCompleted) {
      await QuizService.markFirstCompleted(quizId);
      
      await ProgressService.markQuizComplete(
        widget.fieldName,
        widget.courseName,
      );
    } else {
      await QuizService.consumeExtraLife(quizId);
    }
  }
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          fieldName: widget.fieldName,
          courseName: widget.courseName,
          quizData: widget.quizData,
          stars: stars,
          totalQuestions: questions.length,
          didReward: didReward,
        ),
      ), 
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.courseName} Quiz",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7CB0FC),
                  Color(0xFF638FDB),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: const Center(child: Text("No Questions Available")),
        backgroundColor: const Color(0xFFDDE7FD),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.courseName} Quiz (${currentIndex + 1}/${questions.length})",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF7CB0FC),
                Color(0xFF638FDB),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFDDE7FD),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentIndex + 1) / questions.length,
              backgroundColor: Colors.grey.shade400,
              color: Colors.green,
              minHeight: 8,
            ),
            const SizedBox(height: 20),
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
            Expanded(
              child: ListView.separated(
                itemCount: questions[currentIndex]['options'].length,
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  return _buildOption(index);
                },
              ),
            ),
            if (!hasAnswered && selectedOption != null)
              SizedBox(
                width: double.infinity,
                child: MyButton(
                  onTap: _checkAnswer,
                  buttonText: "Confirm",
                ),
              ),
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
    final optionText = questions[currentIndex]['options'][index] as String;
    final correctKey = questions[currentIndex]['correctOptionKey'] as int;
    final isCorrect = (correctKey == index + 1);
    final isSelected = (selectedOption == index);
    Color bgColor;
    Color textColor;
    if (!hasAnswered) {
      bgColor = isSelected
          ? Colors.lightBlue.shade200
          : Colors.grey.shade200;
      textColor = Colors.black;
    } else {
      if (isCorrect) {
        bgColor = Colors.green.shade300;
        textColor = Colors.white;
      } else if (isSelected) {
        bgColor = Colors.red.shade300;
        textColor = Colors.white;
      } else {
        bgColor = Colors.grey.shade200;
        textColor = Colors.black;
      }
    }
    return InkWell(
      onTap: hasAnswered ? null : () => setState(() {
        selectedOption = index;
      }),
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
          optionText,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
      ),
    );
  }
}