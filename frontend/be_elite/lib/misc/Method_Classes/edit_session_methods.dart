import 'package:be_elite/models/Session/post_session_dto/post_block_dto.dart';
import 'package:be_elite/models/Session/post_session_dto/post_session_dto.dart';
import 'package:flutter/material.dart';

class EditSessionMethods {
  EditSessionMethods();

  List<int> getSetsPerBlock(PostSessionDto session) {
    List<int> setsPerBlock = [];

    for (var block in session.blocks!) {
      setsPerBlock.add(block.sets!.length);
    }

    return setsPerBlock;
  }

  List<String> setBlockLetters(List<PostBlockDto> blocks) {
    List<String> blockLetters = [];

    for (int i = 0; i < blocks.length; i++) {
      String letter = String.fromCharCode('A'.codeUnitAt(0) + i);
      blockLetters.add(letter);
    }

    return blockLetters;
  }

  void setSessionControllerValues(
      PostSessionDto session,
      TextEditingController titleTextController,
      TextEditingController subtitleTextController) {
    titleTextController.text = session.title!;
    subtitleTextController.text = session.subtitle!;
  }

  void setBlockAndSetControllerValues(
    PostSessionDto session,
    List<TextEditingController> movementControllers,
    List<TextEditingController> blockInstructionsTextControllers,
    List<TextEditingController> restBetweenSetsTextControllers,
    List<TextEditingController> numberOfSetsTextControllers,
    List<TextEditingController> numberOfRepsTextControllers,
    List<TextEditingController> percentageTextControllers,
  ) {
    for (var block in session.blocks!) {
      TextEditingController movementController = TextEditingController();
      TextEditingController blockInstructionsTextController =
          TextEditingController();
      TextEditingController restBetweenSetsTextController =
          TextEditingController();

      movementController.text = block.movement ?? '';
      blockInstructionsTextController.text = block.blockInstructions ?? '';
      restBetweenSetsTextController.text =
          block.restBetweenSets?.toString() ?? '';

      movementControllers.add(movementController);
      blockInstructionsTextControllers.add(blockInstructionsTextController);
      restBetweenSetsTextControllers.add(restBetweenSetsTextController);

      for (var set in block.sets!) {
        TextEditingController numberOfSetsTextController =
            TextEditingController();
        TextEditingController numberOfRepsTextController =
            TextEditingController();
        TextEditingController percentageTextController =
            TextEditingController();

        numberOfSetsTextController.text = set.numberOfSets?.toString() ?? "";
        numberOfRepsTextController.text = set.numberOfReps?.toString() ?? "";
        percentageTextController.text = set.percentage?.toString() ?? "";

        numberOfSetsTextControllers.add(numberOfSetsTextController);
        numberOfRepsTextControllers.add(numberOfRepsTextController);
        percentageTextControllers.add(percentageTextController);
      }
    }
  }

  int getDayIndex(List<dynamic> span, String sessionDate) {
    for (int i = 0; i < span.length; i++) {
    if (span[i].toLowerCase() == sessionDate.toLowerCase()) {
      return i; 
    }
  }
    return 0;
  }
}
