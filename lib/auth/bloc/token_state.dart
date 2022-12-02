part of 'token_bloc.dart';

abstract class TokenState extends Equatable {
  const TokenState();

  @override
  List<Object> get props => [];
}

class TokenInitial extends TokenState {}

class TokenLoading extends TokenState {}

class ValidToken extends TokenState {}

class TokenError extends TokenState {
  final String message;

  const TokenError(this.message);
}
