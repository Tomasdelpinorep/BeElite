import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:flutter/material.dart';

class CoachProfileScreen extends StatefulWidget {
  final CoachDetails coachDetails;
  const CoachProfileScreen({super.key, required this.coachDetails});

  @override
  State<CoachProfileScreen> createState() => _CoachProfileScreenState();
}

class _CoachProfileScreenState extends State<CoachProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
