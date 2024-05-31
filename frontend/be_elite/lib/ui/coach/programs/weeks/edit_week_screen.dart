import 'package:be_elite/bloc/Week/week_bloc.dart';
import 'package:be_elite/bloc/program/program_bloc.dart';
import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/models/Program/program_dto.dart';
import 'package:be_elite/models/Week/content.dart';
import 'package:be_elite/models/Week/edit_week_dto.dart';
import 'package:be_elite/models/Week/week_dto.dart';
import 'package:be_elite/repositories/coach/coach_repository.dart';
import 'package:be_elite/repositories/coach/coach_repository_impl.dart';
import 'package:be_elite/repositories/program/program_repository.dart';
import 'package:be_elite/repositories/program/program_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/coach/programs/weeks/coach_add_week_screen.dart';
import 'package:be_elite/ui/coach/coach_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EditWeekScreen extends StatefulWidget {
  final WeekContent week;
  final String programName;
  final CoachDetails coachDetails;
  final WeekDto weekPage;
  const EditWeekScreen(
      {super.key,
      required this.week,
      required this.programName,
      required this.coachDetails,
      required this.weekPage});

  @override
  State<EditWeekScreen> createState() => _EditWeekScreenState();
}

class _EditWeekScreenState extends State<EditWeekScreen> {
  final formKey = GlobalKey<FormState>();
  final weekNameTextController = TextEditingController();
  final weekDescriptionTextController = TextEditingController();
  List<String> _suggestions = [];

  late ProgramBloc _programBloc;
  late ProgramRepository programRepository;
  late WeekBloc _weekBloc;
  late CoachRepository coachRepository;
  late ProgramDto programDto;

  @override
  void initState() {
    coachRepository = CoachRepositoryImpl();
    _weekBloc = WeekBloc(coachRepository);
    programRepository = ProgramRepositoryImpl();
    _programBloc = ProgramBloc(programRepository);
    weekNameTextController.text = widget.week.weekName!;
    weekDescriptionTextController.text = widget.week.description!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider.value(value: _weekBloc),
      BlocProvider.value(value: _programBloc)
    ], child: _buildEditForm());
  }

  Widget _buildEditForm() {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.grey[800]!, Colors.grey[900]!],
                radius: 0.5,
              ),
            ),
            child: Column(
              children: [
                // Handles saving the edited week
                Expanded(
                  child: BlocBuilder<WeekBloc, WeekState>(
                    buildWhen: (context, state) {
                      return state is WeekLoadingState ||
                          state is WeekErrorState ||
                          state is WeekNamesSuccessState ||
                          state is SaveNewWeekSuccessState;
                    },
                    builder: (context, state) {
                      if (state is WeekErrorState) {
                        return const Text(
                            'An error occured while saving the edited week.');
                      } else if (state is WeekLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is WeekSuccessState) {
                        return Container();
                      } else if (state is SaveNewWeekSuccessState) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // Show dialog
                              return AlertDialog(
                                title: const Text('Success!',
                                    style: TextStyle(color: Colors.white)),
                                content: const Text(
                                    'Your changes have been saved.',
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

                      return _editWeekForm();
                    },
                  ),
                ),

                // Handles getting the program of the week, necessary to save the edited week
                Expanded(
                  child: BlocBuilder<ProgramBloc, ProgramState>(
                    buildWhen: (context, state) {
                      return state is GetProgramDtoSuccessState;
                    },
                    builder: (context, state) {
                      if (state is GetProgramDtoSuccessState) {
                        DateTime now = DateTime.now();
                        String formattedDateTime =
                            DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);

                        programDto = state.programDto;
                        _weekBloc.add(SaveEditedWeekEvent(EditWeekDto(
                            created_at: formattedDateTime,
                            week_name: weekNameTextController.text,
                            original_name: widget.week.weekName,
                            description: weekDescriptionTextController.text,
                            program: programDto,
                            week_number: widget.week.weekNumber)));
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            )));
  }

  Widget _editWeekForm() {
    return Form(
        key: formKey,
        child: Column(
          children: [
            Flexible(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  _weekNameField(),
                  const SizedBox(height: 30),
                  _weekDescriptionField(),
                  const SizedBox(height: 30),
                  _saveButton(),
                ])),
          ],
        ));
  }

  Widget _weekNameField() {
    List<String> existingWeekNames = List.from(
        CoachAddWeekScreenState.extractWeekNames(widget.weekPage.content));

    return SizedBox(
      width: 400,
      child: Column(
        children: [
          TextField(
            controller: weekNameTextController,
            onTap: () {
              if (weekNameTextController.value.text.isEmpty) {
                setState(() {
                  _suggestions = existingWeekNames;
                });
              }
            },
            onChanged: (weekName) {
              setState(() {
                _suggestions = existingWeekNames
                    .where((existingWeekName) => existingWeekName
                        .toLowerCase()
                        .contains(weekName.toLowerCase()))
                    .toList();
              });
            },
            decoration: const InputDecoration(
              hintText: "Week Name",
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white54), // Underline color
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white), // Focused underline color
              ),
            ),
          ),
          const SizedBox(height: 10),
          _suggestions.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_suggestions[index]),
                      onTap: () {
                        weekNameTextController.text = _suggestions[index];
                        setState(() {
                          _suggestions.clear();
                        });
                      },
                    );
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _weekDescriptionField() {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          TextFormField(
            controller: weekDescriptionTextController,
            decoration: InputDecoration(
              hintText: widget.week.description,
              hintStyle: const TextStyle(color: Colors.white54),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveButton() {
    return Container(
      decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Color(0xFFD6CD0B), blurRadius: 5)]),
      child: FilledButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            _programBloc.add(GetProgramDtoEvent(widget.programName));
            // _weekBloc.add(SaveEditedWeekEvent(PostWeekDto(created_at: widget.week.created_at, description: weekDescriptionTextController.text, week_name: weekNameTextController.text)));
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainYellow,
            fixedSize: const Size(200, 50),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(5, 5)))),
        child: const Text(
          "Save changes",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}
