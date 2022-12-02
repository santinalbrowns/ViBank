part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  //final Auth auth;

  //const Authenticated(this.auth);
}

class Unauthenticated extends AuthState {}

class AuthLoading extends AuthState {}
