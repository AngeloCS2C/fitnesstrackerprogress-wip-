import 'package:dartz/dartz.dart';
import 'package:fitness_progress_trackers/core/errors/failure.dart';
import 'package:fitness_progress_trackers/features/meals/domain/entities/meals.dart';
import 'package:fitness_progress_trackers/features/meals/domain/repository/meals_repository.dart';

class AddMeal {
  final MealRepository mealRepository;

  AddMeal(this.mealRepository);

  Future<Either<Failure, void>> call(Meal meal) async {
    return await mealRepository.addMeal(meal);
  }
}