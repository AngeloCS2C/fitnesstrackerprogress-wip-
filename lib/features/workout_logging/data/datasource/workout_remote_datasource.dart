import '../../domain/entities/workout.dart';

abstract class WorkoutRemoteDatasource {
  Future<void> createWorkout(Workout workout);
  Future<List<Workout>> getWorkouts({required String userId});
  Future<void> updateWorkout(Workout workout);
  Future<void> deleteWorkout(Workout workout);
}
