import 'package:equatable/equatable.dart';

class Meal extends Equatable {
  final String id;
  final String name;
  final int calories;
  final Map<String, double>
      macros; // {Protein: grams, Carbs: grams, Fat: grams}
  final DateTime dateTime;
  final List<String> tags; // e.g., "Breakfast", "Post-Workout", "Vegetarian"

  const Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.macros,
    required this.dateTime,
    required this.tags,
  });

  @override
  List<Object> get props => [id];
}
