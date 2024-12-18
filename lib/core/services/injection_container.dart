import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// User Profile Management imports
import 'package:fitness_progress_trackers/features/user_profile_management/data/data_source/firebase_remote_datasource.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/data/data_source/user_remote_datasource.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/data/repository_impl/user_repo_impl.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/domain/repository/user_repository.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/domain/usecases/delete_user.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/domain/usecases/login_user.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/domain/usecases/signup.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/domain/usecases/update_user.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/presentation/cubit/user_profile_management_cubit.dart';

// Workout Logging imports
import 'package:fitness_progress_trackers/features/workout_logging/data/datasource/workout_remote_datasource.dart';
import 'package:fitness_progress_trackers/features/workout_logging/data/datasource/firebase_remote_datasource.dart';
import 'package:fitness_progress_trackers/features/workout_logging/data/repository_impl/workout_repo_impl.dart';
import 'package:fitness_progress_trackers/features/workout_logging/domain/repository/workout_repository.dart';
import 'package:fitness_progress_trackers/features/workout_logging/domain/usecases/create_workout.dart';
import 'package:fitness_progress_trackers/features/workout_logging/domain/usecases/delete_workout.dart';
import 'package:fitness_progress_trackers/features/workout_logging/domain/usecases/read_workout.dart';
import 'package:fitness_progress_trackers/features/workout_logging/domain/usecases/update_workout.dart';
import 'package:fitness_progress_trackers/features/workout_logging/presentation/cubit/workout_logging_cubit.dart';

import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Shared
  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  // User Profile Management
  // Presentation Layer
  serviceLocator.registerFactory(() => UserCubit(firebaseAuth));

  // Domain Layer
  serviceLocator.registerLazySingleton(
      () => SignUp(repository: serviceLocator<UserRepository>()));
  serviceLocator.registerLazySingleton(
      () => LogIn(repository: serviceLocator<UserRepository>()));
  serviceLocator.registerLazySingleton(
      () => UpdateUser(repository: serviceLocator<UserRepository>()));
  serviceLocator.registerLazySingleton(
      () => DeleteUser(repository: serviceLocator<UserRepository>()));

  // Data Layer for User
  serviceLocator.registerLazySingleton<UserRemoteDatasource>(
      () => UserFirebaseDatasource(firestore));
  serviceLocator.registerLazySingleton<UserRepository>(() =>
      UserRepositoryImplementation(serviceLocator<UserRemoteDatasource>(),
          remoteDatasource: UserFirebaseDatasource(firestore)));

  // Workout Logging
  // Presentation Layer
  serviceLocator.registerFactory(() => WorkoutCubit(
        serviceLocator<CreateWorkout>(),
        serviceLocator<DeleteWorkout>(),
        serviceLocator<GetWorkouts>(),
        serviceLocator<UpdateWorkout>(),
      ));

  // Domain Layer for Workouts
  serviceLocator.registerLazySingleton(
      () => CreateWorkout(serviceLocator<WorkoutRepository>()));
  serviceLocator.registerLazySingleton(
      () => DeleteWorkout(serviceLocator<WorkoutRepository>()));
  serviceLocator.registerLazySingleton(
      () => GetWorkouts(serviceLocator<WorkoutRepository>()));
  serviceLocator.registerLazySingleton(
      () => UpdateWorkout(serviceLocator<WorkoutRepository>()));

  // Data Layer for Workouts
  serviceLocator.registerLazySingleton<WorkoutRemoteDatasource>(
      () => WorkoutFirebaseDatasource(firestore));
  serviceLocator.registerLazySingleton<WorkoutRepository>(() =>
      WorkoutRepositoryImplementation(
          serviceLocator<WorkoutRemoteDatasource>()));
}
