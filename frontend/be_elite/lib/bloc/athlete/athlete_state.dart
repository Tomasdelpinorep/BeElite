part of 'athlete_bloc.dart';

@immutable
sealed class AthleteState {}

final class AthleteInitialState extends AthleteState {}

final class AthleteLoadingState extends AthleteState{}

final class AthleteErrorState extends AthleteState{
  final String errorMessage;
  AthleteErrorState(this.errorMessage);
}

final class GetAthletesByProgramSuccessState extends AthleteState{
  final List<UserDto> athletes;
  GetAthletesByProgramSuccessState(this.athletes);
}

final class GetAthletesByProgramEmptyState extends AthleteState{
  
}
