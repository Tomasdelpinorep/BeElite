import 'package:flutter/material.dart';

class AthleteMainScreen extends StatefulWidget {
  const AthleteMainScreen({super.key});

  @override
  State<AthleteMainScreen> createState() => _AthleteMainScreenState();
}

class _AthleteMainScreenState extends State<AthleteMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text('This is the main athlete page'),
    );
  }
}
