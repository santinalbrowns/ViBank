import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vibank/auth/models/auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthLoginRequested) {
        try {
          //final
        } catch (e) {
          emit(Unauthenticated());
        }
      }
    });
  }
}
