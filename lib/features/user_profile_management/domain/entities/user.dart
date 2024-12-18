import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String password;
  final int age;
  final String gender;
  final double weight;
  final double height;
  final String fitnessGoal;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.fitnessGoal,
  });

  @override
  List<Object> get props => [id];

  get length => null;
}
