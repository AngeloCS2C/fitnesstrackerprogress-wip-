import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_progress_trackers/core/errors/exception.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/data/data_source/user_remote_datasource.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/data/models/user_model.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/domain/entities/user.dart';

class UserFirebaseDatasource implements UserRemoteDatasource {
  final FirebaseFirestore firestore;

  UserFirebaseDatasource(this.firestore);

  @override
  Future<void> deleteUser(String id) async {
    try {
      await firestore.collection('users').doc(id).delete();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occurred',
          statusCode: e.code);
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<User?> getUserById(String id) async {
    try {
      final userDoc = await firestore.collection('users').doc(id).get();
      if (userDoc.exists && userDoc.data() != null) {
        return UserModel.fromMap(userDoc.data()!);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occurred',
          statusCode: e.code);
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<User?> logIn(String email, String password) async {
    try {
      final userQuery = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        return UserModel.fromMap(userDoc.data());
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occurred',
          statusCode: e.code);
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> signUp(User user) async {
    try {
      final userId =
          user.id.isEmpty ? firestore.collection('users').doc().id : user.id;

      final newUser = User(
        id: userId,
        email: user.email,
        name: user.name,
        password: user.password,
        age: user.age,
        gender: user.gender,
        weight: user.weight,
        height: user.height,
        fitnessGoal: user.fitnessGoal,
      );

      final userModel = UserModel.fromEntity(newUser);
      await firestore.collection('users').doc(userId).set(userModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occurred',
          statusCode: e.code);
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> updateUser(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await firestore
          .collection('users')
          .doc(user.id)
          .update(userModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occurred',
          statusCode: e.code);
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }
}
