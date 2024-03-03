import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/models/Coach/program_dto.dart';
import 'package:be_elite/widgets/beElite_logo.dart';
import 'package:be_elite/widgets/circular_avatar.dart';
import 'package:flutter/material.dart';

class ProgramsScreen extends StatefulWidget {
  final CoachDetails coachDetails;
  const ProgramsScreen({super.key, required this.coachDetails});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CircularProfileAvatar(
                imageUrl: widget.coachDetails.profilePicUrl ??
                    'https://i.imgur.com/jNNT4LE.png'),
            _programSelectorWidget(),
            const BeEliteLogo()
          ]),
        ),
        _weeksWidget(),
      ),
    );
  }

  Widget _programSelectorWidget() {
    String _dropDownValue =
        widget.coachDetails.programs?.first.programName ?? '';
    List<ProgramDto> _programs = [];

    if (widget.coachDetails.programs != null) {
      for (ProgramDto program in widget.coachDetails.programs!) {
        _programs.add(program);
      }
    }

    return Container(
      width: 300,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: DropdownButton<String>(
          focusColor: Colors.transparent,
          underline: Container(
            height: 0,
          ),
          items: [
            // Existing programs
            ..._programs.map((ProgramDto program) {
              return DropdownMenuItem<String>(
                value: program.programName,
                child: Row(
                  children: [
                    Image.network(
                      program.image!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 25),
                    Text(
                      program.programName!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }),
            // "Create New" option
            const DropdownMenuItem<String>(
              value: 'new',
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.white), // Icon for "Create New"
                  SizedBox(width: 8),
                  Text(
                    'Create New Program',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ],
              ),
            ),
          ],
          onChanged: (String? newValue) {
            setState(() {
              _dropDownValue = newValue!;
            });
          },
          value: _dropDownValue,
        ),
      ),
    );
  }

  Widget _weeksWidget(){
    
  }
}
