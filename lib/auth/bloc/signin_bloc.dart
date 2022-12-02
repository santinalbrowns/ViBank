import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vibank/models/user.dart';
import 'package:vibank/repo/auth_repo.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc({required this.authRepo}) : super(SigninInitial()) {
    on<SigninEvent>((event, emit) async {
      emit(SigninLoading());

      if (event is RequestSignin) {
        try {
          final user = await authRepo.signin(event.phone, event.country);

          emit(SigninSuccess(user));
        } catch (e) {
          emit(SigninFailed('Something went wrong! ${e.toString()}'));
        }
      }
    });
  }

  final AuthRepo authRepo;
}
