import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'coach_event.dart';
part 'coach_state.dart';

class CoachBloc extends Bloc<CoachEvent, CoachState> {
  CoachBloc() : super(CoachInitial()) {
    on<CoachEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
