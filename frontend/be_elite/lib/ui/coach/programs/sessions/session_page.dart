import 'package:be_elite/bloc/session/session_bloc.dart';
import 'package:be_elite/repositories/session/session_repository.dart';
import 'package:be_elite/repositories/session/session_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachSessionPage extends StatefulWidget {
  final String coachUsername;
  final String weekName;
  final int weekNumber;
  final String programName;
  final int sessionNumber;
  const CoachSessionPage(
      {super.key,
      required this.coachUsername,
      required this.weekName,
      required this.weekNumber,
      required this.programName,
      required this.sessionNumber});

  @override
  State<CoachSessionPage> createState() => _CoachSessionPageState();
}

class _CoachSessionPageState extends State<CoachSessionPage> {
  late SessionBloc _sessionBloc;
  late SessionRepository sessionRepository;

  @override
  void initState() {
    sessionRepository = SessionRepositoryImpl();
    _sessionBloc = SessionBloc(sessionRepository)
      ..add(GetPostSessionDtoEvent(widget.coachUsername, widget.weekName,
          widget.programName, widget.weekNumber, widget.sessionNumber));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.grey[800]!, Colors.grey[900]!],
                radius: 0.5,
              ),
            ),
            child: BlocProvider.value(
                value: _sessionBloc,
                child: BlocBuilder<SessionBloc, SessionState>(
                    buildWhen: (context, state) {
                  return state is SessionErrorState ||
                      state is SessionLoadingState ||
                      state is GetPostSessionDtoSuccessState;
                }, builder: (context, state) {
                  if (state is SessionErrorState) {
                    return const Text(
                        'There was an error fetching session data.');
                  } else if (state is SessionLoadingState) {
                    return const CircularProgressIndicator();
                  } else if (state is GetPostSessionDtoSuccessState) {
                    return SingleChildScrollView(child: _editSessionForm());
                  }
                }))));
  }

  Widget _editSessionForm(){
    
  }
}
