import 'package:dartz/dartz.dart';
import 'package:fitness_progress_trackers/core/errors/failure.dart';
import 'package:fitness_progress_trackers/features/workout_logging/data/repository_impl/workout_repo_impl.dart';
import 'package:fitness_progress_trackers/features/workout_logging/domain/entities/workout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'workout_remote_datasource.mock.dart';

void main() {
  late WorkoutRepositoryImplementation repository;
  late MockWorkoutRemoteDatasource mockWorkoutRemoteDatasource;

  setUp(() {
    mockWorkoutRemoteDatasource = MockWorkoutRemoteDatasource();
    repository = WorkoutRepositoryImplementation(mockWorkoutRemoteDatasource);

    // Register fallback values for Workout
    registerFallbackValue(Workout(
      id: 'dummy',
      exerciseType: 'Dummy',
      duration: 0,
      intensity: 0,
      notes: '',
      date: DateTime.now(),
      userId: '',
    ));
  });

  group('createWorkout', () {
    final Workout tWorkout = Workout(
      id: 'workout_id',
      exerciseType: 'Running',
      duration: 30,
      intensity: 7,
      notes: 'Morning run',
      date: DateTime.now(),
      userId: '',
    );

    test('should return Right(unit) when createWorkout succeeds', () async {
      // Arrange
      when(() => mockWorkoutRemoteDatasource.createWorkout(tWorkout))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.createWorkout(tWorkout);

      // Assert
      expect(result, const Right(unit));
      verify(() => mockWorkoutRemoteDatasource.createWorkout(tWorkout))
          .called(1);
    });

    test('should return Left(Failure) when createWorkout fails', () async {
      // Arrange
      when(() => mockWorkoutRemoteDatasource.createWorkout(tWorkout))
          .thenThrow(Exception('Create workout failed'));

      // Act
      final result = await repository.createWorkout(tWorkout);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockWorkoutRemoteDatasource.createWorkout(tWorkout))
          .called(1);
    });
  });

  group('deleteWorkout', () {
    final Workout tWorkout = Workout(
      id: 'workout_id',
      exerciseType: 'Running',
      duration: 30,
      intensity: 7,
      notes: 'Morning run',
      date: DateTime.now(),
      userId: '',
    );

    test('should return Right(unit) when deleteWorkout succeeds', () async {
      // Arrange
      when(() => mockWorkoutRemoteDatasource.deleteWorkout(tWorkout))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.deleteWorkout(tWorkout);

      // Assert
      expect(result, const Right(unit));
      verify(() => mockWorkoutRemoteDatasource.deleteWorkout(tWorkout))
          .called(1);
    });

    test('should return Left(Failure) when deleteWorkout fails', () async {
      // Arrange
      when(() => mockWorkoutRemoteDatasource.deleteWorkout(tWorkout))
          .thenThrow(Exception('Delete workout failed'));

      // Act
      final result = await repository.deleteWorkout(tWorkout);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockWorkoutRemoteDatasource.deleteWorkout(tWorkout))
          .called(1);
    });
  });

  group('getWorkouts', () {
    final List<Workout> tWorkouts = [
      Workout(
        id: 'workout1',
        exerciseType: 'Running',
        duration: 30,
        intensity: 7,
        notes: 'Morning run',
        date: DateTime.now(),
        userId: '',
      ),
      Workout(
        id: 'workout2',
        exerciseType: 'Swimming',
        duration: 45,
        intensity: 6,
        notes: 'Evening swim',
        date: DateTime.now(),
        userId: '',
      ),
    ];

    test('should return Right(List<Workout>) when getWorkouts succeeds',
        () async {
      // Arrange
      when(() => mockWorkoutRemoteDatasource.getWorkouts(userId: ''))
          .thenAnswer((_) async => tWorkouts);

      // Act
      final result = await repository.getWorkouts(userId: '');

      // Assert
      expect(result, Right(tWorkouts));
      verify(() => mockWorkoutRemoteDatasource.getWorkouts(userId: ''))
          .called(1);
    });

    test('should return Left(Failure) when getWorkouts fails', () async {
      // Arrange
      when(() => mockWorkoutRemoteDatasource.getWorkouts(userId: ''))
          .thenThrow(Exception('Get workouts failed'));

      // Act
      final result = await repository.getWorkouts(userId: '');

      // Assert
      expect(result, isA<Left<Failure, List<Workout>>>());
      verify(() => mockWorkoutRemoteDatasource.getWorkouts(userId: ''))
          .called(1);
    });
  });

  group('updateWorkout', () {
    final Workout tWorkout = Workout(
      id: 'workout_id',
      exerciseType: 'Cycling',
      duration: 40,
      intensity: 8,
      notes: 'Evening cycling session',
      date: DateTime.now(),
      userId: '',
    );

    test('should return Right(unit) when updateWorkout succeeds', () async {
      // Arrange
      when(() => mockWorkoutRemoteDatasource.updateWorkout(tWorkout))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.updateWorkout(tWorkout);

      // Assert
      expect(result, const Right(unit));
      verify(() => mockWorkoutRemoteDatasource.updateWorkout(tWorkout))
          .called(1);
    });

    test('should return Left(Failure) when updateWorkout fails', () async {
      // Arrange
      when(() => mockWorkoutRemoteDatasource.updateWorkout(tWorkout))
          .thenThrow(Exception('Update workout failed'));

      // Act
      final result = await repository.updateWorkout(tWorkout);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockWorkoutRemoteDatasource.updateWorkout(tWorkout))
          .called(1);
    });
  });
}
