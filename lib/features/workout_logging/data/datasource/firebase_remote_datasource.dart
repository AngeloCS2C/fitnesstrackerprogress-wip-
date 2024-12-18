import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_progress_trackers/core/errors/exception.dart';
import 'package:fitness_progress_trackers/features/workout_logging/data/datasource/workout_remote_datasource.dart';
import 'package:fitness_progress_trackers/features/workout_logging/domain/entities/workout.dart';

class WorkoutFirebaseDatasource implements WorkoutRemoteDatasource {
  final FirebaseFirestore _firestore;

  WorkoutFirebaseDatasource(this._firestore);

  @override
  Future<void> createWorkout(Workout workout) async {
    try {
      final String userId = workout.userId;
      final String workoutId = workout.id.isEmpty
          ? _firestore.collection('workouts/$userId/items').doc().id
          : workout.id;

      final data = {
        'id': workoutId,
        'exerciseType': workout.exerciseType,
        'duration': workout.duration,
        'intensity': workout.intensity,
        'notes': workout.notes,
        'date': workout.date.toIso8601String(),
        'userId': userId
      };

      await _firestore
          .collection('workouts')
          .doc(userId)
          .collection('items')
          .doc(workoutId)
          .set(data);
    } on FirebaseException catch (e) {
      throw APIException(
        message: e.message ?? "Failed to create workout",
        statusCode: e.code,
      );
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<Workout>> getWorkouts({required String userId}) async {
    try {
      final querySnapshot = await _firestore
          .collection('workouts')
          .doc(userId)
          .collection('items')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Workout(
          id: data['id'] as String,
          exerciseType: data['exerciseType'] as String,
          duration: data['duration'] as int,
          intensity: data['intensity'] as int,
          notes: data['notes'] as String,
          date: DateTime.parse(data['date'] as String),
          userId: data['userId'] as String,
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw APIException(
        message: e.message ?? "Failed to fetch workouts",
        statusCode: e.code,
      );
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> updateWorkout(Workout workout) async {
    try {
      final userId = workout.userId;
      final data = {
        'id': workout.id,
        'exerciseType': workout.exerciseType,
        'duration': workout.duration,
        'intensity': workout.intensity,
        'notes': workout.notes,
        'date': workout.date.toIso8601String(),
        'userId': userId
      };

      await _firestore
          .collection('workouts')
          .doc(userId)
          .collection('items')
          .doc(workout.id)
          .update(data);
    } on FirebaseException catch (e) {
      throw APIException(
        message: e.message ?? "Failed to update workout",
        statusCode: e.code,
      );
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> deleteWorkout(Workout workout) async {
    try {
      final userId = workout.userId;
      await _firestore
          .collection('workouts')
          .doc(userId)
          .collection('items')
          .doc(workout.id)
          .delete();
    } on FirebaseException catch (e) {
      throw APIException(
        message: e.message ?? "Failed to delete workout",
        statusCode: e.code,
      );
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }
}
