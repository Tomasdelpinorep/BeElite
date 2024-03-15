import 'package:be_elite/bloc/session/session_bloc.dart';
import 'package:be_elite/models/Week/content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachNewSessionScreen extends StatefulWidget {
  final WeekContent week;
  const CoachNewSessionScreen({super.key, required this.week});

  @override
  State<CoachNewSessionScreen> createState() => _CoachNewSessionScreenState();
}

class _CoachNewSessionScreenState extends State<CoachNewSessionScreen> {
  late SessionBloc _sessionBloc;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.grey[800]!, Colors.grey[900]!],
          radius: 0.5,
        ),
      ),
      child: BlocProvider.value(value: _sessionBloc,
      child: BlocBuilder<SessionBloc, SessionState>(
        buildWhen: (context, state){
          return state is SessionErrorState ||
          state is SessionLoadingState ||
          state is SaveNewSessionSuccessState;
        },
        builder: (context,state){
          if (state is SessionErrorState){
            return const Text('There was an error saving the session.');
          }else if (state is SessionLoadingState){
            return const CircularProgressIndicator();
          }else if(state is SaveNewSessionSuccessState){
            
          }
        },
      ))
    );
  }
}