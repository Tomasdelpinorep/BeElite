import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.grey[900]!, Colors.black],
                    radius: 0.5,
                  ),
                ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("BeElite v1.0", style: TextStyle(color: Colors.white)),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(color: AppColors.mainYellow, blurRadius: 5)
                        ]),
                        child: FilledButton(
                          onPressed: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const LoginScreen(isCoach:false)));
                          },
                          style: FilledButton.styleFrom(
                              backgroundColor: AppColors.mainYellow,
                              fixedSize: const Size(275, 75),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.elliptical(5, 5)))),
                          child: const Text(
                            "I'm an Athlete",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const LoginScreen(isCoach: true)));
                        },
                        style: OutlinedButton.styleFrom(
                          fixedSize: const Size(275, 75),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          side: const BorderSide(
                            width: 3,
                            color: Colors.grey,
                          ),
                        ),
                        child: const Text(
                          "I'm a Coach",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: RichText(
                            text: const TextSpan(
                          text: "By using BeElite, you agree to BeElite's ",
                          style: TextStyle(color: Colors.grey),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Terms of User ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline)),
                            TextSpan(text: ' and '),
                            TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline)),
                          ],
                        )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
