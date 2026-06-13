class BodyMetrics {
  final int id;
  final double weight;
  final double bodyFat;
  final double muscleMass;
  final DateTime createdAt;

  BodyMetrics({
    required this.id,
    required this.weight,
    required this.bodyFat,
    required this.muscleMass,
    required this.createdAt,
  });

  factory BodyMetrics.fromMap(Map<String, dynamic> map) {
    return BodyMetrics(
      id: map['id'],
      weight: (map['weight'] as num).toDouble(),
      bodyFat: (map['body_fat'] as num).toDouble(),
      muscleMass: (map['muscle_mass'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
