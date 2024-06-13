import 'package:be_elite/bloc/athlete/athlete_bloc.dart';
import 'package:be_elite/misc/Method_Classes/athletes_screen_methods.dart';
import 'package:be_elite/models/Athlete/athlete_details_dto/athlete_details_dto.dart';
import 'package:be_elite/models/Session/Athlete%20Sessions/athlete_session_dto.dart';
import 'package:be_elite/repositories/athlete/athlete_repository.dart';
import 'package:be_elite/repositories/athlete/athlete_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AthletePastWorkoutsScreen extends StatefulWidget {
  const AthletePastWorkoutsScreen({super.key});

  @override
  State<AthletePastWorkoutsScreen> createState() =>
      _AthletePastWorkoutsScreenState();
}

class _AthletePastWorkoutsScreenState extends State<AthletePastWorkoutsScreen> {
  late AthleteRepository athleteRepository;
  late AthleteBloc _athleteBloc;
  late AthleteDetailsDto athleteDetails;
  List<AthleteSessionDto> previousWorkouts = [];

  AthleteScreenMethods methods = AthleteScreenMethods();
  
  @override
  void initState() {
    athleteRepository = AthleteRepositoryImpl();
    _athleteBloc = AthleteBloc(athleteRepository)..add(GetPreviousWorkoutsEvent());
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
            if (state is GetPreviousWorkoutsSuccessState) {
              previousWorkouts = state.sessionList;
            }
          },
        ),
      ],
    );
  }

  Widget _buildHome(){
    if(previousWorkouts.isEmpty){
      return const Text('got shit');
    }else{
      return const Placeholder();
    }
  }
}
