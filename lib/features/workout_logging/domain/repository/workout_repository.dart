import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/workout.dart';

abstract class WorkoutRepository {
  Future<Either<Failure, void>> createWorkout(Workout workout);
  Future<Either<Failure, List<Workout>>> getWorkouts({required String userId});
  Future<Either<Failure, void>> updateWorkout(Workout workout);
  Future<Either<Failure, void>> deleteWorkout(Workout workout);
}
