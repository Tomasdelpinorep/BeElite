import 'package:be_elite/bloc/coach/coach_details_bloc.dart';
import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/repositories/user/user_repository.dart';
import 'package:be_elite/repositories/user/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageAccountScreen extends StatefulWidget {
  final CoachDetails coachDetails;
  const ManageAccountScreen({super.key, required this.coachDetails});

  @override
  State<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  late UserRepository programRepository;
  late CoachDetailsBloc _coachBloc;

  @override
  void initState() {
    programRepository = UserRepositoryImpl();
    _coachBloc = CoachDetailsBloc(programRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.grey[800]!, Colors.grey[900]!],
            radius: 0.5,
          ),
        ),
        child: MultiBlocProvider(providers: [
          BlocProvider.value(value: _coachBloc),
        ], child: _blocManager()),
      ),
    );
  }

  Widget _blocManager(){
    return Column(children: [
      BlocConsumer<CoachDetailsBloc, CoachDetailsState>
      (builder: (context, state){
        return _buildHome();
      },
      listener: (context, state){})
    ],);
  }

  Widget _buildHome(){
    return Column();
  }
}