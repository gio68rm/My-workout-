import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_config.dart';

class SupabaseService {
  static final SupabaseClient _client = SupabaseConfig.client;

  // ------------------------------------------------------------
  // 📌 BODY METRICS
  // ------------------------------------------------------------

  // 🔹 Aggiunge un nuovo record di metriche corporee
  static Future<void> addBodyMetric(Map<String, dynamic> data) async {
    await _client.from('body_metrics').insert({
      'weight': data['weight'],
      'body_fat': data['body_fat'],
      'muscle_mass': data['muscle_mass'],
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // 🔹 Ultimo record (per dashboard e profilo)
  static Future<Map<String, dynamic>?> getLatestBodyMetric() async {
    final response = await _client
        .from('body_metrics')
        .select()
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    return response;
  }

  // 🔹 Storico completo (non usato ma utile)
  static Future<List<Map<String, dynamic>>> getBodyMetrics() async {
    final response = await _client
        .from('body_metrics')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // 🔹 Storico peso (per advanced_stats_page)
  static Future<List<double>> getWeightHistory() async {
    final response = await _client
        .from('body_metrics')
        .select('weight')
        .order('created_at', ascending: true);

    return response
        .map<double>((row) => (row['weight'] as num).toDouble())
        .toList();
  }

  // 🔹 Storico body fat (per advanced_stats_page)
  static Future<List<double>> getBodyFatHistory() async {
    final response = await _client
        .from('body_metrics')
        .select('body_fat')
        .order('created_at', ascending: true);

    return response
        .map<double>((row) => (row['body_fat'] as num).toDouble())
        .toList();
  }

  // 🔹 Record precedente (per progressi giornalieri)
  static Future<Map<String, dynamic>> getDailyMetrics() async {
    final response = await _client
        .from('body_metrics')
        .select()
        .order('created_at', ascending: false)
        .limit(2);

    if (response.isEmpty) {
      return {
        'prev_weight': 0.0,
        'prev_body_fat': 0.0,
        'prev_muscle_mass': 0.0,
      };
    }

    final latest = response.first;
    final prev = response.length > 1 ? response[1] : latest;

    return {
      'prev_weight': (prev['weight'] ?? 0).toDouble(),
      'prev_body_fat': (prev['body_fat'] ?? 0).toDouble(),
      'prev_muscle_mass': (prev['muscle_mass'] ?? 0).toDouble(),
    };
  }

  // ------------------------------------------------------------
  // 📌 HEALTH METRICS (Health Sync)
  // ------------------------------------------------------------

  static Future<void> insertHealthMetrics({
    required int steps,
    required double activeEnergy,
    required double distance,
    required double heartRate,
  }) async {
    await _client.from('health_metrics').insert({
      'steps': steps,
      'active_energy': activeEnergy,
      'distance': distance,
      'heart_rate': heartRate,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // ------------------------------------------------------------
  // 📌 WORKOUTS CRUD
  // ------------------------------------------------------------

  static Future<String?> createWorkout(String name, String notes) async {
    final response = await _client.from('workouts').insert({
      'name': name,
      'notes': notes,
      'date': DateTime.now().toIso8601String(),
    }).select('id').single();

    return response['id'];
  }

  static Future<String?> addExercise(String workoutId, String name) async {
    final response = await _client.from('exercises').insert({
      'workout_id': workoutId,
      'name': name,
      'created_at': DateTime.now().toIso8601String(),
    }).select('id').single();

    return response['id'];
  }

  static Future<void> addSet(
      String exerciseId, int reps, double weight, double rpe) async {
    await _client.from('exercise_sets').insert({
      'exercise_id': exerciseId,
      'reps': reps,
      'weight': weight,
      'rpe': rpe,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> getWorkouts() async {
    return await _client
        .from('workouts')
        .select()
        .order('date', ascending: false);
  }

  static Future<List<Map<String, dynamic>>> getExercises(String workoutId) async {
    return await _client
        .from('exercises')
        .select()
        .eq('workout_id', workoutId)
        .order('created_at', ascending: true);
  }

  static Future<List<Map<String, dynamic>>> getSets(String exerciseId) async {
    return await _client
        .from('exercise_sets')
        .select()
        .eq('exercise_id', exerciseId)
        .order('created_at', ascending: true);
  }

  static Future<double> getWorkoutTotalVolume(String workoutId) async {
    final exercises = await _client
        .from('exercises')
        .select('id')
        .eq('workout_id', workoutId);

    double total = 0;

    for (final ex in exercises) {
      final sets = await _client
          .from('exercise_sets')
          .select('reps, weight')
          .eq('exercise_id', ex['id']);

      for (final s in sets) {
        total += (s['reps'] as num) * (s['weight'] as num);
      }
    }

    return total;
  }

  static Future<List<Map<String, dynamic>>> getPersonalRecords() async {
    final response = await _client.rpc('get_personal_records');
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<List<Map<String, dynamic>>> getExerciseProgress(
      int exerciseId) async {
    final response = await _client.rpc('get_exercise_progress', params: {
      'ex_id': exerciseId,
    });

    return List<Map<String, dynamic>>.from(response);
  }

  static Future<List<Map<String, dynamic>>> getLastWorkouts() async {
    return await _client
        .from('workouts')
        .select()
        .order('date', ascending: false)
        .limit(3);
  }

  static Future<double> getGlobalMaxWeight() async {
    final response = await _client
        .from('exercise_sets')
        .select('weight')
        .order('weight', ascending: false)
        .limit(1)
        .maybeSingle();

    return response != null ? (response['weight'] as num).toDouble() : 0;
  }
}
