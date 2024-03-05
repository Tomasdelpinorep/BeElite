import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:be_elite/bloc/bloc/program_bloc.dart';
import 'package:be_elite/bloc/week/week_bloc.dart';
import 'package:be_elite/models/Coach/program_dto.dart';
import 'package:be_elite/models/Week/post_week_dto.dart';
import 'package:intl/intl.dart';
import 'package:be_elite/models/Week/week_dto.dart';
import 'package:be_elite/repositories/coach/coach_repository.dart';
import 'package:be_elite/repositories/coach/coach_repository_impl.dart';
import 'package:be_elite/repositories/program/program_repository.dart';
import 'package:be_elite/repositories/program/program_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/widgets/_weekDescriptionField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachAddWeekScreen extends StatefulWidget {
  final String programName;
  final WeekDto weeksPage;
  const CoachAddWeekScreen(
      {super.key, required this.programName, required this.weeksPage});

  @override
  State<CoachAddWeekScreen> createState() => _CoachAddWeekScreenState();
}

class _CoachAddWeekScreenState extends State<CoachAddWeekScreen> {
  final formKey = GlobalKey<FormState>();
  final weekNameTextController = TextEditingController();
  final weekDescriptionTextController = TextEditingController();

  List<String> _suggestions = [];
  late CoachRepository coachRepository;
  late ProgramRepository programRepository;
  late WeekBloc _weekBloc;
  late ProgramBloc _programBloc;
  late String weekDescriptionValue;
  late ProgramDto programDto;

  @override
  void initState() {
    coachRepository = CoachRepositoryImpl();
    programRepository = ProgramRepositoryImpl();
    _weekBloc = WeekBloc(coachRepository);
    _programBloc = ProgramBloc(programRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _weekBloc),
        BlocProvider.value(value: _programBloc)
      ], 
      child: _buildHome());
  }

  Widget _buildHome(){
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.grey[900]!, Colors.black],
              radius: 0.5,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: BlocConsumer<WeekBloc, WeekState>(
                    buildWhen: (context, state) {
                      return state is WeekLoadingState ||
                          state is WeekErrorState ||
                          state is WeekNamesSuccessState ||
                          state is SaveNewWeekSuccessState;
                    },
                    builder: (context, state) {
                      if (state is WeekErrorState) {
                        return const Text(
                            'An error occured while saving the new week.');
                      } else if (state is WeekLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is WeekSuccessState) {
                        return Container();
                      }else if(state is SaveNewWeekSuccessState){
                        throw AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.topSlide,
                          showCloseIcon: false,
                          title: 'Success',
                          desc: 'New week has been added to the program.'
                          );
                      }
                
                      return _addWeekForm();
                    },
                    listenWhen: (context, state) {
                      return state is SaveNewWeekSuccessState;
                    },
                    listener: (context, state) {
                      if (state is SaveNewWeekSuccessState) {
                        //Navigate back to programs page
                      }
                    },
                  ),
              ),
                Expanded(
                  child: BlocBuilder<ProgramBloc, ProgramState>(
                    buildWhen: (context, state){return state is GetProgramDtoSuccessState;},
                    builder: (context,state){
                      if(state is GetProgramDtoSuccessState){
                        DateTime now = DateTime.now();
                        String formattedDateTime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);

                        programDto = state.programDto;
                        _weekBloc.add(SaveNewWeekEvent(PostWeekDto(
                          created_at: formattedDateTime, 
                          week_name: weekNameTextController.text, 
                          description: weekDescriptionValue, 
                          program: programDto
                          )
                          ));
                      }
                      return Container();
                    },
                  ),
                )
            ],
          ),
          ));
  }

  Widget _addWeekForm() {
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
                  WeekDescriptionField(
                      weekNameTextController: weekNameTextController,
                      weekPage: widget.weeksPage,
                      handleWeekDescriptionChanged: handleWeekDescriptionChanged),
                  const SizedBox(height: 30),
                  _saveButton(),
                ])),
          ],
        ));
  }

  Widget _weekNameField() {
    List<String> existingWeekNames =
        List.from(extractWeekNames(widget.weeksPage.content!));

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

  Widget _saveButton() {
    return Container(
      decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Color(0xFFD6CD0B), blurRadius: 5)]),
      child: FilledButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            _programBloc.add(GetProgramDtoEvent(widget.programName));
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainYellow,
            fixedSize: const Size(200, 50),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(5, 5)))),
        child: const Text(
          "Add new week",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }

  Set<String> extractWeekNames(dynamic content) {
    Set<String> weekNames = {};
    if (content != null && content is List) {
      for (var item in content) {
        String? weekName = item.weekName;
        if (weekName != null) {
          weekNames.add(weekName);
        }
      }
    }
    return weekNames;
  }

  void handleWeekDescriptionChanged(String? weekDescription) {
    weekDescription != null ?
    weekDescriptionValue = weekDescription :
    weekDescriptionValue = "";
  }
}