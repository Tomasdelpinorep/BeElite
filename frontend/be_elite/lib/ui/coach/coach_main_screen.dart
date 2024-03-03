import 'package:be_elite/bloc/coach_details/coach_details_bloc.dart';
import 'package:be_elite/repositories/user/user_repository.dart';
import 'package:be_elite/repositories/user/user_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/coach/athletes_screen.dart';
import 'package:be_elite/ui/coach/coach_profile_screen.dart';
import 'package:be_elite/ui/coach/programs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachMainScreen extends StatefulWidget {
  const CoachMainScreen({super.key});

  @override
  State<CoachMainScreen> createState() => _CoachMainScreenState();
}

class _CoachMainScreenState extends State<CoachMainScreen> {
  int myIndex = 0;
  late List<Widget> widgetList;
  late CoachDetailsBloc _coachDetailsBloc;
  late UserRepository userRepository;

  @override
  void initState() {
    userRepository = UserRepositoryImpl();
    _coachDetailsBloc = CoachDetailsBloc(userRepository)
      ..add(GetCoachDetailsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: BlocProvider.value(
          value: _coachDetailsBloc,
          child: BlocConsumer<CoachDetailsBloc, CoachDetailsState>(
            buildWhen: (context, state) {
              return state is CoachDetailsLoadingState ||
                  state is CoachDetailsSuccessState ||
                  state is CoachDetailsErrorState;
            },
            builder: (context, state) {
              if (state is CoachDetailsLoadingState) {
                return const Center(child: CircularProgressIndicator());
                
              } else if (state is CoachDetailsErrorState) {
                return const Text('Error getting coach information.');

              } else if (state is CoachDetailsSuccessState) {
                widgetList = [
                  ProgramsScreen(coachDetails: state.coachDetails),
                  const AthletesScreen(),
                  const CoachProfileScreen()
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
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage_rounded),
            label: 'Programs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_martial_arts),
            label: 'Athletes',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
      ),
    );
  }
}
