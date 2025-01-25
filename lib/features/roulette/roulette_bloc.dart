import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'roulette_event.dart';
part 'roulette_state.dart';

class RouletteBloc extends Bloc<RouletteEvent, RouletteState> {
  RouletteBloc() : super(RouletteInitial()) {
    // on<RouletteEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }
}
