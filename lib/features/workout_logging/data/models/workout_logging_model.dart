import 'dart:convert';

import 'package:fitness_progress_trackers/features/workout_logging/domain/entities/workout.dart';

class WorkoutModel extends Workout {
  WorkoutModel({
    required super.id,
    required super.exerciseType,
    required super.duration,
    required super.intensity,
    required super.notes,
    required super.date,
    required super.userId,
  });

  // Method to create a WorkoutModel from a Map
  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      id: map['id'],
      exerciseType: map['exerciseType'] as String,
      duration: map['duration'] as int,
      intensity: map['intensity'] as int,
      notes: map['notes'] as String,
      date: DateTime.parse(map['date'] as String),
      userId: '',
    );
  }

  // Method to create a WorkoutModel from a JSON string
  factory WorkoutModel.fromJson(String source) {
    return WorkoutModel.fromMap(json.decode(source) as Map<String, dynamic>);
  }

  // Method to convert WorkoutModel to a Map
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseType': exerciseType,
      'duration': duration,
      'intensity': intensity,
      'notes': notes,
      'date': date.toIso8601String(),
    };
  }

  // Method to convert WorkoutModel to a JSON string
  String toJson() {
    return json.encode(toMap());
  }
}
