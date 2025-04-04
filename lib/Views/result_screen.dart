// result_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_app/Views/nav_bar_category.dart';
import 'package:flutter_study_app/Widgets/my_button.dart';
import 'package:lottie/lottie.dart';

class ResultScreen extends StatelessWidget {
  final int stars;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.stars,
    required this.totalQuestions,
  });

  /// Updates the user's accumulated stars in Firestore.
  /// (This can be called in quiz_screen before navigating here.)
  Future<void> updateUserstars() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection("users").doc(user.uid);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userRef);
        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }
        int existingstars = snapshot['stars'] ?? 0;
        transaction.update(userRef, {'stars': existingstars + stars});
      });
    } catch (e) {
      debugPrint("Error updating stars: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // The updateUserstars function can also be invoked here if needed.
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        title: const Text("Your Result"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // Display a Lottie animation for visual feedback.
              Lottie.network(
                "https://lottie.host/d7cc3291-7650-4c26-b9e0-4b8d0569a7ec/Epsc2qNzTb.json",
                height: 200,
                width: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 50),
              const Text(
                "Quiz Completed!",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "You earned: ${(stars)} stars",
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "You answered ${(stars / totalQuestions * 100).toStringAsFixed(2)}% of questions correctly",
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: MyButton(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const NavBarCategorySelection(
                                  initialIndex: 0,
                                ),
                            ),
                          (route) => false,
                        );
                      },
                      buttonText: "Start New Quiz",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MyButton(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const NavBarCategorySelection(
                                  initialIndex: 1,
                                ),
                          ),
                          (route) => false,
                        );
                      },
                      buttonText: "Your Ranking",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}