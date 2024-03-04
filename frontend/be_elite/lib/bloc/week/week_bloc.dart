import 'dart:async';

import 'package:be_elite/models/Week/week_dto.dart';
import 'package:be_elite/repositories/coach/coach_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'week_event.dart';
part 'week_state.dart';

class WeekBloc extends Bloc<WeekEvent, WeekState> {
  final CoachRepository coachRepository;

  WeekBloc(this.coachRepository) : super(WeekInitial()) {
    on<GetWeeksEvent>(_getWeeks);
  }

  FutureOr<void> _getWeeks(GetWeeksEvent event, Emitter<WeekState> emit) async {
    emit(WeekLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await coachRepository.getWeeks(
          prefs.getString('authToken')!,
          prefs.getString('username')!,
          event.programName);

      emit(WeekSuccessState(response));
    } on Exception catch (e) {
      emit(WeekErrorState(e.toString()));
    }
  }
}
