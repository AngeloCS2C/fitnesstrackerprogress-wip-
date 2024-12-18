import '../../domain/entities/user.dart';

abstract class UserRemoteDatasource {
  Future<void> signUp(User user);
  Future<User?> logIn(String email, String password);
  Future<User?> getUserById(String id);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String id);
}
