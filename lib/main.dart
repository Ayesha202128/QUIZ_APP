import 'package:project_app/const/images.dart';
import 'package:project_app/const/colors.dart';
import 'package:project_app/const/text_style.dart';
import 'package:project_app/page/sign_in.dart';
import 'package:project_app/page/sign_up.dart';
import 'package:project_app/quiz_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_app/page/note_page.dart';

main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: blue));
  await Supabase.initialize(
      url: "https://ntycdtmuyzsymqbbkdwp.supabase.co",
      anonKey:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im50eWNkdG11eXpzeW1xYmJrZHdwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzNjAwNTEsImV4cCI6MjA3MTkzNjA1MX0.rwFYZdaX3hfjhGK1AP2snkb34UXkn_mOFVtb4qEdUVg");

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SignInPage(),
      theme: ThemeData(
        fontFamily: "quick",
      ),
      title: "QUIZ_APP",
    );
  }
}

class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

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
          child: Stack( // <-- CHANGED: Wrapped children in a Stack to position X button independently
            children: [
              // X button at top-left
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: lightgrey, width: 2),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.xmark,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),

              // Centered column
              Center( // <-- CHANGED: Center widget added to vertically center balloon & text
                child: Column(
                  mainAxisSize: MainAxisSize.min, // <-- CHANGED: Ensures column only takes needed height
                  children: [
                    Image.asset(balloon2, width: 200),
                    const SizedBox(height: 20),
                    headingText(
                        color: Colors.white,
                        size: 32,
                        text: "Welcome to our \n Quiz App"),
                    const SizedBox(height: 20),
                    normalText(
                        color: lightgrey,
                        size: 16,
                        text:
                            "Do you feel confident? Here you'll face our most difficult questions!"),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QuizScreen()));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width - 100,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            headingText(color: blue, size: 18, text: "Continue"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
