class Exercise {
  final int id;
  final int workoutId;
  final String name;
  final DateTime createdAt;

  Exercise({
    required this.id,
    required this.workoutId,
    required this.name,
    required this.createdAt,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      workoutId: map['workout_id'],
      name: map['name'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
