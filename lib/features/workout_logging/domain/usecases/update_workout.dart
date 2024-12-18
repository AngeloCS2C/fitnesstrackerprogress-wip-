import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/workout.dart';
import '../repository/workout_repository.dart';

class UpdateWorkout {
  final WorkoutRepository workoutRepository;

  UpdateWorkout(this.workoutRepository);

  Future<Either<Failure, void>> call(Workout workout) async {
    return await workoutRepository.updateWorkout(workout);
  }
}
