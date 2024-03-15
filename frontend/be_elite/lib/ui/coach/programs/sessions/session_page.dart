import 'package:flutter/material.dart';

class CoachSessionPage extends StatefulWidget {
  final String coachUsername;
  final String weekName;
  final int weekNumber;
  final String programName;
  const CoachSessionPage({super.key, required this.coachUsername, required this.weekName, required this.weekNumber, required this.programName});

  @override
  State<CoachSessionPage> createState() => _CoachSessionPageState();
}

class _CoachSessionPageState extends State<CoachSessionPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}