import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/presentation/cubit/user_profile_management_cubit.dart';
import 'package:fitness_progress_trackers/features/workout_logging/presentation/workout_page.dart';

class AuthPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const AuthPage({super.key, required this.onLoginSuccess});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSignUp = false;
  String _name = "";

  void _navigateToWorkoutPage(BuildContext context, String userId) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => WorkoutPage(
          userId: userId,
          username: '',
        ), // Pass userId
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignUp ? 'Sign Up' : 'Log In'),
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            _navigateToWorkoutPage(context, state.user.uid);
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isSignUp)
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      onChanged: (value) => _name = value,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter your name'
                          : null,
                    ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) => value == null || !value.contains('@')
                        ? 'Enter a valid email'
                        : null,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) => value == null || value.length < 6
                        ? 'Password too short'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (_isSignUp) {
                          context.read<UserCubit>().createUser(
                                _emailController.text,
                                _passwordController.text,
                                _name,
                              );
                        } else {
                          context.read<UserCubit>().fetchLogIn(
                                _emailController.text,
                                _passwordController.text,
                              );
                        }
                      }
                    },
                    child: Text(_isSignUp ? 'Sign Up' : 'Log In'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isSignUp = !_isSignUp;
                      });
                    },
                    child: Text(
                      _isSignUp
                          ? 'Already have an account? Log In'
                          : 'Don\'t have an account? Sign Up',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
