import 'dart:convert';
import 'package:fitness_progress_trackers/features/user_profile_management/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.password,
    required super.age,
    required super.gender,
    required super.weight,
    required super.height,
    required super.fitnessGoal,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      password: map['password'] as String,
      age: map['age'] as int,
      gender: map['gender'] as String,
      weight: (map['weight'] as num).toDouble(),
      height: (map['height'] as num).toDouble(),
      fitnessGoal: map['fitnessGoal'] as String,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      password: user.password,
      age: user.age,
      gender: user.gender,
      weight: user.weight,
      height: user.height,
      fitnessGoal: user.fitnessGoal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'fitnessGoal': fitnessGoal,
    };
  }

  String toJson() => json.encode(toMap());
}
