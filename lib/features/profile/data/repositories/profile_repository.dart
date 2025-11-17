import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/data/models/auth_response_model.dart';
import '../data_sources/profile_remote_data_source.dart';

class ProfileRepository {
  ProfileRepository({required ApiClient apiClient})
      : _remote = ProfileRemoteDataSource(apiClient: apiClient);

  final ProfileRemoteDataSource _remote;

  Future<Either<Failure, UserModel>> getProfile() async {
    try {
      final res = await _remote.getProfile();

      if (!res.success || res.data == null) {
        return left(ServerFailure(res.message));
      }

      return right(res.data!);
    } on DioException catch (e) {
      return left(mapDioErrorToFailure(e));
    } catch (_) {
      return left(
        UnexpectedFailure('Profil məlumatları yüklənərkən xəta baş verdi'),
      );
    }
  }
}