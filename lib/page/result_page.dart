// project_app/page/result_page.dart

import 'package:flutter/material.dart';
import 'package:project_app/const/colors.dart';
import 'package:project_app/const/text_style.dart';
import 'package:project_app/const/images.dart';
import 'package:project_app/quiz_screen.dart';
import 'package:project_app/main.dart';
import 'package:project_app/D_B/results_db.dart';
import 'package:project_app/page/result_history_page.dart';

class ResultPage extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;

  const ResultPage({
    Key? key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final resultsDb = ResultsDatabase();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [blue, darkBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(   // ✅ notch / bottom safe zone
          child: SingleChildScrollView(   // ✅ overflow fix
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                Image.asset(ideas, width: 180),
                headingText(color: Colors.white, size: 32, text: "🎉 Congratulations!"),
                const SizedBox(height: 30),

                normalText(
                  color: Colors.white,
                  size: 18,
                  text: "Total Questions: $totalQuestions",
                ),
                normalText(
                  color: Colors.greenAccent,
                  size: 18,
                  text: "Correct Answers: $correctAnswers",
                ),
                normalText(
                  color: Colors.redAccent,
                  size: 18,
                  text: "Incorrect Answers: $incorrectAnswers",
                ),

                const SizedBox(height: 30),

                // Save Result
                GestureDetector(
                  onTap: () async {
                    try {
                      await resultsDb.insertResult(totalQuestions, correctAnswers, incorrectAnswers);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Result saved successfully"))
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ResultHistoryPage()),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Save failed: $e"))
                        );
                      }
                    }
                  },
                  child: Container(
                    width: size.width * 0.75,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: headingText(color: blue, size: 18, text: "Save Result"),
                  ),
                ),

                const SizedBox(height: 16),

                // Play Again
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    );
                  },
                  child: Container(
                    width: size.width * 0.75,
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: headingText(color: blue, size: 18, text: "Play Again"),
                  ),
                ),

                const SizedBox(height: 16),

                // Back to Home
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizApp()),
                    );
                  },
                  child: Container(
                    width: size.width * 0.75,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: headingText(color: blue, size: 18, text: "Back to Home"),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
