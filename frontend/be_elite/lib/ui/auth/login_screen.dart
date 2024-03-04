import 'package:be_elite/bloc/login/login_bloc.dart';
import 'package:be_elite/repositories/auth/auth_repository.dart';
import 'package:be_elite/repositories/auth/auth_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/athlete/athlete_main_screen.dart';
import 'package:be_elite/ui/auth/intro_screen.dart';
import 'package:be_elite/ui/coach/coach_main_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  late AuthRepository authRepository;
  late LoginBloc _loginBloc;

  @override
  void initState() {
    authRepository = AuthRepositoryImpl();
    _loginBloc = LoginBloc(authRepository)..add(CheckTokenEvent());
    super.initState();
  }

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
          child: BlocProvider.value(
            value: _loginBloc,
            child: BlocConsumer<LoginBloc, LoginState>(
              buildWhen: (context, state) {
                return state is DoLoginLoading ||
                    state is DoLoginError ||
                    state is CheckTokenError;
              },
              builder: (context, state) {
                if (state is DoLoginError) {
                  return const Text('An error occured while logging in.');
                } else if (state is DoLoginLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return _loginForm();
              },
              listenWhen: (context, state) {
                return state is DoLoginSuccess || state is CheckTokenSuccess;
              },
              listener: (context, state) {
                if (state is CheckTokenSuccess) {
                  if (state.isValid) {
                    if (state.role!.toUpperCase() == "ROLE_COACH") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CoachMainScreen()));
                    } else if (state.role!.toUpperCase() == "ROLE_ATHLETE") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AthleteMainScreen()));
                    }
                  }
                } else if (state is DoLoginSuccess) {
                  if (state.userLogin.role!.toUpperCase() == "ROLE_ATHLETE") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AthleteMainScreen()));
                  } else if (state.userLogin.role!.toUpperCase() ==
                      "ROLE_COACH") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CoachMainScreen()));
                  }
                }
              },
            ),
          )),
    );
  }

  Widget _loginForm() {
    return Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  _usernameField(),
                  const SizedBox(height: 30),
                  _passwordField(),
                  const SizedBox(height: 30),
                  _loginButton(),
                ])),
            _linkToRegister(),
            const SizedBox(height: 30)
          ],
        ));
  }

  Widget _usernameField() {
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: usernameTextController,
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Username cannot be empty.';
          }
          return null;
        },
      ),
    );
  }

  Widget _passwordField() {
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: passwordTextController,
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password cannot be empty.';
          } else if (value.length < 6) {
            return 'Password must be at least 6 characters long.';
          }
          return null;
        },
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Color(0xFFD6CD0B), blurRadius: 5)]),
      child: FilledButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            _loginBloc.add(DoLoginEvent(
                password: passwordTextController.text,
                username: usernameTextController.text));
          }
        },
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

  Widget _linkToRegister() {
    return RichText(
      text: TextSpan(
        text: "Don't have an account? Sign up ",
        style: const TextStyle(color: Colors.white54),
        children: [
          TextSpan(
            text: 'here.',
            style: const TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.white,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const IntroScreen()));
              },
          ),
        ],
      ),
    );
  }
}
