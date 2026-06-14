import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class WorkoutListPage extends StatefulWidget {
  const WorkoutListPage({super.key});

  @override
  State<WorkoutListPage> createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
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

  // ⭐ Animazione Apple Fitness
  Widget animated(Widget child, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + index * 120),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
    );
  }

  // ⭐ Card stile Apple Fitness
  Widget workoutCard(Map<String, dynamic> w, int index) {
    final date = (w['created_at'] ?? w['date'] ?? '').toString();
    final shortDate = date.isNotEmpty ? date.substring(0, 10) : "--";

    return animated(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  // ⭐ Icona
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.fitness_center,
                        color: Colors.blue, size: 32),
                  ),

                  const SizedBox(width: 18),

                  // ⭐ Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          w['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          shortDate,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ⭐ Pulsante apri
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/workout_detail",
                        arguments: w,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      index,
    );
  }

  // ⭐ Dialog per aggiungere un workout
  Future<void> showAddWorkoutDialog() async {
    final nameController = TextEditingController();
    final notesController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              decoration: const InputDecoration(labelText: "Note (opzionale)"),
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

              if (name.isNotEmpty) {
                await SupabaseService.createWorkout(name, notes);
                Navigator.pop(context);
                await loadWorkouts();
              }
            },
            child: const Text("Salva"),
          ),
        ],
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
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: showAddWorkoutDialog,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: loadWorkouts,
                child: workouts.isEmpty
                    ? ListView(
                        padding: const EdgeInsets.only(top: 120),
                        children: const [
                          Center(
                            child: Text(
                              "Nessun workout ancora registrato",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        padding: const EdgeInsets.only(top: 100, bottom: 100),
                        children: [
                          ...workouts.asMap().entries.map(
                            (e) => workoutCard(e.value, e.key),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }
}
