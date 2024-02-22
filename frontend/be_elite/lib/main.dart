import 'package:be_elite/ui/athlete/athlete_main_screen.dart';
import 'package:be_elite/ui/coach/coach_main_screen.dart';
import 'package:be_elite/ui/intro_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeElite',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.yellow,
      ),
      home: const IntroScreen(),
      routes: {
        '/athlete': (context) => const AthleteMainScreen(),
        '/coach': (context) => const CoachMainScreen()
      },
    );
  }
}