import 'package:be_elite/bloc/Week/week_bloc.dart';
import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/models/Program/program_dto.dart';
import 'package:be_elite/models/Week/content.dart';
import 'package:be_elite/models/Week/week_dto.dart';
import 'package:be_elite/repositories/coach/coach_repository.dart';
import 'package:be_elite/repositories/coach/coach_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/coach/programs/add_program_screen.dart';
import 'package:be_elite/ui/coach/programs/sessions/create_edit_session.dart';
import 'package:be_elite/ui/coach/programs/weeks/coach_add_week_screen.dart';
import 'package:be_elite/ui/coach/coach_main_screen.dart';
import 'package:be_elite/ui/coach/programs/weeks/edit_week_screen.dart';
import 'package:be_elite/misc/Widgets/beElite_logo.dart';
import 'package:be_elite/misc/Widgets/circular_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgramsScreen extends StatefulWidget {
  final CoachDetails coachDetails;
  const ProgramsScreen({super.key, required this.coachDetails});

  @override
  State<ProgramsScreen> createState() => ProgramsScreenState();
}

class ProgramsScreenState extends State<ProgramsScreen> {
  late String dropDownValue;
  late CoachRepository _coachRepository;
  late WeekBloc _weekBloc;
  late String programName;
  late WeekDto weekPage;

  @override
  void initState() {
    _coachRepository = CoachRepositoryImpl();
    _weekBloc = WeekBloc(_coachRepository);
    _loadDropDownValue();
    super.initState();
  }

