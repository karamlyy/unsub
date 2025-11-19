import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cancel_help_model.dart';
import '../../data/repositories/ai_repository.dart';

part 'cancel_help_state.dart';

class CancelHelpCubit extends Cubit<CancelHelpState> {
  CancelHelpCubit({required AiRepository repository})
      : _repository = repository,
        super(const CancelHelpInitial());

  final AiRepository _repository;

  Future<void> load({
    required String subscriptionName,
    String? platform,
    String? locale,
  }) async {
    emit(const CancelHelpLoading());

    final result = await _repository.getCancelHelp(
      subscriptionName: subscriptionName,
      platform: platform,
      locale: locale,
    );

    result.fold(
          (failure) => emit(CancelHelpFailure(message: failure.message)),
          (model) => emit(CancelHelpLoaded(model: model)),
    );
  }
}