// ignore_for_file: void_checks

import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/failure.dart';
import 'package:fitness_progress_trackers/features/workout_logging/domain/entities/workout.dart';
import '../datasource/workout_remote_datasource.dart';
import 'package:fitness_progress_trackers/features/workout_logging/domain/repository/workout_repository.dart';

class WorkoutRepositoryImplementation implements WorkoutRepository {
  final WorkoutRemoteDatasource remoteDatasource;

  WorkoutRepositoryImplementation(this.remoteDatasource);

  @override
  Future<Either<Failure, void>> createWorkout(Workout workout) async {
    try {
      await remoteDatasource.createWorkout(workout);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Workout>>> getWorkouts(
      {required String userId}) async {
    try {
      final workouts = await remoteDatasource.getWorkouts(userId: userId);
      return Right(workouts);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateWorkout(Workout workout) async {
    try {
      await remoteDatasource.updateWorkout(workout);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWorkout(Workout workout) async {
    try {
      await remoteDatasource.deleteWorkout(workout);
      return const Right(unit); // Success
    } on FirebaseException catch (e) {
      return Left(APIFailure(
          message: e.message ?? "Failed to delete workout",
          statusCode: e.code));
    } catch (e) {
      return Left(GeneralFailure(message: "Unexpected error: $e"));
    }
  }
}
