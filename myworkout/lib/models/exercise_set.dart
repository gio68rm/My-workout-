class ExerciseSet {
  final int id;
  final int exerciseId;
  final double reps;
  final double weight;
  final double rpe;
  final DateTime createdAt;

  ExerciseSet({
    required this.id,
    required this.exerciseId,
    required this.reps,
    required this.weight,
    required this.rpe,
    required this.createdAt,
  });

  factory ExerciseSet.fromMap(Map<String, dynamic> map) {
    return ExerciseSet(
      id: map['id'],
      exerciseId: map['exercise_id'],
      reps: (map['reps'] as num).toDouble(),
      weight: (map['weight'] as num).toDouble(),
      rpe: (map['rpe'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
