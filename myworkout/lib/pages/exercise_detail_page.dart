import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'exercise_pr_page.dart';

class ExerciseDetailPage extends StatefulWidget {
  final Map<String, dynamic> exercise;

  const ExerciseDetailPage({super.key, required this.exercise});

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  List<Map<String, dynamic>> sets = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSets();
  }

  Future<void> loadSets() async {
    setState(() => loading = true);

    sets = await SupabaseService.getExerciseSets(widget.exercise['id']);

    setState(() => loading = false);
  }

  void openAddSetModal() {
    final repsController = TextEditingController();
    final weightController = TextEditingController();
    final rpeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Aggiungi Set – ${widget.exercise['name']}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Reps"),
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
              child: const Text("Annulla"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Salva"),
              onPressed: () async {
                final reps = int.tryParse(repsController.text) ?? 0;
                final weight = double.tryParse(weightController.text) ?? 0;
                final rpe = double.tryParse(rpeController.text) ?? 0;

                if (reps > 0 && weight > 0) {
                  await SupabaseService.supabase.from('exercise_sets').insert({
                    'exercise_id': widget.exercise['id'],
                    'reps': reps,
                    'weight': weight,
                    'rpe': rpe,
                  });

                  // aggiorna PR se necessario
                  await SupabaseService.updatePRIfNeeded(
                    widget.exercise['name'],
                    weight,
                  );

                  Navigator.pop(context);
                  loadSets();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.55),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;

    return Scaffold(
      appBar: AppBar(
        title: Text(ex['name']),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExercisePRPage(exercise: ex),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: openAddSetModal,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : sets.isEmpty
              ? const Center(child: Text("Nessun set registrato"))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: sets.length,
                  itemBuilder: (context, index) {
                    final s = sets[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: glassCard(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${s['reps']} reps",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "${s['weight']} kg",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
