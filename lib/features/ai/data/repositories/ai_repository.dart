import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../data_sources/ai_remote_data_source.dart';
import '../models/cancel_help_model.dart';

class AiRepository {
  AiRepository({required ApiClient apiClient})
    : _remote = AiRemoteDataSource(apiClient: apiClient);

  final AiRemoteDataSource _remote;

  Future<Either<Failure, CancelHelpModel>> getCancelHelp({
    required String subscriptionName,
    String? platform,
    String? locale,
  }) async {
    try {
      final res = await _remote.getCancelHelp(
        subscriptionName: subscriptionName,
        platform: platform,
        locale: locale,
      );

      if (!res.success || res.data == null) {
        return left(ServerFailure(res.message));
      }

      return right(res.data!);
    } on DioException catch (e) {
      return left(mapDioErrorToFailure(e));
    } catch (_) {
      return left(
        UnexpectedFailure('Ləğv etmə təlimatı alınarkən xəta baş verdi'),
      );
    }
  }
}
