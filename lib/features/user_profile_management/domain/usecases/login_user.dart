import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user.dart';
import '../repository/user_repository.dart';

class LogIn {
  final UserRepository repository;

  LogIn({required this.repository});

 Future<Either<Failure, User?>> call(String email, String password) async {
    return await repository.logIn(email, password);
  }
}