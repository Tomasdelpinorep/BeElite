import 'dart:async';

import 'package:be_elite/models/Coach/coach_details.dart';
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
  }


  FutureOr<void> _getCoachDetails(GetCoachDetailsEvent event, Emitter<CoachDetailsState> emit) async{
    emit(CoachDetailsLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    try{
      final response = await userRepository.getCoachDetails(prefs.getString('username')!, prefs.getString('authToken')!);

      emit(CoachDetailsSuccessState(response));
    }on Exception catch (e){
      emit(CoachDetailsErrorState(e.toString()));
    }
  }
}
