part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final AuthenticationStatus status;
  final User? user;

  const AuthenticationSuccess({required this.status, this.user});
}

class AuthenticationFailed extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {}
