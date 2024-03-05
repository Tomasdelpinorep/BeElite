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

  @override
  void initState() {
    _coachRepository = CoachRepositoryImpl();
    programName = widget.coachDetails.programs!.first.programName.toString();
    _weekBloc = WeekBloc(_coachRepository)..add(GetWeeksEvent(programName));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
            _weeksBlocWidget()
          ],
        ),
      ),
    );
  }

  Widget _programSelectorWidget() {
    String dropDownValue =
        widget.coachDetails.programs?.first.programName ?? '';
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView.separated(
              itemCount: weekPage.content!.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                    height: 16); // Adjust the height as needed for spacing
              },
              itemBuilder: (context, index) {
                return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mainYellow.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Card(
                      color: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                      "${weekPage.content![index].weekName!} - Week ${weekPage.content![index].id}",
                                      style: const TextStyle(fontSize: 20))
                                ],
                              ),
                              Divider(color: AppColors.mainYellow),
                              Text(weekPage.content![index].description!,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                  )),
                              Divider(color: AppColors.mainYellow),
                              Center(
                                child: Wrap(
                                  alignment: WrapAlignment.spaceAround,
                                  children: weekPage.content![index].sessions!
                                      .map((session) {
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
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w100))
                                              : Text(capitalizeFirstLetter(session.dayOfWeek!),
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w100)),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          )),
                    ));
              },
            ),
          ),
        ),
        _addWeekButton(weekPage)
      ],
    );
  }

  Widget _addWeekButton(weekPage){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CoachAddWeekScreen(programName : programName, weeksPage : weekPage)
        ));
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline_sharp),
          Text(' Add new week')
        ],
      ),
    );
  }
}

String capitalizeFirstLetter(String s) {
  if (s.isEmpty) return s;
  return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
}

