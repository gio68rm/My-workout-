import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'exercise_detail_page.dart';

class WorkoutDetailPage extends StatefulWidget {
  final Map<String, dynamic> workout;

  const WorkoutDetailPage({super.key, required this.workout});

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  List<Map<String, dynamic>> exercises = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    setState(() => loading = true);

    exercises = await SupabaseService.getExercises(widget.workout['id']);

    setState(() => loading = false);
  }

  // ---------------------------
  // ADD EXERCISE MODAL
  // ---------------------------
  void openAddExerciseModal() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Aggiungi Esercizio"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Nome esercizio"),
          ),
          actions: [
            TextButton(
              child: const Text("Annulla"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Aggiungi"),
              onPressed: () async {
                final name = nameController.text.trim();

                if (name.isNotEmpty) {
                  await SupabaseService.supabase.from('exercises').insert({
                    'workout_id': widget.workout['id'],
                    'name': name,
                  });

                  Navigator.pop(context);
                  loadExercises();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // ---------------------------
  // GLASS CARD
  // ---------------------------
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

  // ---------------------------
  // BUILD
  // ---------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout['name']),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: openAddExerciseModal,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : exercises.isEmpty
              ? const Center(
                  child: Text(
                    "Nessun esercizio",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final ex = exercises[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExerciseDetailPage(exercise: ex),
                            ),
                          );
                        },
                        child: glassCard(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ex['name'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
