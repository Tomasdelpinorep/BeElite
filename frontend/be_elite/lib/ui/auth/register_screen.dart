import 'package:be_elite/bloc/register/register_bloc.dart';
import 'package:be_elite/repositories/auth/auth_repository.dart';
import 'package:be_elite/repositories/auth/auth_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/athlete/athlete_main_screen.dart';
import 'package:be_elite/ui/coach/coach_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  final String userType;

  const RegisterScreen({super.key, required this.userType});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final usernameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final verifyPasswordTextController = TextEditingController();

  late AuthRepository authRepository;
  late RegisterBloc _registerBloc;

  @override
  void initState() {
    authRepository = AuthRepositoryImpl();
    _registerBloc = RegisterBloc(authRepository);
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
            value: _registerBloc,
            child: BlocConsumer<RegisterBloc, RegisterState>(
              buildWhen: (context, state) {
                return state is RegisterLoading ||
                    state is RegisterSuccess ||
                    state is RegisterError;
              },
              builder: (context, state) {
                if (state is RegisterError) {
                  return const Text('An error occured while logging in.');
                } else if (state is RegisterLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return _registerForm();
              },
              listener: (context, state) {
                if (state is RegisterSuccess) {
                  if (widget.userType == "coach") {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            const CoachMainScreen(), // Replace YourPage with your actual page widget
                      ),
                    );
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            const AthleteMainScreen(), // Replace YourPage with your actual page widget
                      ),
                    );
                  }
                }
              },
            ),
          )),
    );
  }

  Widget _registerForm() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _nameField(),
          const SizedBox(height: 30),
          _usernameField(),
          const SizedBox(height: 30),
          _emailField(),
          const SizedBox(height: 30),
          _passwordField(),
          const SizedBox(height: 30),
          _verifyPasswordField(),
          const SizedBox(height: 30),
          _registerButton(),
        ],
      ),
    );
  }

  Widget _nameField() {
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: nameTextController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: "Your name",
            hintStyle: const TextStyle(color: Colors.white54),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54), // Underline color
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white), // Focused underline color
            ),
            prefixIcon: const Icon(Icons.assignment_ind_outlined),
            prefixIconColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.focused)
                    ? Colors.white
                    : Colors.white54)),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Name cannot be empty.';
          }
          return null;
        },
      ),
    );
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

  Widget _emailField() {
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: emailTextController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: "Email",
            hintStyle: const TextStyle(color: Colors.white54),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54), // Underline color
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white), // Focused underline color
            ),
            prefixIcon: const Icon(Icons.mail_outline),
            prefixIconColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.focused)
                    ? Colors.white
                    : Colors.white54)),
        validator: (value) {
          String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
          RegExp regExp = RegExp(pattern);

          if (value == null || value.isEmpty) return 'Email cannot be empty.';

          if (!regExp.hasMatch(value)) {
            return 'Please enter a valid email address.';
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

  Widget _verifyPasswordField() {
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: verifyPasswordTextController,
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
          }

          if (value.length < 6) {
            return 'Password must be at least 6 characters long.';
          }

          if (value.toString() != passwordTextController.text.toString()) {
            return "Passwords don't match";
          }

          return null;
        },
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Color(0xFFD6CD0B), blurRadius: 5)]),
      child: FilledButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            _registerBloc.add(DoRegisterEvent(
                name: nameTextController.text,
                username: usernameTextController.text,
                email: emailTextController.text,
                password: passwordTextController.text,
                verifyPassword: verifyPasswordTextController.text,
                userType: widget.userType));
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainYellow,
            fixedSize: const Size(150, 50),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(5, 5)))),
        child: const Text(
          "Register",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}
