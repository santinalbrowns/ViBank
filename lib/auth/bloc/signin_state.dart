part of 'signin_bloc.dart';

abstract class SigninState extends Equatable {
  const SigninState();

  @override
  List<Object> get props => [];
}

class SigninInitial extends SigninState {}

class SigninSuccess extends SigninState {
  final User user;

  const SigninSuccess(this.user);
}

class SigninLoading extends SigninState {}

class SigninFailed extends SigninState {
  final String message;

  const SigninFailed(this.message);
}
