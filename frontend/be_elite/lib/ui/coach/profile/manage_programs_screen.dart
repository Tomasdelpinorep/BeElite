import 'package:be_elite/bloc/program/program_bloc.dart';
import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/models/Program/program_dto.dart';
import 'package:be_elite/repositories/program/program_repository.dart';
import 'package:be_elite/repositories/program/program_repository_impl.dart';
import 'package:be_elite/ui/coach/programs/add_program_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageProgramsScreen extends StatefulWidget {
  final List<ProgramDto> programs;
  final CoachDetails coachDetails;
  const ManageProgramsScreen(
      {super.key, required this.programs, required this.coachDetails});

  @override
  State<ManageProgramsScreen> createState() => _ManageProgramsScreenState();
}

class _ManageProgramsScreenState extends State<ManageProgramsScreen> {
  late ProgramRepository programRepository;
  late ProgramBloc _programBloc;

  @override
  void initState() {
    programRepository = ProgramRepositoryImpl();
    _programBloc = ProgramBloc(programRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.grey[800]!, Colors.grey[900]!],
            radius: 0.5,
          ),
        ),
        child: MultiBlocProvider(providers: [
          BlocProvider.value(value: _programBloc),
        ], child: _blocManager()),
      ),
    );
  }

  Widget _blocManager() {
    return Column(
      children: [
        BlocConsumer<ProgramBloc, ProgramState>(
            builder: (context, state) {
              return _buildHome();
            },
            listener: (context, state) {})
      ],
    );
  }

  Widget _buildHome() {
    if (widget.programs.isEmpty) {
      return const Text("You don't have any programs.");
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const Text('Your Programs:',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 50),
          SingleChildScrollView(
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Divider(color: Colors.grey, height: 1),
              ),
              itemCount: widget.programs.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    widget.programs[index].programPicUrl!.isNotEmpty
                        ? Container(
                            decoration: const BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                  spreadRadius: 1)
                            ]),
                            child: Image.network(
                              widget.programs[index].programPicUrl!,
                              width: 125,
                              height: 75,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            decoration: const BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                  spreadRadius: 1)
                            ]),
                            child: Image.network(
                              'https://i.imgur.com/95vlMNd.jpg',
                              width: 125,
                              height: 75,
                              fit: BoxFit.cover,
                            ),
                          ),
                    const SizedBox(width: 25),
                    Expanded(
                      child: Text(
                        widget.programs[index].programName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                        child: const Icon(Icons.edit, size: 32),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CoachAddProgramScreen(
                                        program: widget.programs[index],
                                        coachDetails: widget.coachDetails,
                                      )));
                        }),
                    const SizedBox(width: 25),
                    GestureDetector(
                        child: const Icon(Icons.delete, size: 32), onTap: () {})
                  ],
                );
              },
            ),
          )
        ]),
      );
    }
  }
}
