import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../data_sources/subscriptions_remote_data_source.dart';
import '../models/subscription_model.dart';

class SubscriptionsRepository {
  SubscriptionsRepository({required ApiClient apiClient})
      : _remote = SubscriptionsRemoteDataSource(apiClient: apiClient);

  final SubscriptionsRemoteDataSource _remote;

  Future<Either<Failure, List<SubscriptionModel>>> fetchSubscriptions() async {
    try {
      final res = await _remote.getSubscriptions();
      if (!res.success || res.data == null) {
        return left(ServerFailure(res.message));
      }
      return right(res.data!);
    } on DioException catch (e) {
      return left(mapDioErrorToFailure(e));
    } catch (_) {
      return left(UnexpectedFailure('Subscription-lar yüklənərkən xəta baş verdi'));
    }
  }

  Future<Either<Failure, SubscriptionModel>> createSubscription({
    required String name,
    String? category,
    required double price,
    required String currency,
    required String billingCycle,
    required DateTime firstPaymentDate,
    bool isActive = true,
    String? notes,
  }) async {
    try {
      final res = await _remote.createSubscription(
        name: name,
        category: category,
        price: price,
        currency: currency,
        billingCycle: billingCycle,
        firstPaymentDate: firstPaymentDate,
        isActive: isActive,
        notes: notes,
      );

      if (!res.success || res.data == null) {
        return left(ServerFailure(res.message));
      }

      return right(res.data!);
    } on DioException catch (e) {
      return left(mapDioErrorToFailure(e));
    } catch (_) {
      return left(UnexpectedFailure('Subscription yaradılarkən xəta baş verdi'));
    }
  }

  Future<Either<Failure, SubscriptionModel>> updateSubscription({
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
    try {
      final res = await _remote.updateSubscription(
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

      if (!res.success || res.data == null) {
        return left(ServerFailure(res.message));
      }

      return right(res.data!);
    } on DioException catch (e) {
      return left(mapDioErrorToFailure(e));
    } catch (_) {
      return left(UnexpectedFailure('Subscription yenilənərkən xəta baş verdi'));
    }
  }

  Future<Either<Failure, Unit>> deleteSubscription(int id) async {
    try {
      final res = await _remote.deleteSubscription(id);
      if (!res.success) {
        return left(ServerFailure(res.message));
      }
      return right(unit);
    } on DioException catch (e) {
      return left(mapDioErrorToFailure(e));
    } catch (_) {
      return left(UnexpectedFailure('Subscription silinərkən xəta baş verdi'));
    }
  }
}