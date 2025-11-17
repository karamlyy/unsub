import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unsub/features/auth/data/models/auth_response_model.dart';
import 'package:unsub/features/auth/data/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthInitial());

  final AuthRepository _authRepository;

  Future<void> checkAuthStatus() async {
    final hasToken = await _authRepository.hasTokens();
    if (hasToken) {
      emit(const Authenticated());
    } else {
      emit(const Unauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());

    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        emit(AuthFailure(message: failure.message));
        emit(const Unauthenticated());
      },
      (payload) {
        emit(AuthSuccess(payload: payload));
        emit(const Authenticated());
      },
    );
  }

  Future<void> register(String name, String email, String password) async {
    emit(const AuthLoading());

    final result = await _authRepository.register(
      name: name,
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        emit(AuthFailure(message: failure.message));
        emit(const Unauthenticated());
      },
      (payload) {
        emit(AuthSuccess(payload: payload));
        emit(const Authenticated());
      },
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(const Unauthenticated());
  }
}
