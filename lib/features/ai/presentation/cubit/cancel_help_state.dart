part of 'cancel_help_cubit.dart';

abstract class CancelHelpState extends Equatable {
  const CancelHelpState();

  @override
  List<Object?> get props => [];
}

class CancelHelpInitial extends CancelHelpState {
  const CancelHelpInitial();
}

class CancelHelpLoading extends CancelHelpState {
  const CancelHelpLoading();
}

class CancelHelpLoaded extends CancelHelpState {
  const CancelHelpLoaded({required this.model});

  final CancelHelpModel model;

  @override
  List<Object?> get props => [model];
}

class CancelHelpFailure extends CancelHelpState {
  const CancelHelpFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}