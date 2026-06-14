import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class WorkoutDetailPage extends StatefulWidget {
  final String workoutId;

  const WorkoutDetailPage({super.key, required this.workoutId});

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  List<Map<String, dynamic>> exercises = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final data = await SupabaseService.getExercises(widget.workoutId);
    setState(() {
      exercises = data;
      loading = false;
    });
  }

  Future<void> _addExercise() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nuovo esercizio"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Nome esercizio"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annulla"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;

              await SupabaseService.addExercise(
                widget.workoutId,
                controller.text.trim(),
              );

              Navigator.pop(context);
              _loadExercises();
            },
            child: const Text("Aggiungi"),
          ),
        ],
      ),
    );
  }

  Future<void> _addSet(String exerciseId) async {
    final repsController = TextEditingController();
    final weightController = TextEditingController();
    final rpeController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nuova serie"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Ripetizioni"),
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Peso (kg)"),
            ),
            TextField(
              controller: rpeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "RPE"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annulla"),
          ),
          ElevatedButton(
            onPressed: () async {
              final reps = int.tryParse(repsController.text) ?? 0;
              final weight = double.tryParse(weightController.text) ?? 0;
              final rpe = double.tryParse(rpeController.text) ?? 0;

              await SupabaseService.addSet(exerciseId, reps, weight, rpe);

              Navigator.pop(context);
              setState(() {}); // refresh
            },
            child: const Text("Aggiungi"),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _loadSets(String exerciseId) async {
    return await SupabaseService.getSets(exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dettaglio Workout"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final ex = exercises[index];

          return ExpansionTile(
            title: Text(ex['name']),
            children: [
              FutureBuilder(
                future: _loadSets(ex['id'].toString()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    );
                  }

                  final sets = snapshot.data!;

                  return Column(
                    children: [
                      for (final s in sets)
                        ListTile(
                          title: Text(
                              "${s['reps']} reps × ${s['weight']} kg"),
                          subtitle: Text("RPE: ${s['rpe']}"),
                        ),
                      TextButton.icon(
                        onPressed: () => _addSet(ex['id'].toString()),
                        icon: const Icon(Icons.add),
                        label: const Text("Aggiungi serie"),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
