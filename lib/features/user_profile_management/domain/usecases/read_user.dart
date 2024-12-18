import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user.dart';
import '../repository/user_repository.dart';

class GetUser {
  final UserRepository repository;

  GetUser({required this.repository});

  Future<Either<Failure, User?>> call(String id) async {
    return await repository.getUserById(id);
  }
}
