import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/workout.dart';
import '../repository/workout_repository.dart';

class GetWorkouts {
  final WorkoutRepository workoutRepository;

  GetWorkouts(this.workoutRepository);

  Future<Either<Failure, List<Workout>>> call({required String userId}) async {
    return await workoutRepository.getWorkouts(userId: userId);
  }
}
