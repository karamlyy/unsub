part of 'subscriptions_cubit.dart';

abstract class SubscriptionsState extends Equatable {
  const SubscriptionsState();

  @override
  List<Object?> get props => [];
}

class SubscriptionsInitial extends SubscriptionsState {
  const SubscriptionsInitial();
}

class SubscriptionsLoading extends SubscriptionsState {
  const SubscriptionsLoading();
}

class SubscriptionsLoaded extends SubscriptionsState {
  const SubscriptionsLoaded({required this.items});

  final List<SubscriptionModel> items;

  @override
  List<Object?> get props => [items];
}

class SubscriptionsFailure extends SubscriptionsState {
  const SubscriptionsFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}