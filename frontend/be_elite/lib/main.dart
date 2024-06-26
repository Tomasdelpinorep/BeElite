import 'package:be_elite/misc/route_observer.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeElite',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.completeBlack,
        brightness: Brightness.dark,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: AppColors.mainYellow.withOpacity(0.25),
            selectedIconTheme: const IconThemeData(color: Colors.white),
            elevation: 5,
            unselectedIconTheme: const IconThemeData(color: Colors.white54),
            selectedLabelStyle: const TextStyle(color: Colors.white),
            unselectedLabelStyle: const TextStyle(color: Colors.white54)),
      ),
      home: const LoginScreen(),
      navigatorObservers: [routeObserver],
    );
  }
}
