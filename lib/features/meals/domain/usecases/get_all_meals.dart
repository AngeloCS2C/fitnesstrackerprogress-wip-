import 'package:dartz/dartz.dart';
import 'package:fitness_progress_trackers/core/errors/failure.dart';
import 'package:fitness_progress_trackers/features/meals/domain/entities/meals.dart';
import 'package:fitness_progress_trackers/features/meals/domain/repository/meals_repository.dart';

class GetAllMeals {
  final MealRepository mealRepository;

  GetAllMeals(this.mealRepository);

  Future<Either<Failure, List<Meal>>> call() async {
    return await mealRepository.getAllMeals();
  }
}