import 'package:flutter/material.dart';

class CoachMainScreen extends StatefulWidget {
  const CoachMainScreen({super.key});

  @override
  State<CoachMainScreen> createState() => _CoachMainScreenState();
}

class _CoachMainScreenState extends State<CoachMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text('This is the main coach page'),
    );
  }
}