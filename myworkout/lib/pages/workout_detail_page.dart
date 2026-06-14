import 'package:flutter/material.dart';
import 'package:myworkout/services/supabase_service.dart';

class WorkoutDetailPage extends StatefulWidget {
  final String workoutId;

  const WorkoutDetailPage({super.key, required this.workoutId});

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  late final int workoutId;
  List<Map<String, dynamic>> exercises = [];
  Map<int, List<Map<String, dynamic>>> setsByExercise = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    workoutId = int.parse(widget.workoutId);
    _loadAll();
  }

  Future<void> _loadAll() async {
    loading = true;
    setState(() {});

    final ex = await SupabaseService.getExercises(workoutId);

    // Carico tutti i set in un'unica query
    final allSets = await SupabaseService.getAllSetsForWorkout(workoutId);

    // Raggruppo i set per exercise_id
    final grouped = <int, List<Map<String, dynamic>>>{};
    for (var s in allSets) {
      final id = s['exercise_id'] as int;
      grouped.putIfAbsent(id, () => []);
      grouped[id]!.add(s);
    }

    setState(() {
      exercises = ex;
      setsByExercise = grouped;
      loading = false;
    });
  }

  Future<void> _addExercise(String name) async {
    await SupabaseService.addExercise(workoutId, name);
    _loadAll();
  }

  Future<void> _addSet(int exerciseId, int reps, double weight, double rpe) async {
    await SupabaseService.addSet(exerciseId, reps, weight, rpe);
    _loadAll();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Dettaglio Workout")),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final ex = exercises[index];
          final exId = ex['id'] as int;
          final sets = setsByExercise[exId] ?? [];

          return ListTile(
            title: Text(ex['name']),
            subtitle: Text("Serie: ${sets.length}"),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _addSet(exId, 10, 20.0, 7.0);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addExercise("Nuovo esercizio"),
        child: const Icon(Icons.add),
      ),
    );
  }
}
