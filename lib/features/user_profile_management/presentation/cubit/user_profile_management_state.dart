part of 'user_profile_management_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user; // Expecting a single User now

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserCreated extends UserState {}

class UserUpdated extends UserState {
  final User user;

  const UserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class UserDeleted extends UserState {}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
