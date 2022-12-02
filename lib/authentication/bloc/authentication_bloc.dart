import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vibank/models/user.dart';
import 'package:vibank/repo/auth_repo.dart';
import 'package:vibank/repo/user_repo.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required this.authRepo,
    required this.userRepo,
  }) : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is BootstrapAuthentication) {
        try {
          await authRepo.restore();
        } catch (e) {
          emit(AuthenticationFailed());
        }
      }

      if (event is AuthenticationStatusChanged) {
        try {
          final user = await userRepo.getUser();

          emit(AuthenticationSuccess(status: event.status, user: user));
        } catch (e) {
          emit(AuthenticationFailed());
        }
      }

      if (event is AuthenticationLogoutRequested) {
        try {
          await authRepo.logout();
        } catch (e) {
          emit(AuthenticationError());
        }
      }
    });

    authenticationStatusChanged = authRepo.status.listen((status) {
      add(AuthenticationStatusChanged(status));
    });
  }
  final AuthRepo authRepo;
  final UserRepo userRepo;
  late StreamSubscription<AuthenticationStatus> authenticationStatusChanged;
}
