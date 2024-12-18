class Workout {
  final String id;
  final String userId; // Add this field
  final String exerciseType;
  final int duration;
  final int intensity;
  final String notes;
  final DateTime date;

  Workout({
    required this.id,
    required this.userId, // Ensure this is required
    required this.exerciseType,
    required this.duration,
    required this.intensity,
    required this.notes,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'exerciseType': exerciseType,
      'duration': duration,
      'intensity': intensity,
      'notes': notes,
      'date': date.toIso8601String(),
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '', // Parse userId
      exerciseType: map['exerciseType'] ?? '',
      duration: map['duration'] ?? 0,
      intensity: map['intensity'] ?? 0,
      notes: map['notes'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }
}
