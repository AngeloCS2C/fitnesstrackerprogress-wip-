import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: EmptyStateList(
        title: 'Oops...No data available',
        description: "Tap '+' button to add workouts",
      ),
    ),
  ));
}

class EmptyStateList extends StatelessWidget {
  final String title;
  final String description;

  const EmptyStateList({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.folder_off,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(description),
        ],
      ),
    );
  }
}
