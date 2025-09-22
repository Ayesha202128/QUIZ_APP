import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_app/api_services.dart';
import 'package:project_app/const/colors.dart';
import 'package:project_app/const/images.dart';
import 'package:project_app/const/text_style.dart';
import 'package:project_app/page/result_page.dart';
import 'package:project_app/page/result_page.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  var currentQuestionIndex = 0;
  int seconds = 60;
  Timer? timer;
  late Future quiz;

  int points = 0;
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  bool answered = false;

  var isLoaded = false;
  var optionsList = [];
  var optionsColor = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    quiz = getQuiz();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  resetColors() {
    optionsColor = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
    answered = false;
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          // time up, count as incorrect if not answered
          if (!answered) {
            incorrectAnswers++;
          }
          gotoNextQuestion();
        }
      });
    });
  }

  gotoNextQuestion() {
    isLoaded = false;
    currentQuestionIndex++;
    resetColors();
    timer?.cancel();
    seconds = 60;

    quiz.then((value) {
      var totalQuestions = value["results"].length;
      if (currentQuestionIndex >= totalQuestions) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultPage(
              totalQuestions: totalQuestions,
              correctAnswers: correctAnswers,
              incorrectAnswers: incorrectAnswers,
            ),
          ),
        );
      } else {
        startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [blue, darkBlue],
            ),
          ),
          child: FutureBuilder(
            future: quiz,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data["results"];

                if (!isLoaded) {
                  optionsList = List<String>.from(
                      data[currentQuestionIndex]["incorrect_answers"]);
                  optionsList.add(data[currentQuestionIndex]["correct_answer"]);
                  optionsList.shuffle();
                  isLoaded = true;
                }

                return Column(
                  children: [
                    // Top row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: lightgrey, width: 2),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              CupertinoIcons.xmark,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            normalText(
                                color: Colors.white,
                                size: 24,
                                text: "$seconds"),
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                value: seconds / 60,
                                valueColor: const AlwaysStoppedAnimation(
                                    Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: lightgrey, width: 2),
                          ),
                          child: TextButton.icon(
                            onPressed: null,
                            icon: const Icon(CupertinoIcons.heart_fill,
                                color: Colors.white, size: 18),
                            label: normalText(
                                color: Colors.white,
                                size: 14,
                                text: "Like"),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Flexible(
                      flex: 2,
                      child: Image.asset(ideas, width: 180),
                    ),

                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: normalText(
                        color: lightgrey,
                        size: 18,
                        text:
                            "Question ${currentQuestionIndex + 1} of ${data.length}",
                      ),
                    ),

                    const SizedBox(height: 10),

                    normalText(
                      color: Colors.white,
                      size: 20,
                      text: data[currentQuestionIndex]["question"],
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      flex: 4,
                      child: ListView.builder(
                        physics:
                            const NeverScrollableScrollPhysics(), // no scroll
                        itemCount: optionsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var answer =
                              data[currentQuestionIndex]["correct_answer"];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (answered) return;
                                answered = true;

                                if (answer.toString() ==
                                    optionsList[index].toString()) {
                                  optionsColor[index] = Colors.green;
                                  points += 10;
                                  correctAnswers++;
                                } else {
                                  optionsColor[index] = Colors.red;
                                  incorrectAnswers++;
                                }

                                if (currentQuestionIndex <
                                    data.length - 1) {
                                  Future.delayed(
                                      const Duration(seconds: 1), () {
                                    gotoNextQuestion();
                                  });
                                } else {
                                  timer?.cancel();
                                  Future.delayed(
                                      const Duration(seconds: 1), () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ResultPage(
                                          totalQuestions: data.length,
                                          correctAnswers: correctAnswers,
                                          incorrectAnswers: incorrectAnswers,
                                        ),
                                      ),
                                    );
                                  });
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              alignment: Alignment.center,
                              width: size.width * 0.8,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: optionsColor[index],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: headingText(
                                color: blue,
                                size: 16,
                                text: optionsList[index].toString(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
