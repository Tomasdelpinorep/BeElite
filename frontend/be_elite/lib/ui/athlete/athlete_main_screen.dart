import 'package:flutter/material.dart';

class AthleteMainScreen extends StatefulWidget {
  const AthleteMainScreen({super.key});

  @override
  State<AthleteMainScreen> createState() => _AthleteMainScreenState();
}

class _AthleteMainScreenState extends State<AthleteMainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("you have logged in")
    );
  }
}