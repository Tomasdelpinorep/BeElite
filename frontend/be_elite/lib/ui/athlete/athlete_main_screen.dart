import 'package:be_elite/bloc/athlete/athlete_bloc.dart';
import 'package:be_elite/repositories/athlete/athlete_repository.dart';
import 'package:be_elite/repositories/athlete/athlete_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/athlete/profile/athlete_profile_screen.dart';
import 'package:be_elite/ui/athlete/workouts/upcoming_workouts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AthleteMainScreen extends StatefulWidget {
  const AthleteMainScreen({super.key});

  @override
  State<AthleteMainScreen> createState() => _AthleteMainScreenState();
}

class _AthleteMainScreenState extends State<AthleteMainScreen> {
  int myIndex = 0;
  late List<Widget> widgetList;
  late AthleteBloc _athleteBloc;
  late AthleteRepository athleteRepository;

  @override
  void initState() {
    loadIndex();
    athleteRepository = AthleteRepositoryImpl();
    _athleteBloc = AthleteBloc(athleteRepository)
      ..add(GetAthleteDetailsEvent());
    super.initState();
  }

  Future<void> loadIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myIndex = prefs.getInt('index') ?? 0;
    });
  }

  Future<void> _saveDropDownValue(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('index', index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: BlocProvider.value(
          value: _athleteBloc,
          child: BlocConsumer<AthleteBloc, AthleteState>(
            buildWhen: (context, state) {
              return state is AthleteLoadingState ||
                  state is AthleteDetailsSuccessState ||
                  state is AthleteErrorState;
            },
            builder: (context, state) {
              if (state is AthleteLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AthleteErrorState) {
                return const Text('Error getting athlete information.');
              } else if (state is AthleteDetailsSuccessState) {
                widgetList = [
                  const AthleteUpcomingWorkoutsScreen(),
                  AthleteProfileScreen(athleteDetails: state.athleteDetails),
                ];

                return widgetList[myIndex];
              } else {
                return const Placeholder();
              }
            },
            listener: (context, state) {},
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.mainYellow.withOpacity(0.25),
        onTap: (index) {
          _saveDropDownValue(index);
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage_rounded),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
      ),
    );
  }
}
