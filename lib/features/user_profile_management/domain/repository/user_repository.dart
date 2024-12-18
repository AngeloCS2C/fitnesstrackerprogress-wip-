import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> signUp(User user);
  Future<Either<Failure, User?>> logIn(String email, String password);
  Future<Either<Failure, User?>> getUserById(String id);
  Future<Either<Failure, void>> updateUser(User user);
  Future<Either<Failure, void>> deleteUser(String id);
}
