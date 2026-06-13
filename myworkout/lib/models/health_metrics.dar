class HealthMetrics {
  final int id;
  final double steps;
  final double calories;
  final double distanceM;
  final double heartRate;
  final DateTime createdAt;

  HealthMetrics({
    required this.id,
    required this.steps,
    required this.calories,
    required this.distanceM,
    required this.heartRate,
    required this.createdAt,
  });

  factory HealthMetrics.fromMap(Map<String, dynamic> map) {
    return HealthMetrics(
      id: map['id'],
      steps: (map['steps'] as num).toDouble(),
      calories: (map['calories'] as num).toDouble(),
      distanceM: (map['distance_m'] as num).toDouble(),
      heartRate: (map['heart_rate'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
