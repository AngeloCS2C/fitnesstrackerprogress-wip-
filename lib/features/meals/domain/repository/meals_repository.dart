import 'package:dartz/dartz.dart';
import 'package:fitness_progress_trackers/core/errors/failure.dart';
import 'package:fitness_progress_trackers/features/meals/domain/entities/meals.dart';

abstract class MealRepository {
  Future<Either<Failure, void>> addMeal(Meal meal);
  Future<Either<Failure, List<Meal>>> getAllMeals();
  Future<Either<Failure, void>> updateMeal(Meal meal);
  Future<Either<Failure, void>> deleteMeal(Meal meal);

}