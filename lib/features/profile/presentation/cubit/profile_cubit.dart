import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../auth/data/models/auth_response_model.dart';
import '../../data/repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required ProfileRepository profileRepository})
      : _repository = profileRepository,
        super(const ProfileInitial());

  final ProfileRepository _repository;

  Future<void> loadProfile() async {
    emit(const ProfileLoading());

    final result = await _repository.getProfile();

    result.fold(
          (failure) => emit(ProfileFailure(message: failure.message)),
          (user) => emit(ProfileLoaded(user: user)),
    );
  }
}