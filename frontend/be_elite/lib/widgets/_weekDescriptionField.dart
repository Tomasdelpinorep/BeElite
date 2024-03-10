import 'package:be_elite/models/Week/content.dart';
import 'package:be_elite/models/Week/week_dto.dart';
import 'package:flutter/material.dart';

class WeekDescriptionField extends StatefulWidget {
  final TextEditingController weekNameTextController;
  final WeekDto weekPage;
  final Function handleWeekDescriptionChanged;
  const WeekDescriptionField(
      {super.key,
      required this.weekNameTextController,
      required this.weekPage,
      required this.handleWeekDescriptionChanged});

  @override
  State<WeekDescriptionField> createState() => _WeekDescriptionFieldState();
}

class _WeekDescriptionFieldState extends State<WeekDescriptionField> {
  final weekDescriptionTextController = TextEditingController();
  String? weekDescription;

  @override
  void initState() {
    super.initState();
    widget.weekNameTextController.addListener(updateWeekDescription);
  }

  @override
  void dispose() {
    widget.weekNameTextController.removeListener(updateWeekDescription);
    super.dispose();
  }

  void updateWeekDescription() {
    String currentWeekName = widget.weekNameTextController.text;
    Content? matchingWeek = widget.weekPage.content?.firstWhere(
        (week) => week.weekName == currentWeekName,
        orElse: () => Content());
    setState(() {
      if (matchingWeek == Content()) {
        weekDescription = 'Week description';
      } else {
        weekDescription = matchingWeek?.description;
        weekDescriptionTextController.text = weekDescription!;
      }
      widget.handleWeekDescriptionChanged(weekDescription);
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
          onChanged: (value){
            widget.handleWeekDescriptionChanged(value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Week description cannot be empty.';
            }
            return null;
          }),
    );
  }
}
