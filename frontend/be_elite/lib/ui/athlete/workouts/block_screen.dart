import 'package:be_elite/bloc/athlete/athlete_bloc.dart';
import 'package:be_elite/misc/Method_Classes/athletes_screen_methods.dart';
import 'package:be_elite/models/Session/Athlete%20Sessions/athlete_session_dto.dart';
import 'package:be_elite/models/Session/Athlete%20Sessions/block.dart';
import 'package:be_elite/repositories/athlete/athlete_repository.dart';
import 'package:be_elite/repositories/athlete/athlete_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AthleteBlockScreen extends StatefulWidget {
  final AthleteBlockDto athleteBlock;
  final AthleteSessionDto athleteSession;
  final VoidCallback updateBlockList;
  final VoidCallback checkIfSessionCompleted;
  const AthleteBlockScreen({super.key, required this.athleteBlock, required this.athleteSession, required this.updateBlockList, required this.checkIfSessionCompleted});

  @override
  State<AthleteBlockScreen> createState() => _AthleteBlocScreeknState();
}

class _AthleteBlocScreeknState extends State<AthleteBlockScreen> {
  late AthleteBloc _athleteBloc;
  late AthleteRepository athleteRepository;

  final TextEditingController _feedbackController = TextEditingController();
  AthleteScreenMethods methods = AthleteScreenMethods();

  @override
  void initState() {
    athleteRepository = AthleteRepositoryImpl();
    _athleteBloc = AthleteBloc(athleteRepository);
    methods.setBlockControllerValues(widget.athleteBlock, _feedbackController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop){
        widget.updateBlockList();
        widget.checkIfSessionCompleted();
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
      ),
    );
  }

  Widget _blocManager() {
    return Column(children: [
      BlocConsumer<AthleteBloc, AthleteState>(
        buildWhen: (context, state) {
          return state is AthleteLoadingState || state is AthleteErrorState;
        },
        builder: (context, state) {
          if (state is AthleteLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AthleteErrorState) {
            return const Text('Error updating athlete block.');
          } else {
            return Expanded(child: _buildHome());
          }
        },
        listener: (context, state) {
          if (state is AthleteBlockSaveSuccessState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Success!',
                        style: TextStyle(color: Colors.white)),
                    content: const Text(
                      'Block has been marked as done.',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppColors.successGreen,
                  );
                },
              );

              Future.delayed(const Duration(milliseconds: 500), () {
                // Closes the dialog
                Navigator.of(context, rootNavigator: true).pop();

                // Pops the current page after a slight delay to ensure the dialog has time to close
                Future.delayed(const Duration(milliseconds: 300), () {
                  Navigator.pop(context);
                });
              });
            });
          }
        },
      ),
    ]);
  }

  Widget _buildHome() {
    return Column(children: [
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
      Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[800],
        child: Row(
          children: [
            Expanded(
                child: Align(
                    alignment: Alignment.center,
                    child: Text('${widget.athleteBlock.movement}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18)))),
          ],
        ),
      ),
      const SizedBox(height: 20),
      // INSTRUCTIONS
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white10),
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            'Instructions',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 5),
          Text('${widget.athleteBlock.instructions}',
              style: TextStyle(fontWeight: FontWeight.w300))
        ]),
      ),

      const SizedBox(height: 20),

      // WORK
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white10),
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            'Work',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 5),
          Wrap(
            children: widget.athleteBlock.sets!.map((set) {
              return FractionallySizedBox(
                widthFactor: 1 / 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                  child: Text(
                    '${set.numberOfSets} * ${set.numberOfReps} | ${set.percentage}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }).toList(),
          ),
        ]),
      ),

      const SizedBox(height: 20),

      // YOUR RESULTS
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white10),
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Results',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 5),
              SingleChildScrollView(
                child: SizedBox(
                  height: 150,
                  child: TextField(
                    controller: _feedbackController,
                    minLines: 4,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your feedback here.',
                    ),
                    maxLines: null, // This makes the TextField a text area
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ),
            ]),
      ),
      const Expanded(child: SizedBox()),
      Container(
        margin: const EdgeInsets.only(bottom: 20),
        width: MediaQuery.of(context).size.width * 0.9,
        child: ElevatedButton(
          onPressed: () {
            widget.athleteBlock.feedback = _feedbackController.text;
            widget.athleteBlock.isCompleted = true;
            _athleteBloc.add(SaveAthleteBlockEvent(widget.athleteBlock));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainYellow,
            disabledBackgroundColor: Colors.amber,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          child: const Text(
            'Mark As Done',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    ]);
  }
}
