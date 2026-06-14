import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_config.dart';

class SupabaseService {
  static SupabaseClient get client => SupabaseConfig.client;

  // -----------------------------
  // BODY METRICS
  // -----------------------------

  static Future<Map<String, dynamic>?> getLatestBodyMetric() async {
    return await client
        .from('body_metrics')
        .select()
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
  }

  static Future<List<Map<String, dynamic>>> getBodyMetrics() async {
    return await client
        .from('body_metrics')
        .select()
        .order('created_at', ascending: false);
  }

  static Future<void> addBodyMetric(Map<String, dynamic> data) async {
    await client.from('body_metrics').insert(data);
  }

  static Future<List<Map<String, dynamic>>> getWeightHistory() async {
    return await client
        .from('body_metrics')
        .select('weight, created_at')
        .order('created_at');
  }

  static Future<List<Map<String, dynamic>>> getBodyFatHistory() async {
    return await client
        .from('body_metrics')
        .select('body_fat, created_at')
        .order('created_at');
  }

  // -----------------------------
  // WORKOUTS
  // -----------------------------

  static Future<List<Map<String, dynamic>>> getWorkouts() async {
    return await client
        .from('workouts')
        .select()
        .order('created_at', ascending: false);
  }

  static Future<int> createWorkout(String name, String notes) async {
    final response = await client
        .from('workouts')
        .insert({'name': name, 'notes': notes})
        .select()
        .single();

    return response['id'];
  }

  // -----------------------------
  // EXERCISES
  // -----------------------------

  static Future<List<Map<String, dynamic>>> getExercises(int workoutId) async {
    return await client
        .from('exercises')
        .select()
        .eq('workout_id', workoutId)
        .order('created_at');
  }

  static Future<void> addExercise(int workoutId, String name) async {
    await client.from('exercises').insert({
      'workout_id': workoutId,
      'name': name,
    });
  }

  // -----------------------------
  // SETS
  // -----------------------------

  static Future<List<Map<String, dynamic>>> getSets(int exerciseId) async {
    return await client
        .from('sets')
        .select()
        .eq('exercise_id', exerciseId)
        .order('created_at');
  }

  static Future<void> addSet(
      int exerciseId, int reps, double weight, double rpe) async {
    await client.from('sets').insert({
      'exercise_id': exerciseId,
      'reps': reps,
      'weight': weight,
      'rpe': rpe,
    });
  }

  // VERSIONE OTTIMIZZATA
  static Future<List<Map<String, dynamic>>> getAllSetsForWorkout(
      int workoutId) async {
    final exerciseIds = await client
        .from('exercises')
        .select('id')
        .eq('workout_id', workoutId);

    if (exerciseIds.isEmpty) return [];

    final ids = exerciseIds.map((e) => e['id']).toList();

    return await client
        .from('sets')
        .select()
        .inFilter('exercise_id', ids)
        .order('created_at');
  }

  // -----------------------------
  // PROGRESS / PR
  // -----------------------------

  static Future<List<Map<String, dynamic>>> getExerciseProgress(int id) async {
    return await client
        .from('sets')
        .select('weight, reps, created_at')
        .eq('exercise_id', id)
        .order('created_at');
  }

  static Future<List<Map<String, dynamic>>> getPersonalRecords() async {
    return await client.rpc('get_personal_records');
  }

  // -----------------------------
  // HEALTH SYNC
  // -----------------------------

  static Future<void> insertHealthMetrics(Map<String, dynamic> data) async {
    await client.from('health_metrics').insert(data);
  }
}
