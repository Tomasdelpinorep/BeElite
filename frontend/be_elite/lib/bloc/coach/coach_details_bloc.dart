import 'dart:async';
import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/models/Coach/user_dto.dart';
import 'package:be_elite/repositories/user/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'coach_details_event.dart';
part 'coach_details_state.dart';

class CoachDetailsBloc extends Bloc<CoachDetailsEvent, CoachDetailsState> {
  final UserRepository userRepository;

  CoachDetailsBloc(this.userRepository) : super(CoachDetailsInitial()) {
    on<GetCoachDetailsEvent>(_getCoachDetails);
    on<GetProfileScreenStatsEvent>(_getProfileScreenStats);
  }

  FutureOr<void> _getCoachDetails(
      GetCoachDetailsEvent event, Emitter<CoachDetailsState> emit) async {
    emit(CoachDetailsLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await userRepository.getCoachDetails(
          prefs.getString('username')!, prefs.getString('authToken')!);

      emit(CoachDetailsSuccessState(response));
    } on Exception catch (e) {
      emit(CoachDetailsErrorState(e.toString()));
    }
  }

  FutureOr<void> _getProfileScreenStats(
      GetProfileScreenStatsEvent event, Emitter<CoachDetailsState> emit) async {
    emit(CoachDetailsLoadingState());

    try {
      final oldestAthlete =
          await userRepository.getOldestAthleteInProgram(event.coachUsername);
      final totalSessionsCompleted = await userRepository
          .getTotalNumberOfSessionsCompleted(event.coachUsername);

      emit(GetProfileStatsSuccessState(oldestAthlete, totalSessionsCompleted));
    } on Exception catch (e) {
      emit(GetProfileStatsErrorState(e.toString()));
    }
  }
}
