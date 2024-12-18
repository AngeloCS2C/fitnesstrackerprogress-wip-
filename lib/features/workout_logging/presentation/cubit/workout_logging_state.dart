part of 'workout_logging_cubit.dart';


abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object> get props => [];
}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutLoaded extends WorkoutState {
  final List<Workout> workouts;

  const WorkoutLoaded(this.workouts);

  @override
  List<Object> get props => [workouts];
}
class WorkoutEmpty extends WorkoutState {
  final String message;

  const WorkoutEmpty(this.message);

  @override
  List<Object> get props => [message];
}

class WorkoutCreated extends WorkoutState{}

class WorkoutUpdated extends WorkoutState{
  final Workout newWorkout;

  const WorkoutUpdated(this.newWorkout);

  @override
  List<Object> get props => [newWorkout];
}

class WorkoutDeleted extends WorkoutState{}



class WorkoutError extends WorkoutState {
  final String message;

  const WorkoutError(this.message);

  @override
  List<Object> get props => [message];
}
