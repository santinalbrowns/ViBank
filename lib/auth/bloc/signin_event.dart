part of 'signin_bloc.dart';

abstract class SigninEvent extends Equatable {
  const SigninEvent();

  @override
  List<Object> get props => [];
}

class RequestSignin extends SigninEvent {
  final String phone;
  final String country;

  const RequestSignin({required this.phone, required this.country});
}
