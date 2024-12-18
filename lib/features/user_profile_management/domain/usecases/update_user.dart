
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user.dart';
import '../repository/user_repository.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser({required this.repository});

  Future<Either<Failure, void>> call(User user) async {
    return await repository.updateUser(user);
  }
}
