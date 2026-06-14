import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final supabase = Supabase.instance.client;

  // ---------------------------
  // WORKOUTS
  // ---------------------------
  static Future<List<Map<String, dynamic>>> getWorkouts() async {
    return await supabase
        .from('workouts')
        .select()
        .order('date', ascending: false);
  }

  static Future<List<Map<String, dynamic>>> getExercises(int workoutId) async {
    return await supabase
        .from('exercises')
        .select()
        .eq('workout_id', workoutId)
        .order('id');
  }

  static Future<List<Map<String, dynamic>>> getExerciseSets(int exerciseId) async {
    return await supabase
        .from('exercise_sets')
        .select()
        .eq('exercise_id', exerciseId)
        .order('id');
  }

  // ---------------------------
  // ADD SET + PR AUTOMATICO
  // ---------------------------
  static Future<void> addSet(
      int exerciseId, int reps, double weight, String exerciseName) async {
    await supabase.from('exercise_sets').insert({
      'exercise_id': exerciseId,
      'reps': reps,
      'weight': weight,
    });

    await updatePRIfNeeded(exerciseName, weight);
  }

  // ---------------------------
  // BODY METRICS
  // ---------------------------
  static Future<List<Map<String, dynamic>>> getBodyMetrics() async {
    return await supabase
        .from('body_metrics')
        .select()
        .order('created_at', ascending: false);
  }

  static Future<void> addBodyMetric(double weight) async {
    await supabase.from('body_metrics').insert({
      'weight': weight,
    });
  }

  // ---------------------------
  // PERSONAL RECORDS
  // ---------------------------
  static Future<List<Map<String, dynamic>>> getPersonalRecords() async {
    return await supabase
        .from('personal_records')
        .select()
        .order('weight', ascending: false);
  }

  static Future<void> updatePRIfNeeded(
      String exerciseName, double weight) async {
    final existing = await supabase
        .from('personal_records')
        .select()
        .eq('exercise_name', exerciseName)
        .order('weight', ascending: false)
        .limit(1);

    if (existing.isEmpty) {
      await supabase.from('personal_records').insert({
        'exercise_name': exerciseName,
        'weight': weight,
      });
      return;
    }

    final currentPR = existing.first['weight']?.toDouble() ?? 0;

    if (weight > currentPR) {
      await supabase
          .from('personal_records')
          .update({'weight': weight})
          .eq('exercise_name', exerciseName);
    }
  }
}
