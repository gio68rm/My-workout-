import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'workout_detail_page.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  List<Map<String, dynamic>> workouts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadWorkouts();
  }

  Future<void> loadWorkouts() async {
    setState(() => loading = true);
    workouts = await SupabaseService.getWorkouts();
    setState(() => loading = false);
  }

  void openAddWorkoutModal() {
    final nameController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Nuovo Workout"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nome workout"),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: "Note"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Annulla"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Crea"),
              onPressed: () async {
                final name = nameController.text.trim();
                final notes = notesController.text.trim();

                if (name.isNotEmpty) {
                  await SupabaseService.supabase.from('workouts').insert({
                    'name': name,
                    'notes': notes,
                    'date': DateTime.now().toIso8601String(),
                  });

                  Navigator.pop(context);
                  loadWorkouts();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workouts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: openAddWorkoutModal,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : workouts.isEmpty
              ? const Center(child: Text("Nessun workout"))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final w = workouts[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WorkoutDetailPage(workout: w),
                            ),
                          );
                        },
                        child: glassCard(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                w['name'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                w['date'].toString().substring(0, 10),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
