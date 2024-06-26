import 'dart:async';
import 'package:be_elite/models/Week/edit_week_dto.dart';
import 'package:be_elite/models/Week/post_week_dto.dart';
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
    on<GetWeekNamesEvent>(_getWeekNames);
    on<GetWeeksEvent>(_getWeeks);
    on<SaveNewWeekEvent>(_saveNewWeek);
    on<SaveEditedWeekEvent>(_saveEditedWeek);
    on<DeleteWeekEvent>(_deleteWeek);
  }

  FutureOr<void> _getWeeks(GetWeeksEvent event, Emitter<WeekState> emit) async {
    emit(WeekLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await coachRepository.getWeeks(
          prefs.getString('authToken')!,
          prefs.getString('username')!,
          event.programName);

      response != null
          ? emit(WeekSuccessState(response))
          : emit(EmptyWeekListState());
    } on Exception catch (e) {
      emit(WeekErrorState(e.toString()));
    }
  }

  FutureOr<void> _getWeekNames(
      GetWeekNamesEvent event, Emitter<WeekState> emit) async {
    emit(WeekLoadingState());

    try {
      final response = await coachRepository.getWeekNames(event.programName);

      emit(WeekNamesSuccessState(response));
    } on Exception catch (e) {
      emit(WeekErrorState(e.toString()));
    }
  }

  FutureOr<void> _saveNewWeek(
      SaveNewWeekEvent event, Emitter<WeekState> emit) async {
    emit(WeekLoadingState());

    try {
      final response = await coachRepository.saveNewWeek(event.newWeek);

      emit(SaveNewWeekSuccessState(response));
    } on Exception catch (e) {
      emit(WeekErrorState(e.toString()));
    }
  }

  FutureOr<void> _saveEditedWeek(
      SaveEditedWeekEvent event, Emitter<WeekState> emit) async {
    emit(WeekLoadingState());

    try {
      final response = await coachRepository.saveEditedWeek(event.editedWeek);

      emit(SaveNewWeekSuccessState(response));
    } on Exception catch (e) {
      emit(WeekErrorState(e.toString()));
    }
  }

  FutureOr<void> _deleteWeek(
      DeleteWeekEvent event, Emitter<WeekState> emit) async {
    emit(WeekLoadingState());

    try {
      await coachRepository.deleteWeek(event.coachUsername, event.programName,
          event.weekName, event.weekNumber);
      emit(DeleteWeekSuccessState());
    } on Exception catch (e) {
      emit(WeekErrorState(e.toString()));
    }
  }
}
