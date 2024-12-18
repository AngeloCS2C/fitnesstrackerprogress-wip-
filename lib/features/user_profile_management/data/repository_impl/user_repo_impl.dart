import 'package:dartz/dartz.dart';
import 'package:fitness_progress_trackers/core/errors/exception.dart';
import 'package:fitness_progress_trackers/core/errors/failure.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/data/data_source/user_remote_datasource.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/domain/entities/user.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/domain/repository/user_repository.dart';

class UserRepositoryImplementation implements UserRepository {
  final UserRemoteDatasource _remoteDatasource;

  const UserRepositoryImplementation(this._remoteDatasource,
      {required Object remoteDatasource});

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      return Right(await _remoteDatasource.deleteUser(id));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getUserById(String id) async {
    try {
      return Right(await _remoteDatasource.getUserById(id));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> logIn(String email, String password) async {
    try {
      return Right(await _remoteDatasource.logIn(email, password));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signUp(User user) async {
    try {
      return Right(await _remoteDatasource.signUp(user));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(User user) async {
    try {
      return Right(await _remoteDatasource.updateUser(user));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }
}
