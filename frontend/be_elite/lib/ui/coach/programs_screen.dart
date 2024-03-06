import 'package:be_elite/bloc/week/week_bloc.dart';
import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/models/Coach/program_dto.dart';
import 'package:be_elite/models/Week/week_dto.dart';
import 'package:be_elite/repositories/coach/coach_repository.dart';
import 'package:be_elite/repositories/coach/coach_repository_impl.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.grey[900]!, Colors.black],
              radius: 0.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircularProfileAvatar(
                          imageUrl: widget.coachDetails.profilePicUrl ??
                              'https://i.imgur.com/jNNT4LE.png'),
                      _programSelectorWidget(),
                      const BeEliteLogo()
                    ]),
              ),
              Expanded(child: _weeksBlocWidget()),
              const SizedBox(height: 10),
              _addWeekButton()
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
      width: MediaQuery.of(context).size.width * 0.75,
      child: SingleChildScrollView(
        child: Column(
          children: weekPage.content!.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0)
                  .copyWith(bottom: 40),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 0.1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                width: 350,
                child: Card(
                  color: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${item.weekName} - Week ${item.id}",
                              style: const TextStyle(fontSize: 20),
                              softWrap: true,),
                          const Divider(color: Colors.white),
                          Text(item.description.toString(),
                              style: TextStyle(
                                color: Colors.grey[400],
                              )),
                          const Divider(color: Colors.white),
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.spaceAround,
                              children: item.sessions!.map((session) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4)
                                          .copyWith(top: 20),
                                  child: SizedBox(
                                    width: 150,
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                          overlayColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey[850])),
                                      child: session.sessionNumber! > 1
                                          ? Text(
                                              "${capitalizeFirstLetter(session.dayOfWeek!)} #${session.sessionNumber}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w100))
                                          : Text(
                                              capitalizeFirstLetter(
                                                  session.dayOfWeek!),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w100)),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _addWeekButton() {
    return SizedBox(
      height: 25,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CoachAddWeekScreen(
                      programName: programName, weeksPage: weekPage, coachDetails: widget.coachDetails)));
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Icon(Icons.add_circle_outline_sharp), Text(' Add new week')],
        ),
      ),
    );
  }
}

String capitalizeFirstLetter(String s) {
  if (s.isEmpty) return s;
  return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
}
