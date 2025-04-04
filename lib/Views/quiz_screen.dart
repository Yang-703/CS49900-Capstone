// quiz_screen.dart
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Views/result_screen.dart';
import 'package:flutter_study_app/Widgets/my_button.dart';

class QuizScreen extends StatefulWidget {
  final String categoryName;
  const QuizScreen({super.key, required this.categoryName});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  int stars = 0;
  int? selectedOption;
  bool hasAnswered = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  /// Fetches questions for the given category from Firestore,
  /// shuffles them, and limits the quiz to 20 questions.
  Future<void> _fetchQuestions() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("questions")
          .doc(widget.categoryName)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey("question")) {
          final questionsMap = data['question'];
          if (questionsMap is Map<String, dynamic>) {
            List<Map<String, dynamic>> fetchedQuestions =
                questionsMap.entries.map((entry) {
              final q = entry.value;
              // Extract options and sort them by key to maintain order.
              final optionsMap = q['options'] as Map<String, dynamic>;
              final optionList = optionsMap.entries.toList()
                ..sort((a, b) =>
                    int.parse(a.key).compareTo(int.parse(b.key)));
              final options =
                  optionList.map((e) => e.value.toString()).toList();

              return {
                'questionText': q['questionText'] ?? "No Question",
                'options': options,
                'correctOptionKey':
                    int.tryParse(q['correctOptionKey'].toString()) ?? 0,
              };
            }).toList();

            // Shuffle questions randomly and limit to 20.
            fetchedQuestions.shuffle(Random());
            if (fetchedQuestions.length > 20) {
              fetchedQuestions = fetchedQuestions.sublist(0, 20);
            }
            setState(() {
              questions = fetchedQuestions;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching questions: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Checks the user's answer, marks the question as answered,
  /// and increments stars if the answer is correct.
  void _checkAnswer(int index) {
    setState(() {
      hasAnswered = true;
      selectedOption = index;
      if (questions[currentIndex]['correctOptionKey'] == index + 1) {
        stars++;
      }
    });
  }

  /// Proceeds to the next question or navigates to the result screen if finished.
  Future<void> _nextQuestion() async {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        hasAnswered = false;
        selectedOption = null;
      });
    } else {
      await _updateUserstars();
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

  /// Updates the user's accumulated stars in Firestore using a transaction.
  Future<void> _updateUserstars() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final userRef =
          FirebaseFirestore.instance.collection("users").doc(user.uid);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        if (!snapshot.exists) return;
        int existingstars = snapshot['stars'] ?? 0;
        transaction.update(userRef, {'stars': existingstars + stars});
      });
    } catch (e) {
      debugPrint('Error updating stars: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while questions are being fetched.
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    // If no questions were fetched, display a message.
    if (questions.isEmpty) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const Center(
          child: Text("No Questions Available"),
        ),
      );
    }
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress indicator showing quiz completion.
            LinearProgressIndicator(
              value: (currentIndex + 1) / questions.length,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blueAccent,
              minHeight: 8,
            ),
            const SizedBox(height: 20),
            // Display current question inside a Card.
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
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // List of answer options.
            Expanded(
              child: ListView.separated(
                itemCount: questions[currentIndex]['options'].length,
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  return _buildOption(index);
                },
              ),
            ),
            // Next/Finish button appears once an answer is selected.
            if (hasAnswered)
              SizedBox(
                width: double.infinity,
                child: MyButton(
                  onTap: _nextQuestion,
                  buttonText: currentIndex == questions.length - 1
                      ? "Finish"
                      : "Next",
                ),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// Builds each answer option widget with visual feedback.
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
    Color textColor =
        hasAnswered && (isCorrect || isSelected) ? Colors.white : Colors.black;

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
            )
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

  /// Builds the AppBar displaying the category name and question progress.
  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
          "${widget.categoryName} (${currentIndex + 1}/${questions.length})"),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
      elevation: 0,
    );
  }
}
