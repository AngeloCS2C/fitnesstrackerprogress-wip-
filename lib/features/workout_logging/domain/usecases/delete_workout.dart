import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_progress_trackers/features/workout_logging/domain/entities/workout.dart';

import '../../../../core/errors/failure.dart';
import '../repository/workout_repository.dart';

class DeleteWorkout {
  final WorkoutRepository workoutRepository;

  DeleteWorkout(this.workoutRepository);

  Future<Either<Failure, void>> call(Workout workout) async {
    // Validate workout ID
    if (workout.id.isEmpty) {
      return const Left(
          GeneralFailure(message: "Workout ID is missing or invalid"));
    }

    try {
      // Call repository to delete workout
      return await workoutRepository.deleteWorkout(workout);
    } on FirebaseException catch (e) {
      return Left(
          APIFailure(message: e.message ?? "API Error", statusCode: e.code));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: "An unexpected error occurred: $e"));
    }
  }
}
