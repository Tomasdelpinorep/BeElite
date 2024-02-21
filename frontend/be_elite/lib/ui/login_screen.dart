import 'package:be_elite/styles/app_colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final bool isCoach;
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key, required this.isCoach});

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
          child: _loginForm()),
    );
  }

  Widget _loginForm() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _usernameField(),
            const SizedBox(height: 30),
            _passwordField(),
            const SizedBox(height: 30),
            _loginButton(),
          ],
        ));
  }

  Widget _usernameField() {
    return SizedBox(
      width: 400,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: "Username",
            hintStyle: const TextStyle(color: Colors.white54),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54), // Underline color
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white), // Focused underline color
            ),
            prefixIcon: const Icon(Icons.person),
            prefixIconColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.focused)
                    ? Colors.white
                    : Colors.white54)),
        validator: (value) => null,
      ),
    );
  }

  Widget _passwordField() {
    return SizedBox(
      width: 400,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.security),
          prefixIconColor: MaterialStateColor.resolveWith((states) =>
              states.contains(MaterialState.focused)
                  ? Colors.white
                  : Colors.white54),
          hintText: "Password",
          hintStyle: const TextStyle(color: Colors.white54),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54), // Underline color
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.white), // Focused underline color
          ),
        ),
        validator: (value) => null,
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Color(0xFFD6CD0B), blurRadius: 5)]),
      child: FilledButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainYellow,
            fixedSize: const Size(150, 50),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(5, 5)))),
        child: const Text(
          "Login",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}
