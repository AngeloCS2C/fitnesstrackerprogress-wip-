import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'user_profile_management_state.dart';

const String noInternetErrorMessage =
    "Sync failed: Changes saved on your device and will sync once you're back online.";

class UserCubit extends Cubit<UserState> {
  final FirebaseAuth _firebaseAuth;

  UserCubit(this._firebaseAuth) : super(UserInitial());

  // Fetch a user by logging in
  Future<void> fetchLogIn(String email, String password) async {
    emit(UserLoading());
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(UserLoaded(userCredential.user!)); // Emit single User object
    } on FirebaseAuthException catch (e) {
      emit(UserError(e.message ?? "An error occurred"));
    } catch (_) {
      emit(const UserError(
          "There seems to be a problem with your internet connection"));
    }
  }

  // Create a new user
  Future<void> createUser(String email, String password, String name) async {
    emit(UserLoading());
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Update display name
      await userCredential.user?.updateDisplayName(name);
      emit(UserCreated());
    } on FirebaseAuthException catch (e) {
      emit(UserError(e.message ?? "An error occurred"));
    } catch (_) {
      emit(const UserError(noInternetErrorMessage));
    }
  }

  // Update an existing user's email
  Future<void> updateUserEmail(String newEmail) async {
    emit(UserLoading());
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.verifyBeforeUpdateEmail(newEmail);
        emit(UserUpdated(user));
      } else {
        emit(const UserError("User not logged in"));
      }
    } on FirebaseAuthException catch (e) {
      emit(UserError(e.message ?? "An error occurred"));
    } catch (_) {
      emit(const UserError(noInternetErrorMessage));
    }
  }

  // Delete a user
  Future<void> deleteUser() async {
    emit(UserLoading());
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.delete();
        emit(UserDeleted());
      } else {
        emit(const UserError("User not logged in"));
      }
    } on FirebaseAuthException catch (e) {
      emit(UserError(e.message ?? "An error occurred"));
    } catch (_) {
      emit(const UserError(noInternetErrorMessage));
    }
  }

  // Logout the user
  Future<void> logOut() async {
    emit(UserLoading());
    try {
      await _firebaseAuth.signOut();
      emit(UserInitial());
    } catch (_) {
      emit(const UserError("Failed to log out. Please try again."));
    }
  }
}
