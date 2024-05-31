import 'package:be_elite/bloc/program/program_bloc.dart';
import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/models/Coach/program_dto.dart';
import 'package:be_elite/models/Program/post_program_dto.dart';
import 'package:be_elite/repositories/program/program_repository.dart';
import 'package:be_elite/repositories/program/program_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/coach/coach_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CoachAddProgramScreen extends StatefulWidget {
  final CoachDetails coachDetails;
  final ProgramDto? program;
  const CoachAddProgramScreen(
      {super.key, required this.coachDetails, this.program});

  @override
  State<CoachAddProgramScreen> createState() => _CoachAddProgramScreenState();
}

class _CoachAddProgramScreenState extends State<CoachAddProgramScreen> {
  final formKey = GlobalKey<FormState>();
  final programNameTextController = TextEditingController();
  final programDescriptionTextController = TextEditingController();
  final imageUrlDescriptionTextController = TextEditingController();

  late ProgramBloc _programBloc;
  late ProgramRepository programRepository;

  @override
  void initState() {
    programRepository = ProgramRepositoryImpl();
    _programBloc = ProgramBloc(programRepository);

    if (widget.program != null) {
      _loadProgramData(widget.program!);
    }
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
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocProvider.value(
                  value: _programBloc,
                  child: BlocConsumer<ProgramBloc, ProgramState>(
                    buildWhen: (context, state) {
                      return state is ProgramErrorState ||
                          state is ProgramLoadingState ||
                          state is CreateProgramSuccessState;
                    },
                    builder: (context, state) {
                      if (state is ProgramErrorState) {
                        return const Text(
                            'An error occured while trying to create a new program.');
                      } else if (state is ProgramLoadingState) {
                        return const CircularProgressIndicator();
                      } else if (state is CreateProgramSuccessState) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // Show dialog
                              return AlertDialog(
                                title: const Text('Success!',
                                    style: TextStyle(color: Colors.white)),
                                content: const Text(
                                    'New program has been successfully created.',
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: AppColors.successGreen,
                              );
                            },
                          );
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CoachMainScreen()),
                            );
                          });
                        });
                      }

                      return _newProgramForm();
                    },
                    listener: (context, state) {},
                  ),
                ))));
  }

  Widget _newProgramForm() {
    return Form(
      key: formKey,
      child: Column(children: [
        _programNameField(),
        const SizedBox(height: 30),
        _programDescriptionField(),
        const SizedBox(height: 30),
        _programImageUrlField(),
        const SizedBox(height: 30),
        _saveButton()
      ]),
    );
  }

  Widget _programNameField() {
    return SizedBox(
      width: 400,
      child: Column(children: [
        TextFormField(
          controller: programNameTextController,
          decoration: const InputDecoration(
            hintText: "Program name",
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54), // Underline color
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white), // Focused underline color
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Program name cannot be empty';
            } else if (value.length > 20) {
              return 'Cannot be more than 20 characters long.';
            }
            return null;
          },
        )
      ]),
    );
  }

  Widget _programDescriptionField() {
    return SizedBox(
      width: 400,
      child: Column(children: [
        TextFormField(
          maxLines: 3,
          controller: programDescriptionTextController,
          decoration: const InputDecoration(
            hintText: "Program description",
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54), // Underline color
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white), // Focused underline color
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Program description cannot be empty';
            } else if (value.length > 200) {
              return 'Cannot be more than 200 characters long.';
            }
            return null;
          },
        )
      ]),
    );
  }

  Widget _programImageUrlField() {
    return SizedBox(
      width: 400,
      child: Column(children: [
        TextFormField(
          controller: imageUrlDescriptionTextController,
          decoration: const InputDecoration(
            hintText: "Program image Url",
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54), // Underline color
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white), // Focused underline color
            ),
          ),
        )
      ]),
    );
  }

  Widget _saveButton() {
    return Container(
      decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Color(0xFFD6CD0B), blurRadius: 5)]),
      child: FilledButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            DateTime now = DateTime.now();
            String formattedDateTime =
                DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);
            _programBloc.add(CreateNewProgramEvent(PostProgramDto(
                coachId: widget.coachDetails.id,
                createdAt: formattedDateTime,
                programName: programNameTextController.text,
                description: programDescriptionTextController.text,
                image: imageUrlDescriptionTextController.text)));
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainYellow,
            fixedSize: const Size(200, 50),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(5, 5)))),
        child: widget.program == null
            ? const Text(
                "Create Program",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )
            : const Text(
                "Save Changes",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
      ),
    );
  }

  _loadProgramData(ProgramDto program) {
    programNameTextController.text = program.program_name!;
    programDescriptionTextController.text = program.program_description ?? "";
    imageUrlDescriptionTextController.text = program.image ?? "";
  }
}
