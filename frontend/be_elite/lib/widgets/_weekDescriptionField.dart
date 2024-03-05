import 'package:be_elite/models/Week/content.dart';
import 'package:be_elite/models/Week/week_dto.dart';
import 'package:flutter/material.dart';

class WeekDescriptionField extends StatefulWidget {
  final TextEditingController weekNameTextController;
  final WeekDto weekPage;
  const WeekDescriptionField({super.key, required this.weekNameTextController, required this.weekPage});

  @override
  State<WeekDescriptionField> createState() => _WeekDescriptionFieldState();
}

class _WeekDescriptionFieldState extends State<WeekDescriptionField> {
  final weekDescriptionTextController = TextEditingController();
  String? weekDescription;

  @override
  void initState() {
    super.initState();
    // Add listener to weekNameTextController
    widget.weekNameTextController.addListener(updateWeekDescription);
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks
    widget.weekNameTextController.removeListener(updateWeekDescription);
    super.dispose();
  }

  void updateWeekDescription() {
    String currentWeekName = widget.weekNameTextController.text;
    Content? matchingWeek = widget.weekPage.content?.firstWhere(
      (week) => week.weekName == currentWeekName,
      orElse: () => Content()
    );
    setState(() {
      if(matchingWeek == Content()){
        weekDescription = 'Week description';
      }
      weekDescription = matchingWeek?.description;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: weekDescriptionTextController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText:
              weekDescription == null ? 'Week Description' : weekDescription!,
          hintStyle: const TextStyle(color: Colors.white54),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Week description cannot be empty.';
          }
          return null;
        },
        onChanged: (value) {
          // Handle onChanged if needed
        },
      ),
    );
  }
}
