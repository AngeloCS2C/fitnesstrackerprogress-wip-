import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/workout.dart';
import '../repository/workout_repository.dart';

class CreateWorkout {
  final WorkoutRepository workoutRepository;

  CreateWorkout(this.workoutRepository);

  Future<Either<Failure,void>> call(Workout workout) async {
    return await workoutRepository.createWorkout(workout);
  }
}
