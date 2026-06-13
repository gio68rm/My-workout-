class Workout {
  final int id;
  final String title;
  final double duration;
  final double volume;
  final double calories;
  final DateTime createdAt;

  Workout({
    required this.id,
    required this.title,
    required this.duration,
    required this.volume,
    required this.calories,
    required this.createdAt,
  });

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      title: map['title'],
      duration: (map['duration_minutes'] as num).toDouble(),
      volume: (map['total_volume'] as num).toDouble(),
      calories: (map['calories'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
