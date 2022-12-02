part of 'token_bloc.dart';

abstract class TokenEvent extends Equatable {
  const TokenEvent();

  @override
  List<Object> get props => [];
}

class ValidateToken extends TokenEvent {
  final String id;
  final String code;

  const ValidateToken({
    required this.id,
    required this.code,
  });
}
