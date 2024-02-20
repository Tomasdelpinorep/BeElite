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
                    colors: [Colors.grey[800]!, Colors.black],
                    radius: 0.5,
                  ),
                ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("BeElite", style: TextStyle(color: Colors.white)),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(color: Color(0xFFD6CD0B), blurRadius: 15)
                        ]),
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFD6CD0B),
                              fixedSize: const Size(200, 75),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.elliptical(5, 5)))),
                          child: const Text(
                            'Log In',
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
                      const Text(
                        "Don't have a BeElite account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          fixedSize: const Size(200, 75),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          side: const BorderSide(
                            width: 3,
                            color: Colors.grey,
                          ),
                        ),
                        child: const Text(
                          'Sign up',
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
