import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/subscription_model.dart';
import '../../data/repositories/subscriptions_repository.dart';

part 'subscriptions_state.dart';

class SubscriptionsCubit extends Cubit<SubscriptionsState> {
  SubscriptionsCubit({required SubscriptionsRepository subscriptionsRepository})
    : _repository = subscriptionsRepository,
      super(const SubscriptionsInitial());

  final SubscriptionsRepository _repository;

  void reset() {
    emit(const SubscriptionsInitial());
  }

  Future<void> loadSubscriptions() async {
    emit(const SubscriptionsLoading());
    final result = await _repository.fetchSubscriptions();

    result.fold(
      (failure) => emit(SubscriptionsFailure(message: failure.message)),
      (items) => emit(SubscriptionsLoaded(items: items)),
    );
  }

  Future<void> refresh() async {
    await loadSubscriptions();
  }

  Future<void> addSubscription({
    required String name,
    String? category,
    required double price,
    required String currency,
    required String billingCycle,
    required DateTime firstPaymentDate,
    bool isActive = true,
    String? notes,
  }) async {
    final currentState = state;

    final result = await _repository.createSubscription(
      name: name,
      category: category,
      price: price,
      currency: currency,
      billingCycle: billingCycle,
      firstPaymentDate: firstPaymentDate,
      isActive: isActive,
      notes: notes,
    );

    result.fold(
      (failure) => emit(SubscriptionsFailure(message: failure.message)),
      (created) {
        if (currentState is SubscriptionsLoaded) {
          final updatedList = [created, ...currentState.items];
          emit(SubscriptionsLoaded(items: updatedList));
        } else {
          emit(SubscriptionsLoaded(items: [created]));
        }
      },
    );
  }

  Future<void> updateSubscription({
    required int id,
    String? name,
    String? category,
    double? price,
    String? currency,
    String? billingCycle,
    DateTime? firstPaymentDate,
    bool? isActive,
    String? notes,
  }) async {
    final currentState = state;

    final result = await _repository.updateSubscription(
      id: id,
      name: name,
      category: category,
      price: price,
      currency: currency,
      billingCycle: billingCycle,
      firstPaymentDate: firstPaymentDate,
      isActive: isActive,
      notes: notes,
    );

    result.fold(
      (failure) => emit(SubscriptionsFailure(message: failure.message)),
      (updated) {
        if (currentState is SubscriptionsLoaded) {
          final updatedList = currentState.items
              .map((s) => s.id == id ? updated : s)
              .toList();
          emit(SubscriptionsLoaded(items: updatedList));
        } else {
          emit(SubscriptionsLoaded(items: [updated]));
        }
      },
    );
  }

  Future<void> deleteSubscription(int id) async {
    final currentState = state;

    final result = await _repository.deleteSubscription(id);

    result.fold(
      (failure) => emit(SubscriptionsFailure(message: failure.message)),
      (_) {
        if (currentState is SubscriptionsLoaded) {
          final updatedList =
              currentState.items.where((s) => s.id != id).toList();
          emit(SubscriptionsLoaded(items: updatedList));
        } else {
          emit(const SubscriptionsLoaded(items: []));
        }
      },
    );
  }
}
