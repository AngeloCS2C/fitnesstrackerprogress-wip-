// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_progress_trackers/features/workout_logging/domain/entities/workout.dart';
import 'package:fitness_progress_trackers/features/workout_logging/presentation/cubit/workout_logging_cubit.dart';
import 'package:intl/intl.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/presentation/auth_page.dart';

class WorkoutPage extends StatefulWidget {
  final String userId;
  final String username; // Pass the username dynamically

  const WorkoutPage({super.key, required this.userId, required this.username});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch workouts after first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.read<WorkoutCubit>().getWorkouts(userId: widget.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkoutCubit, WorkoutState>(
      listener: (context, state) {
        if (state is WorkoutCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Workout created successfully")),
          );
          context.read<WorkoutCubit>().getWorkouts(userId: widget.userId);
        } else if (state is WorkoutUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Workout updated successfully")),
          );
          context.read<WorkoutCubit>().getWorkouts(userId: widget.userId);
        } else if (state is WorkoutDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Workout deleted successfully")),
          );
          context.read<WorkoutCubit>().getWorkouts(userId: widget.userId);
        } else if (state is WorkoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        // Build the workouts page based on the state
        final workoutsPage = _buildBody(context, state);

        // Meals placeholder page
        const mealsPage = Center(child: Text("Meals Placeholder"));

        // Profile page with "Hi username" and a logout button
        final profilePage = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hi ${widget.username}"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _logout(context);
                },
                child: const Text("Logout"),
              ),
            ],
          ),
        );

        // Pages for each tab in the navigation bar
        final pages = [workoutsPage, mealsPage, profilePage];

        return Scaffold(
          appBar: AppBar(
            title: const Text("Workouts"),
          ),
          body: pages[_currentIndex],
          floatingActionButton: _currentIndex == 0
              ? FloatingActionButton(
                  onPressed: () {
                    _showAddOrEditWorkoutModal(context);
                  },
                  child: const Icon(Icons.add),
                )
              : null,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center),
                label: "Workouts",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.track_changes_outlined),
                label: "Meals",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        );
      },
    );
  }

  void _logout(BuildContext context) {
    // Navigate to the authentication page and clear navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => AuthPage(
                onLoginSuccess: () {},
              )),
      (route) => false,
    );
  }

  Widget _buildBody(BuildContext context, WorkoutState state) {
    if (state is WorkoutLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is WorkoutError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<WorkoutCubit>().getWorkouts(userId: widget.userId);
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    } else if (state is WorkoutLoaded) {
      if (state.workouts.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        itemCount: state.workouts.length,
        itemBuilder: (context, index) {
          final workout = state.workouts[index];
          return Card(
            child: ListTile(
              title: Text(workout.exerciseType),
              subtitle: Text(
                  "Duration: ${workout.duration} mins, Intensity: ${workout.intensity}\nNotes: ${workout.notes}\nDate: ${DateFormat.yMMMd().format(workout.date)}"),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showAddOrEditWorkoutModal(context, workout: workout);
                  } else if (value == 'delete') {
                    _confirmDelete(context, workout);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text("Edit"),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text("Delete"),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return _buildEmptyState();
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/oops_empty.png', width: 150, height: 150),
          const SizedBox(height: 16),
          const Text(
            "No Workouts Found",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("Tap '+' to add a workout."),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Workout workout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout'),
        content: const Text('Are you sure you want to delete this workout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              context.read<WorkoutCubit>().deleteWorkout(workout);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddOrEditWorkoutModal(BuildContext context, {Workout? workout}) {
    final exerciseTypeController =
        TextEditingController(text: workout?.exerciseType ?? "");
    final durationController =
        TextEditingController(text: workout?.duration.toString() ?? "");
    final intensityController =
        TextEditingController(text: workout?.intensity.toString() ?? "");
    final notesController = TextEditingController(text: workout?.notes ?? "");
    DateTime selectedDate = workout?.date ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final formKey = GlobalKey<FormState>();
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    workout == null ? "Add Workout" : "Edit Workout",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: exerciseTypeController,
                    decoration: const InputDecoration(
                      labelText: "Exercise Type",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: durationController,
                    decoration: const InputDecoration(
                      labelText: "Duration (mins)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null ||
                          int.parse(value) <= 0) {
                        return "Enter a valid duration";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: intensityController,
                    decoration: const InputDecoration(
                      labelText: "Intensity (1-10)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null) {
                        return "Enter a valid intensity";
                      }
                      final val = int.parse(value);
                      if (val < 1 || val > 10) {
                        return "Intensity must be between 1 and 10";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: "Notes",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text("Date: "),
                      Text(DateFormat.yMMMd().format(selectedDate)),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null && context.mounted) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: const Text("Change Date"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        final exerciseType = exerciseTypeController.text;
                        final duration = int.parse(durationController.text);
                        final intensity = int.parse(intensityController.text);
                        final notes = notesController.text;

                        final newWorkout = Workout(
                          id: workout?.id ?? "",
                          exerciseType: exerciseType,
                          duration: duration,
                          intensity: intensity,
                          notes: notes,
                          date: selectedDate,
                          userId: widget.userId,
                        );

                        if (workout == null) {
                          // Create
                          context
                              .read<WorkoutCubit>()
                              .createWorkout(newWorkout)
                              .then((_) {
                            context
                                .read<WorkoutCubit>()
                                .getWorkouts(userId: widget.userId);
                          });
                        } else {
                          // Update
                          context
                              .read<WorkoutCubit>()
                              .updateWorkout(newWorkout)
                              .then((_) {
                            context
                                .read<WorkoutCubit>()
                                .getWorkouts(userId: widget.userId);
                          });
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: Text(workout == null ? "Add" : "Update"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
