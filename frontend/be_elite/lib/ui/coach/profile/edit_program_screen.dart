import 'package:be_elite/models/Program/program_dto.dart';
import 'package:flutter/material.dart';

class EditProgramScreen extends StatefulWidget {
  final ProgramDto program;
  const EditProgramScreen({super.key, required this.program});

  @override
  State<EditProgramScreen> createState() => _EditProgramScreenState();
}

class _EditProgramScreenState extends State<EditProgramScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
