
import 'package:be_elite/repositories/auth/auth_repository.dart';
import 'package:be_elite/repositories/auth/auth_repository_impl.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final bool isCoach;

  const RegisterScreen({super.key, required this.isCoach});

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
  void initState(){
    authRepository = AuthRepositoryImpl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text('This is the register page'),
    );
  }
}

class RegisterBloc {
}