import 'package:be_elite/bloc/week/week_bloc.dart';
import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/models/Coach/program_dto.dart';
import 'package:be_elite/models/Week/week_dto.dart';
import 'package:be_elite/repositories/coach/coach_repository.dart';
import 'package:be_elite/repositories/coach/coach_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/coach/coach_add_week_screen.dart';
import 'package:be_elite/widgets/beElite_logo.dart';
import 'package:be_elite/widgets/circular_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgramsScreen extends StatefulWidget {
  final CoachDetails coachDetails;
  const ProgramsScreen({super.key, required this.coachDetails});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  late CoachRepository _coachRepository;
  late WeekBloc _weekBloc;
  late String programName;
  late WeekDto weekPage;

  @override
  void initState() {
    _coachRepository = CoachRepositoryImpl();
    programName = widget.coachDetails.programs!.first.program_name.toString();
    _weekBloc = WeekBloc(_coachRepository)..add(GetWeeksEvent(programName));
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Row(
                  children: [
                    CircularProfileAvatar(
                        imageUrl: widget.coachDetails.profilePicUrl ??
                            'https://i.imgur.com/jNNT4LE.png'),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right:
                                40), //This centers the welcome message over the program selector, 40 is avatar's radius
                        child: Column(
                          children: [
                            Text('Hello ${widget.coachDetails.name}'),
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
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _programSelectorWidget(),
                ]),
              ),
              Expanded(
                child: Stack(
                  children: [
                    _weeksBlocWidget(),
                    Positioned(bottom: 0, right: 0, child: _addWeekButton())
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _programSelectorWidget() {
    String dropDownValue =
        widget.coachDetails.programs?.first.program_name ?? '';
    List<ProgramDto> programs = [];

    if (widget.coachDetails.programs != null) {
      for (ProgramDto program in widget.coachDetails.programs!) {
        programs.add(program);
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
            ...programs.map((ProgramDto program) {
              return DropdownMenuItem<String>(
                value: program.program_name,
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
                      program.program_name!,
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
          onChanged: (String? newValue) {
            setState(() {
              dropDownValue = newValue!;
              programName = dropDownValue;
            });
          },
          value: dropDownValue,
        ),
      ),
    );
  }

  Widget _weeksBlocWidget() {
    return Container(
      alignment: Alignment.center,
      child: BlocProvider.value(
        value: _weekBloc,
        child: BlocConsumer<WeekBloc, WeekState>(
          buildWhen: (context, state) {
            return state is WeekLoadingState ||
                state is WeekErrorState ||
                state is WeekSuccessState;
          },
          builder: (context, state) {
            if (state is WeekLoadingState) {
              return const CircularProgressIndicator();
            } else if (state is WeekErrorState) {
              return const Text('Error fetching week data.');
            } else if (state is WeekSuccessState) {
              weekPage = state.week;
              return weeksWidget(state.week);
            } else {
              return const Placeholder();
            }
          },
          listener: (context, state) {},
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
                                    Text(capitalizeFirstLetter(week.weekName!),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22)),
                                    Text(
                                        capitalizeFirstLetter(
                                            week.description!),
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
                                        child: const Icon(Icons.edit,
                                            color: Colors.black, size: 26)),
                                    const SizedBox(height: 5),
                                    GestureDetector(
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
                            children: week.sessions!.isNotEmpty
                                ? week.sessions!.map((session) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                              horizontal: 4)
                                          .copyWith(top: 12),
                                      child: SizedBox(
                                        width: 150,
                                        child: OutlinedButton(
                                          onPressed: () {},
                                          style: const ButtonStyle(
                                              overlayColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.black45)),
                                          child: session.sessionNumber! > 1
                                              ? Text(
                                                  "${capitalizeFirstLetter(session.dayOfWeek!)} #${session.sessionNumber}",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w100))
                                              : Text(
                                                  capitalizeFirstLetter(
                                                      session.dayOfWeek!),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w100)),
                                        ),
                                      ),
                                    );
                                  }).toList()
                                : [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                              horizontal: 4)
                                          .copyWith(top: 12),
                                      child: OutlinedButton.icon(
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        label: const Text('New session',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300)),
                                        style: const ButtonStyle(
                                            overlayColor:
                                                MaterialStatePropertyAll(
                                                    Colors.black45)),
                                        onPressed: () {
                                          //Navigate to new session page
                                        },
                                      ),
                                    )
                                  ]),
                      )
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

  Widget _addWeekButton() {
    // Change to floating button at bottom right
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(boxShadow: const [
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
