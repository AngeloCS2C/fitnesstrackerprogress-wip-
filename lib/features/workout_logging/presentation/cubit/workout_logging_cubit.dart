import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/workout.dart';
import '../../domain/usecases/create_workout.dart';
import '../../domain/usecases/delete_workout.dart';
import '../../domain/usecases/read_workout.dart';
import '../../domain/usecases/update_workout.dart';

part 'workout_logging_state.dart';

const String noInternetErrorMessage =
    "Sync failed: Changes saved on your device and will sync once you're back online.";

class WorkoutCubit extends Cubit<WorkoutState> {
  final CreateWorkout createWorkoutUseCase;
  final DeleteWorkout deleteWorkoutUseCase;
  final GetWorkouts getWorkoutsUseCase;
  final UpdateWorkout updateWorkoutUseCase;

  final Logger logger = Logger(); // Logger instance

  WorkoutCubit(
    this.createWorkoutUseCase,
    this.deleteWorkoutUseCase,
    this.getWorkoutsUseCase,
    this.updateWorkoutUseCase,
  ) : super(WorkoutInitial());

  Future<void> getWorkouts({required String userId}) async {
    emit(WorkoutLoading());
    logger.i("Fetching workouts for userId: $userId");

    try {
      final result = await getWorkoutsUseCase.call(userId: userId).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException("Request timed out"),
          );
      result.fold(
        (failure) {
          logger.e("Failed to fetch workouts: ${failure.message}");
          emit(WorkoutError(failure.message));
        },
        (workouts) {
          logger.i("Workouts fetched successfully: ${workouts.length} items");
          emit(WorkoutLoaded(workouts));
        },
      );
    } on TimeoutException catch (_) {
      logger.w("Fetching workouts timed out");
      emit(const WorkoutError("There seems to be a problem"));
    }
  }

  Future<void> createWorkout(Workout workout) async {
    if (workout.userId.isEmpty) {
      logger.e("Workout userId is missing");
      emit(const WorkoutError("User ID is required to create a workout"));
      return;
    }

    emit(WorkoutLoading());
    logger.i("Creating workout for userId: ${workout.userId}");

    try {
      final result = await createWorkoutUseCase(workout).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException("Request Timed Out"),
      );
      result.fold(
        (failure) {
          logger.e("Failed to create workout: ${failure.getMessage()}");
          emit(WorkoutError(failure.getMessage()));
        },
        (_) {
          logger.i("Workout created successfully");
          // Fetch updated workouts after creating
          getWorkouts(userId: workout.userId);
        },
      );
    } on TimeoutException catch (_) {
      logger.w("Creating workout timed out");
      emit(const WorkoutError(noInternetErrorMessage));
    }
  }

  Future<void> updateWorkout(Workout workout) async {
    emit(WorkoutLoading());
    logger.i("Updating workout with ID: ${workout.id}");

    try {
      final result = await updateWorkoutUseCase(workout).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException("Request Timed Out"),
      );
      result.fold(
        (failure) {
          logger.e("Failed to update workout: ${failure.getMessage()}");
          emit(WorkoutError(failure.getMessage()));
        },
        (_) {
          logger.i("Workout updated successfully");
          emit(WorkoutUpdated(workout));
        },
      );
    } on TimeoutException catch (_) {
      logger.w("Updating workout timed out");
      emit(const WorkoutError(noInternetErrorMessage));
    }
  }

  Future<void> deleteWorkout(Workout workout) async {
    if (workout.id.isEmpty) {
      logger.e("Workout ID is missing or invalid");
      emit(const WorkoutError("Workout ID is missing or invalid"));
      return;
    }

    emit(WorkoutLoading());
    logger.i("Attempting to delete workout with ID: ${workout.id}");

    try {
      final result = await deleteWorkoutUseCase(workout).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException("Request Timed Out"),
      );

      result.fold(
        (failure) {
          logger.e("Failed to delete workout: ${failure.getMessage()}");
          emit(WorkoutError(failure.getMessage()));
        },
        (_) {
          logger.i("Workout deleted successfully");
          // Refresh workouts after deletion
          if (workout.userId.isNotEmpty) {
            getWorkouts(userId: workout.userId);
          }
          emit(WorkoutDeleted());
        },
      );
    } on TimeoutException catch (_) {
      logger.w("Deleting workout timed out");
      emit(const WorkoutError(noInternetErrorMessage));
    } catch (e) {
      logger.e("Unexpected error during deletion: $e");
      emit(const WorkoutError("An unexpected error occurred"));
    }
  }
}
