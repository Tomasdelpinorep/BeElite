import 'package:be_elite/models/Session/Athlete%20Sessions/block.dart';
import 'package:be_elite/models/Session/session_card_dto/block_dto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AthleteScreenMethods {
  AthleteScreenMethods();

  String getSessionCardTitle(String date) {
    DateTime dateTime = DateTime.parse(date);

    DateFormat formatter = DateFormat('EEEE, MMMM d');

    String formattedDate = formatter.format(dateTime);

    return formattedDate;
  }

  double getNumberOfWorkoutsCompleted(List<Block> blocks) {
    double count = 0;
    for (var block in blocks) {
      if (block.isCompleted!) {
        count++;
      }
    }
    return count;
  }

  double getNumberOfBlocksCompleted(List<AthleteBlockDto> blocks) {
    double count = 0;
    for (var block in blocks) {
      if (block.isCompleted!) {
        count++;
      }
    }
    return count;
  }

  String getBlockLetter(int blockIndex) {
    if (blockIndex < 26) {
      return String.fromCharCode('A'.codeUnitAt(0) + blockIndex);
    } else {
      return blockIndex.toString();
    }
  }

  void setBlockControllerValues(AthleteBlockDto block, TextEditingController feedbackController) {
    block.feedback == null ? feedbackController.text = '' : feedbackController.text = block.feedback;
  }
}
