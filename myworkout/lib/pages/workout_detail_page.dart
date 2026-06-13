import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class WorkoutDetailPage extends StatefulWidget {
  final Map<String, dynamic> workout;

  const WorkoutDetailPage({
    super.key,
    required this.workout,
  });

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

    exercises = await SupabaseService.getExercises(
      widget.workout['id'].toString(),
    );

    setState(() => loading = false);
  }

  // ⭐ Popup per aggiungere un nuovo esercizio
  Future<void> addExerciseDialog() async {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Nuovo Esercizio"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Nome esercizio",
              hintText: "Es. Panca Piana",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annulla"),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;

                await SupabaseService.addExercise(
                  widget.workout['id'].toString(),
                  name,
                );

                Navigator.pop(context);
                loadExercises(); // 🔥 aggiorna la lista
              },
              child: const Text("Aggiungi"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: Text(widget.workout['name']),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addExerciseDialog,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3E5F5), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.only(
                    top: 100, bottom: 100, left: 16, right: 16),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final ex = exercises[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/exercise_detail",
                        arguments: ex,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ClipRRect(
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
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.fitness_center,
                                    color: Colors.deepPurple,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    ex['name'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