  // loads the dropdown value from shared preferences
  Future<void> _loadDropDownValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dropDownValue = (prefs.getString('selectedProgramName') ??
          widget.coachDetails.programs?.first.programName)!;
      programName = dropDownValue;
    });

    _weekBloc.add(GetWeeksEvent(programName));
  }

  // saves the selected value to shared preferences
  Future<void> _saveDropDownValue(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedProgramName', value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.grey[800]!, Colors.grey[900]!],
          radius: 0.5,
        ),
      ),
      child: BlocProvider.value(
        value: _weekBloc,
        child: BlocConsumer<WeekBloc, WeekState>(
          buildWhen: (context, state) {
            return state is WeekLoadingState ||
                state is WeekErrorState ||
                state is WeekSuccessState ||
                state is EmptyWeekListState;
          },
          builder: (context, state) {
            if (state is WeekLoadingState) {
              return const CircularProgressIndicator();
            } else if (state is WeekErrorState) {
              return const Text('Error fetching week data.');
            } else if (state is WeekSuccessState) {
              weekPage = state.week;
              return _buildHome(state.week);
            } else if (state is EmptyWeekListState) {
              weekPage = WeekDto();
              return _buildEmptyHome();
            } else {
              return const Placeholder();
            }
          },
          listener: (context, state) {
            if (state is DeleteWeekSuccessState) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // Show dialog
                  return AlertDialog(
                    title: const Text('Success!',
                        style: TextStyle(color: Colors.white)),
                    content: const Text('Week has been deleted.',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: AppColors.successGreen,
                  );
                },
              );
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CoachMainScreen()),
                );
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyHome() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _topBarWidget(widget.coachDetails),
          Expanded(
            child: Stack(
              children: [
                const Center(
                    child: Text('Your training weeks will appear here.')),
                Positioned(bottom: 0, right: 0, child: _addWeekButton())
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHome(WeekDto weekPage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _topBarWidget(widget.coachDetails),
          Expanded(
            child: Stack(
              children: [
                weeksWidget(weekPage),
                Positioned(bottom: 0, right: 0, child: _addWeekButton())
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBarWidget(CoachDetails coachDetails) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            children: [
              CircularProfileAvatar(
                  imageUrl: coachDetails.profilePicUrl ??
                      'https://i.imgur.com/jNNT4LE.png', radius: 40),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      right:
                          40), //This centers the welcome message over the program selector, 40 is avatar's radius
                  child: Column(
                    children: [
                      Text('Hello ${coachDetails.name}'),
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
              const BeEliteLogo()
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _programSelectorWidget(coachDetails),
          ]),
        ),
      ],
    );
  }

  Widget _programSelectorWidget(CoachDetails coachDetails) {
    List<ProgramDto>? programs = coachDetails.programs;

    programs ??= [];

    return Container(
      width: 472,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: DropdownButton<String>(
          focusColor: Colors.transparent,
          underline: Container(),
          items: [
            // Existing programs
            ...programs.map((ProgramDto program) {
              return DropdownMenuItem<String>(
                value: program.programName,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      program.programPicUrl!.isNotEmpty
                          ? Image.network(
                              program.programPicUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              'https://i.imgur.com/95vlMNd.jpg',
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
                ),
                onTap: () {
                  _weekBloc.add(GetWeeksEvent(program.programName!));
                },
              );
            }),
            // "Create New" option
            const DropdownMenuItem<String>(
              value: 'new',
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline,
                      color: Colors.white), // Icon for "Create New"
                  SizedBox(width: 8),
                  Text(
                    'Create New Program',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
          value: dropDownValue,
          onChanged: (String? newValue) {
            if (newValue != dropDownValue) {
              switch (newValue) {
                case 'new':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CoachAddProgramScreen(
                              coachDetails: coachDetails)));
                  break;
              }

              setState(() {
                dropDownValue = newValue!;
                programName = dropDownValue;
                _saveDropDownValue(dropDownValue);
              });

              _weekBloc.add(GetWeeksEvent(programName));
            }
          },
        ),
      ),
    );
  }

  Widget weeksWidget(WeekDto weekPage) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: MediaQuery.of(context).size.width * 0.8,
      child: SingleChildScrollView(
        child: Column(
          children: weekPage.content!.map((week) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0)
                  .copyWith(bottom: 40),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.mainYellow,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(4).copyWith(left: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${capitalizeFirstLetter(week.weekName!)} - Week ${week.weekNumber!}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22)),
                                    Text(
                                        week.span != null
                                            ? '${week.span!.first} - ${week.span!.last}'
                                            : week.description!,
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14),
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditWeekScreen(
                                                          week: week,
                                                          programName:
                                                              programName,
                                                          coachDetails: widget
                                                              .coachDetails,
                                                          weekPage: weekPage)));
                                        },
                                        child: const Icon(Icons.edit,
                                            color: Colors.black, size: 26)),
                                    const SizedBox(height: 5),
                                    GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Row(
                                                  children: [
                                                    Icon(Icons.delete),
                                                    Expanded(
                                                      child: Text('Delete?',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ],
                                                ),
                                                content: const Text(
                                                    'All associated sessions will be deleted too.',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                backgroundColor:
                                                    Colors.grey[800],
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      TextButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(
                                                                      Colors.grey[
                                                                          600])),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              'No',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))),
                                                      TextButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(
                                                                      AppColors
                                                                          .alertYellow)),
                                                          onPressed: () {
                                                            _weekBloc.add(DeleteWeekEvent(
                                                                widget.coachDetails
                                                                    .username!,
                                                                programName
                                                                    .replaceAll(
                                                                        ' ',
                                                                        '%20'),
                                                                week.weekName!
                                                                    .replaceAll(
                                                                        ' ',
                                                                        '%20'),
                                                                week.weekNumber!));
                                                          },
                                                          child: const Text(
                                                              'Yes',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))),
                                                    ],
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Icon(Icons.delete,
                                            color: Colors.black, size: 26))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Wrap(
                            alignment: WrapAlignment.spaceAround,
                            children: [
                              if (week.sessions != null &&
                                  week.sessions!.isNotEmpty)
                                ...week.sessions!.map((session) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                            horizontal: 4)
                                        .copyWith(top: 12),
                                    child: SizedBox(
                                      width: 150,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CoachCreateOrEditSessionScreen(
                                                week: week,
                                                coachUsername: widget
                                                    .coachDetails.username!,
                                                programName: programName,
                                                weekName: week.weekName!,
                                                weekNumber: week.weekNumber!,
                                                sessionNumber:
                                                    session.sessionNumber!,
                                              ),
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  Colors.black45),
                                        ),
                                        child: session.sameDaySessionNumber! > 1
                                            ? Text(
                                                "${DateFormat('EEEE').format(DateTime.parse(session.date!))} #${session.sameDaySessionNumber}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w100,
                                                ),
                                              )
                                            : Text(
                                                    DateFormat('EEEE').format(DateTime.parse(session.date!)),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w100,
                                                ),
                                              ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              _newSessionButton(week)
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _newSessionButton(WeekContent week) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4).copyWith(top: 12),
      child: OutlinedButton.icon(
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text('New session',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
        style: const ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Colors.black45)),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CoachCreateOrEditSessionScreen(
                      week: week,
                      coachUsername: widget.coachDetails.username!,
                      programName: programName,
                      weekName: week.weekName!,
                      weekNumber: week.weekNumber!)));
        },
      ),
    );
  }

  Widget _addWeekButton() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(color: Colors.black54, spreadRadius: 2, blurRadius: 7)
          ],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black45, width: 2.0)),
      child: FloatingActionButton(
          backgroundColor: Colors.yellowAccent,
          child: const Icon(Icons.add, color: Colors.black),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CoachAddWeekScreen(
                        programName: programName,
                        weeksPage: weekPage,
                        coachDetails: widget.coachDetails)));
          }),
    );
  }
}

String capitalizeFirstLetter(String s) {
  if (s.isEmpty) return s;
  return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
}
