import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vibank/repo/auth_repo.dart';

part 'token_event.dart';
part 'token_state.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  TokenBloc({required this.authRepo}) : super(TokenInitial()) {
    on<TokenEvent>((event, emit) async {
      emit(TokenLoading());

      if (event is ValidateToken) {
        try {
          await authRepo.login(id: event.id, code: event.code);

          emit(ValidToken());
        } catch (e) {
          emit(const TokenError('Invalid activation code:'));
        }
      }
    });
  }

  final AuthRepo authRepo;
}
