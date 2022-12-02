part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class BootstrapAuth extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final Auth auth;

  const AuthLoginRequested({required this.auth});
}

class AuthLogoutRequested extends AuthEvent {}
