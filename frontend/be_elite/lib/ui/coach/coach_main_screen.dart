import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/coach/athletes_screen.dart';
import 'package:be_elite/ui/coach/coach_profile_screen.dart';
import 'package:be_elite/ui/coach/programs_screen.dart';
import 'package:flutter/material.dart';

class CoachMainScreen extends StatefulWidget {
  const CoachMainScreen({super.key});

  @override
  State<CoachMainScreen> createState() => _CoachMainScreenState();
}

class _CoachMainScreenState extends State<CoachMainScreen> {
  int myIndex = 0;
  late List<Widget> widgetList;

  @override
  void initState() {
    super.initState();
    widgetList = [
      ProgramsScreen(coachDetails: coachDetails),
      const AthletesScreen(),
      const CoachProfileScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetList[myIndex],
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
