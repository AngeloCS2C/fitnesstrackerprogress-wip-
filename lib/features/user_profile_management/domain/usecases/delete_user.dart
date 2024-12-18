import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repository/user_repository.dart';

class DeleteUser {
  final UserRepository repository;

  DeleteUser({required this.repository});

  Future<Either< Failure, void>> call(String id) async {
    return await repository.deleteUser(id);
  }
}
