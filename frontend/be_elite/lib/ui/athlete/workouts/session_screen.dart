import 'package:be_elite/bloc/athlete/athlete_bloc.dart';
import 'package:be_elite/misc/Method_Classes/athletes_screen_methods.dart';
import 'package:be_elite/models/Session/Athlete%20Sessions/athlete_session_dto.dart';
import 'package:be_elite/repositories/athlete/athlete_repository.dart';
import 'package:be_elite/repositories/athlete/athlete_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/athlete/workouts/block_screen.dart';
import 'package:be_elite/ui/athlete/workouts/upcoming_workouts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class AthleteSessionScreen extends StatefulWidget {
  AthleteSessionDto athleteSession;
  final VoidCallback updateSessionList;
  AthleteSessionScreen(
      {super.key,
      required this.athleteSession,
      required this.updateSessionList});

  @override
  State<AthleteSessionScreen> createState() => AthleteSessionScreenState();
}

class AthleteSessionScreenState extends State<AthleteSessionScreen> {
  late AthleteBloc _athleteBloc;
  late AthleteRepository athleteRepository;

  AthleteScreenMethods methods = AthleteScreenMethods();
  int completedBlocks = 0;

  @override
  void initState() {
    athleteRepository = AthleteRepositoryImpl();
    _athleteBloc = AthleteBloc(athleteRepository)
      ..add(UpdateAthleteSessionEvent(widget.athleteSession.sessionId!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // callback updates the sessionList in previous page so blocks appear as done/undone correctly
    return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          widget.updateSessionList();
        },
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.grey[800]!, Colors.grey[900]!],
                radius: 0.5,
              ),
            ),
            child: MultiBlocProvider(providers: [
              BlocProvider.value(value: _athleteBloc),
            ], child: _blocManager()),
          ),
        ));
  }

  Widget _blocManager() {
    return Column(children: [
      BlocConsumer<AthleteBloc, AthleteState>(
        builder: (context, state) {
          if (state is AthleteLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AthleteErrorState) {
            return Text(state.errorMessage);
          } else if (state is AthleteBlockSaveSuccessState) {
            return Expanded(child: _buildHome());
          } else {
            return Expanded(child: _buildHome());
          }
        },
        listener: (context, state) {
          if (state is UpdateAthleteSessionSuccessState) {
            widget.athleteSession = state.session!;
          }
        },
      ),
    ]);
  }

  Widget _buildHome() {
    return Column(
      children: [
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          color: Colors.black26,
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('${widget.athleteSession.date}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w200, fontSize: 18)),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text('${widget.athleteSession.title}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 30),
            itemCount: widget.athleteSession.blocks!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 75),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AthleteBlockScreen(
                                athleteBlock:
                                    widget.athleteSession.blocks![index],
                                athleteSession: widget.athleteSession,
                                updateBlockList: () {
                                  _athleteBloc.add(UpdateAthleteSessionEvent(
                                      widget.athleteSession.sessionId!));
                                },
                                checkIfSessionCompleted: checkIfSessionCompleted)));
                  },
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        Container(
                          width: 1000,
                          decoration: BoxDecoration(
                            color: AppColors.mainYellow,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[800],
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                              methods.getBlockLetter(index),
                                              style: const TextStyle(
                                                  fontSize: 28)),
                                        ),
                                        Text(
                                          widget.athleteSession.blocks![index]
                                              .movement!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            widget.athleteSession.blocks![index]
                                                .instructions!,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _athleteBloc.add(ChangeBlockDoneStatusEvent(
                                      widget.athleteSession.blocks![index]));
                                },
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: widget.athleteSession.blocks![index]
                                            .isCompleted!
                                        ? AppColors.successGreen
                                        : AppColors.errorRed,
                                  ),
                                  padding: const EdgeInsets.all(1),
                                  child: Icon(
                                    widget.athleteSession.blocks![index]
                                            .isCompleted!
                                        ? Icons.check
                                        : Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            children: widget.athleteSession.blocks![index].sets!
                                .map((set) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        '${set.numberOfSets} x ${set.numberOfReps} | ${set.percentage}%',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                              'Rest: ${widget.athleteSession.blocks![index].rest}"',
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 16)),
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

  checkIfSessionCompleted() {
    completedBlocks = 0;
    widget.athleteSession.blocks!.forEach((block) {
      if (block.isCompleted!) completedBlocks++;
    });

    if (completedBlocks == widget.athleteSession.blocks!.length) {
      widget.athleteSession.isCompleted = true;
      _athleteBloc.add(CompleteSessionEvent(widget.athleteSession.sessionId!));

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // Show dialog
            return AlertDialog(
              title: const Text('Congrats!',
                  style: TextStyle(color: Colors.white)),
              content: const Text('You have completed this session.',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: AppColors.successGreen,
            );
          },
        );

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AthleteUpcomingWorkoutsScreen()),
          );
        });
      });
    }
  }
}
