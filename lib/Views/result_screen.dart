/* lib/Views/result_screen.dart */
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_study_app/Widgets/my_button.dart';
import 'package:flutter_study_app/Service/shop_service.dart';
import 'package:flutter_study_app/Service/quiz_service.dart';
import 'package:flutter_study_app/Widgets/coin_star_card.dart';
import 'course_quiz_screen.dart';
import 'nav_bar_category.dart';

class ResultScreen extends StatelessWidget {
  final int stars;
  final int totalQuestions;
  static const int _coinRate = 5;
  final String fieldName;
  final String courseName;
  final Map<String, dynamic> quizData;
  final bool didReward; 

  const ResultScreen({
    super.key,
    required this.stars,
    required this.totalQuestions,
    required this.fieldName,
    required this.courseName,
    required this.quizData,
    required this.didReward,
  });

  @override
  Widget build(BuildContext context) {
    final int coinsEarned = stars * _coinRate;
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
              if (didReward) ...[
                Text(
                  "You earned: $stars ${stars == 1 ? 'star' : 'stars'}",
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 10),
                Text(
                  "Coins obtained: $coinsEarned",
                  style: const TextStyle(fontSize: 22),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                "You answered ${(stars / totalQuestions * 100).toStringAsFixed(2)}% of questions correctly",
                style: const TextStyle(fontSize: 21),
              ),
              const UserStatusCard(),
              const SizedBox(height: 10),
              StreamBuilder<int>(
                stream: ShopService.extraLivesStream(),
                builder: (context, livesSnap) {
                  final livesLeft = livesSnap.data ?? 0;
                  return Text(
                    'Extra lives: $livesLeft',
                    style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                  );
                },
              ),
              const SizedBox(height: 10),
              StreamBuilder<int>(
                stream: ShopService.extraLivesStream(),
                builder: (context, livesSnap) {
                  final lives = livesSnap.data ?? 0;
                  return FutureBuilder<QuizStatus>(
                    future: QuizService.getQuizStatus('${fieldName}_$courseName'),
                    builder: (context, statSnap) {
                      if (!statSnap.hasData) return const SizedBox();
                      final st = statSnap.data!;
                      if (st.firstCompleted && lives > 0 && !st.extraLifeActive) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await ShopService.consumeExtraLife();
                                await QuizService.activateExtraLife('${fieldName}_$courseName');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseQuizScreen(
                                      fieldName: fieldName,
                                      courseName: courseName,
                                      quizData: quizData,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFFF6B6B), Color(0xFFFF4757)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 255, 132, 143),
                                      offset: Offset(0, 4),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 36),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.favorite, color: Colors.white, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Use Extra Life',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: MyButton(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NavBarCategorySelection(initialIndex: 0),
                          ),
                          (route) => false,
                        );
                      },
                      buttonText: "Homepage",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MyButton(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NavBarCategorySelection(initialIndex: 2),
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