import 'package:be_elite/bloc/athlete/athlete_bloc.dart';
import 'package:be_elite/misc/Method_Classes/athletes_screen_methods.dart';
import 'package:be_elite/models/Athlete/athlete_details_dto/athlete_details_dto.dart';
import 'package:be_elite/models/Session/Athlete%20Sessions/athlete_session_dto.dart';
import 'package:be_elite/repositories/athlete/athlete_repository.dart';
import 'package:be_elite/repositories/athlete/athlete_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/athlete/workouts/session_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AthleteUpcomingWorkoutsScreen extends StatefulWidget {
  const AthleteUpcomingWorkoutsScreen({super.key});

  @override
  State<AthleteUpcomingWorkoutsScreen> createState() =>
      _AthleteUpcomingWorkoutsScreenState();
}

class _AthleteUpcomingWorkoutsScreenState
    extends State<AthleteUpcomingWorkoutsScreen> {
  late AthleteRepository athleteRepository;
  late AthleteBloc _athleteBloc;
  late AthleteDetailsDto athleteDetails;
  List<AthleteSessionDto> upcomingWorkouts = [];
  List<AthleteSessionDto> previousWorkouts = [];

  AthleteScreenMethods methods = AthleteScreenMethods();

  @override
  void initState() {
    athleteRepository = AthleteRepositoryImpl();
    _athleteBloc = AthleteBloc(athleteRepository)
      ..add(GetAthleteDetailsEvent());
    super.initState();
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _athleteBloc),
        ],
        child: _blocManager(),
      ),
    );
  }

  Widget _blocManager() {
    return Column(
      children: [
        BlocConsumer<AthleteBloc, AthleteState>(
          buildWhen: (context, state) {
            return state is AthleteLoadingState ||
                state is AthleteErrorState ||
                state is GetUpcomingWorkoutsSuccessState;
          },
          builder: (context, state) {
            if (state is AthleteLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AthleteErrorState) {
              return Text(
                  'Error fetching workouts for athlete: ${athleteDetails.username}.');
            } else {
              return _buildHome();
            }
          },
          listener: (context, state) {
            if (state is AthleteDetailsSuccessState) {
              athleteDetails = state.athleteDetails;
              _athleteBloc.add(GetUpcomingWorkoutsEvent());
              _athleteBloc.add(GetPreviousWorkoutsEvent());
            } else if (state is GetUpcomingWorkoutsSuccessState) {
              setState(() {
                upcomingWorkouts = state.sessionList;
              });
            } else if (state is GetPreviousWorkoutsSuccessState) {
              setState(() {
                previousWorkouts = state.sessionList;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildHome() {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                height: 50,
                child: AppBar(
                  bottom: TabBar(
                    indicatorColor: AppColors.mainYellow,
                    labelColor: AppColors.mainYellow,
                    tabs: const [
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Previous'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildUpcomingWorkoutsScreen(),
                  _buildPreviousWorkoutsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutsScreen(List<AthleteSessionDto> workouts) {
    if (workouts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 30),
        child: Align(alignment: Alignment.topCenter,child: Text('Workouts will appear here.', style: TextStyle(color: Colors.white70, fontSize: 28))),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 30),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 75),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AthleteSessionScreen(
                                  athleteSession: workouts[index],
                                  updateSessionList: () {
                                    _athleteBloc
                                        .add(GetUpcomingWorkoutsEvent());
                                  })));
                    },
                    child: Card(
                      elevation: 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.mainYellow,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    workouts[index].title!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  LinearProgressIndicator(
                                    value: workouts[index].blocks!.isNotEmpty
                                        ? methods.getNumberOfBlocksCompleted(
                                                workouts[index].blocks!) /
                                            workouts[index].blocks!.length
                                        : 0,
                                    backgroundColor: Colors.black,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.yellow[900]!),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${methods.getNumberOfBlocksCompleted(workouts[index].blocks!)}/${workouts[index].blocks!.length} workouts completed',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              shrinkWrap: true,
                              itemCount:
                                  (workouts[index].blocks!.length / 2).ceil(),
                              itemBuilder: (context, blockIndex) {
                                final leftIndex = blockIndex * 2;
                                final rightIndex = leftIndex + 1;

                                if (workouts[index].blocks!.isNotEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Wrap(
                                      runSpacing: 8.0,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        leftIndex <
                                                workouts[index].blocks!.length
                                            ? SizedBox(
                                                width: 100,
                                                child: Column(
                                                  children: [
                                                    workouts[index]
                                                            .blocks![leftIndex]
                                                            .isCompleted!
                                                        ? Container(
                                                            width: 20.0,
                                                            height: 20.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .successGreen,
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 0.75),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      2,
                                                                  blurRadius: 7,
                                                                  offset:
                                                                      const Offset(
                                                                          0, 3),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : Container(
                                                            width: 20.0,
                                                            height: 20.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .errorRed,
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 0.75),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      2,
                                                                  blurRadius: 7,
                                                                  offset:
                                                                      const Offset(
                                                                          0, 3),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                    Text(
                                                      workouts[index]
                                                          .blocks![leftIndex]
                                                          .movement!,
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox(),

                                        // If there's another block on the right, put the divider there
                                        // I think +1 should work but it doesn't, +2 works fine though :/
                                        workouts[index].blocks!.length >
                                                blockIndex + 1
                                            ? const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    8, 0, 8, 8),
                                                child: SizedBox(
                                                  height: 40,
                                                  child: VerticalDivider(
                                                    color: Colors.grey,
                                                    thickness: 2.0,
                                                    width: 10.0,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                        rightIndex <
                                                workouts[index].blocks!.length
                                            ? SizedBox(
                                                width: 100,
                                                child: Column(
                                                  children: [
                                                    workouts[index]
                                                            .blocks![rightIndex]
                                                            .isCompleted!
                                                        ? Container(
                                                            width: 20.0,
                                                            height: 20.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .successGreen,
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 0.75),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      2,
                                                                  blurRadius: 7,
                                                                  offset:
                                                                      const Offset(
                                                                          0, 3),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : Container(
                                                            width: 20.0,
                                                            height: 20.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .errorRed,
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 0.75),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      2,
                                                                  blurRadius: 7,
                                                                  offset:
                                                                      const Offset(
                                                                          0, 3),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                    Text(
                                                      workouts[index]
                                                          .blocks![rightIndex]
                                                          .movement!,
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const SizedBox(height: 10);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }

  Widget _buildUpcomingWorkoutsScreen() {
    return _buildWorkoutsScreen(upcomingWorkouts);
  }

  Widget _buildPreviousWorkoutsScreen() {
    return _buildWorkoutsScreen(previousWorkouts);
  }
}
