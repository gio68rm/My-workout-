import 'package:flutter/material.dart';
import 'package:myworkout/services/supabase_service.dart';
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
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final data = await SupabaseService.getWorkouts();
    setState(() {
      workouts = data;
      loading = false;
    });
  }

  Future<void> _createWorkout() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nuovo Workout"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Nome workout",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annulla"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;

              final id = await SupabaseService.createWorkout(
                controller.text.trim(),
                "",
              );

              Navigator.pop(context);

              if (id != null) {
                _loadWorkouts();
              }
            },
            child: const Text("Crea"),
          ),
        ],
      ),
    );
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
        title: const Text("Workouts"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWorkout,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final w = workouts[index];

          return Card(
            child: ListTile(
              title: Text(w['name'] ?? 'Workout'),
              subtitle: Text(
                w['date'] != null
                    ? DateTime.parse(w['date']).toLocal().toString().split('.')[0]
                    : '',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkoutDetailPage(workoutId: w['id'].toString()),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
