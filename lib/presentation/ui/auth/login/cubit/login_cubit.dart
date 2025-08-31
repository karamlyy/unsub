import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsub/app/generic/generic_state.dart';
import 'package:unsub/app/view/di.dart';
import 'package:unsub/data/endpoint/auth/login_endpoint.dart';
import 'package:unsub/data/exception/error.dart';
import 'package:unsub/data/repository/auth_repository.dart';
import 'package:unsub/data/service/preferences/preferences.dart';

class LoginCubit extends Cubit<GenericState> {
  LoginCubit() : super(Initial());

  final _authRepository = locator.get<AuthRepository>();

  login(LoginInput input) async {
    emit(InProgress());
    final prefs = await PreferencesService.instance;
    final result = await _authRepository.login(input);
    result.fold((l) => emit(Failure(ErrorMessage(message: l.error.message))), (
      r,
    ) {
      prefs.setAuthorizationPassed(true);
      prefs.setAccessToken(r.accessToken ?? "");
      prefs.setRefreshToken(r.refreshToken ?? "");

      emit(Success());
    });
  }
}
