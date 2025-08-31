import 'package:dartz/dartz.dart';

import 'package:unsub/data/endpoint/auth/login_endpoint.dart';
import 'package:unsub/data/endpoint/auth/register_endpoint.dart';
import 'package:unsub/data/endpoint/auth/me_endpoint.dart';
import 'package:unsub/data/exception/error.dart';
import 'package:unsub/data/model/auth/login_model.dart';
import 'package:unsub/data/model/auth/register_model.dart';
import 'package:unsub/data/model/auth/me_model.dart';
import 'package:unsub/data/service/api/api.dart';


abstract class AuthRepository {
  Future<Either<HttpException, LoginModel>> login(LoginInput input);
  Future<Either<HttpException, RegisterModel>> register(RegisterInput input);
  Future<Either<HttpException, MeModel>> me();
}

class AuthRepositoryImpl extends AuthRepository {
  final ApiService apiService;

  AuthRepositoryImpl(this.apiService);

  @override
  Future<Either<HttpException, LoginModel>> login(LoginInput input) async {
    return await apiService.task<LoginModel>(LoginEndpoint(input));
  }

  @override
  Future<Either<HttpException, RegisterModel>> register(RegisterInput input) async {
    return await apiService.task<RegisterModel>(RegisterEndpoint(input));
  }

  @override
  Future<Either<HttpException, MeModel>> me() async {
    return await apiService.task<MeModel>(MeEndpoint());
  }
}
