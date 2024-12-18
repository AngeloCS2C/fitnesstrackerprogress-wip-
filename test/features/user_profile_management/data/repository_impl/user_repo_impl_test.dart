import 'package:fitness_progress_trackers/core/errors/failure.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/data/repository_impl/user_repo_impl.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'user_remote_datasource.mock.dart';

void main() {
  late UserRepositoryImplementation repository;
  late MockUserRemoteDatasource mockUserRemoteDatasource;

  setUp(() {
    mockUserRemoteDatasource = MockUserRemoteDatasource();
    repository = UserRepositoryImplementation(mockUserRemoteDatasource,
        remoteDatasource: mockUserRemoteDatasource);
  });

  group('deleteUser', () {
    const String tUserId = 'test_id';

    test('should return Right(void) when deleteUser succeeds', () async {
      // Arrange
      when(() => mockUserRemoteDatasource.deleteUser(tUserId))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.deleteUser(tUserId);

      // Assert
      expect(result, const Right(null));
      verify(() => mockUserRemoteDatasource.deleteUser(tUserId)).called(1);
    });

    test('should return Left(Failure) when deleteUser fails', () async {
      // Arrange
      when(() => mockUserRemoteDatasource.deleteUser(tUserId))
          .thenThrow(Exception('Delete failed'));

      // Act
      final result = await repository.deleteUser(tUserId);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockUserRemoteDatasource.deleteUser(tUserId)).called(1);
    });
  });

  group('getUserById', () {
    const String testUserId = '123';
    const testUser = User(
      id: testUserId,
      email: 'test@example.com',
      name: 'Test User',
      password: 'password123',
      age: 25,
      gender: 'Male',
      weight: 70.0,
      height: 175.0,
      fitnessGoal: 'Lose weight',
    );

    test('should return a User when the call to the data source is successful',
        () async {
      // Arrange
      when(() => mockUserRemoteDatasource.getUserById(testUserId))
          .thenAnswer((_) async => testUser);

      // Act
      final result = await repository.getUserById(testUserId);

      // Assert
      expect(result, const Right(testUser));
      verify(() => mockUserRemoteDatasource.getUserById(testUserId)).called(1);
    });

    test('should return a Failure when the call to the data source fails',
        () async {
      // Arrange
      when(() => mockUserRemoteDatasource.getUserById(testUserId))
          .thenThrow(Exception('Data source error'));

      // Act
      final result = await repository.getUserById(testUserId);

      // Assert
      expect(result.isLeft(), true);
      expect(result, isA<Left<Failure, User?>>());
      verify(() => mockUserRemoteDatasource.getUserById(testUserId)).called(1);
    });
  });
  group('logIn', () {
    const String tEmail = 'test@example.com';
    const String tPassword = 'password123';
    const User tUser = User(
      id: 'test_id',
      email: tEmail,
      name: 'Test User',
      password: tPassword,
      age: 30,
      gender: 'Male',
      weight: 70.0,
      height: 180.0,
      fitnessGoal: 'Lose weight',
    );

    test('should return Right(User) when logIn succeeds', () async {
      // Arrange
      when(() => mockUserRemoteDatasource.logIn(tEmail, tPassword))
          .thenAnswer((_) async => tUser);

      // Act
      final result = await repository.logIn(tEmail, tPassword);

      // Assert
      expect(result, const Right(tUser));
      verify(() => mockUserRemoteDatasource.logIn(tEmail, tPassword)).called(1);
    });

    test('should return Left(Failure) when logIn fails', () async {
      // Arrange
      when(() => mockUserRemoteDatasource.logIn(tEmail, tPassword))
          .thenThrow(Exception('Login failed'));

      // Act
      final result = await repository.logIn(tEmail, tPassword);

      // Assert
      expect(result, isA<Left<Failure, User?>>());
      verify(() => mockUserRemoteDatasource.logIn(tEmail, tPassword)).called(1);
    });
  });
  group('signUp', () {
    const User tUser = User(
      id: 'test_id',
      email: 'test@example.com',
      name: 'Test User',
      password: 'password123',
      age: 30,
      gender: 'Male',
      weight: 70.0,
      height: 180.0,
      fitnessGoal: 'Lose weight',
    );

    test('should return Right(void) when signUp succeeds', () async {
      // Arrange
      when(() => mockUserRemoteDatasource.signUp(tUser))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.signUp(tUser);

      // Assert
      expect(result, const Right(null));
      verify(() => mockUserRemoteDatasource.signUp(tUser)).called(1);
    });

    test('should return Left(Failure) when signUp fails', () async {
      // Arrange
      when(() => mockUserRemoteDatasource.signUp(tUser))
          .thenThrow(Exception('Sign up failed'));

      // Act
      final result = await repository.signUp(tUser);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockUserRemoteDatasource.signUp(tUser)).called(1);
    });
  });
  group('updateUser', () {
    const User tUser = User(
      id: 'test_id',
      email: 'test@example.com',
      name: 'Test User',
      password: 'password123',
      age: 30,
      gender: 'Male',
      weight: 70.0,
      height: 180.0,
      fitnessGoal: 'Lose weight',
    );

    test('should return Right(void) when updateUser succeeds', () async {
      // Arrange
      when(() => mockUserRemoteDatasource.updateUser(tUser))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.updateUser(tUser);

      // Assert
      expect(result, const Right(null));
      verify(() => mockUserRemoteDatasource.updateUser(tUser)).called(1);
    });

    test('should return Left(Failure) when updateUser fails', () async {
      // Arrange
      when(() => mockUserRemoteDatasource.updateUser(tUser))
          .thenThrow(Exception('Update failed'));

      // Act
      final result = await repository.updateUser(tUser);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockUserRemoteDatasource.updateUser(tUser)).called(1);
    });
  });
}
