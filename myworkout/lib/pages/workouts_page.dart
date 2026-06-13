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

  // ⭐ Popup per creare un nuovo workout
  Future<void> addWorkoutDialog() async {
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
                decoration: const InputDecoration(
                  labelText: "Nome workout",
                  hintText: "Es. Petto + Tricipiti",
                ),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: "Note (opzionale)",
                ),
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
                final name = nameController.text.trim();
                final notes = notesController.text.trim();

                if (name.isEmpty) return;

                await SupabaseService.createWorkout(name, notes);

                Navigator.pop(context);
                loadWorkouts(); // 🔥 aggiorna lista
              },
              child: const Text("Crea"),
            ),
          ],
        );
      },
    );
  }

  Widget workoutCard(Map<String, dynamic> w) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkoutDetailPage(workout: w),
          ),
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
                      w['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text("Workouts"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addWorkoutDialog,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE7F6), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.only(
                    top: 100, bottom: 100, left: 16, right: 16),
                children: workouts
                    .map((w) => workoutCard(w))
                    .toList(),
              ),
      ),
    );
  }
}
