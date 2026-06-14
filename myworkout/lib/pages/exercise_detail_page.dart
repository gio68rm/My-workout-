import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myworkout/services/supabase_service.dart';

class ExerciseDetailPage extends StatefulWidget {
  final Map<String, dynamic> exercise;

  const ExerciseDetailPage({
    super.key,
    required this.exercise,
  });

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  List<Map<String, dynamic>> sets = [];
  bool loading = true;
  double totalVolume = 0;

  @override
  void initState() {
    super.initState();
    loadSets();
  }

  Future<void> loadSets() async {
    setState(() => loading = true);

    sets = await SupabaseService.getSets(widget.exercise['id'].toString());

    totalVolume = 0;
    for (final s in sets) {
      totalVolume += (s['reps'] as num) * (s['weight'] as num);
    }

    setState(() => loading = false);
  }

  Future<void> addSetDialog() async {
    final repsController = TextEditingController();
    final weightController = TextEditingController();
    final rpeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Aggiungi Set"),
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
              onPressed: () => Navigator.pop(context),
              child: const Text("Annulla"),
            ),
            ElevatedButton(
              onPressed: () async {
                await SupabaseService.addSet(
                  widget.exercise['id'].toString(),
                  int.tryParse(repsController.text) ?? 0,
                  double.tryParse(weightController.text) ?? 0,
                  double.tryParse(rpeController.text) ?? 0,
                );

                Navigator.pop(context);
                loadSets();
              },
              child: const Text("Aggiungi"),
            ),
          ],
        );
      },
    );
  }

  Widget setCard(Map<String, dynamic> s) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.55),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Text(
                "${s['reps']} reps",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 20),
              Text(
                "${s['weight']} kg",
                style: const TextStyle(fontSize: 18),
              ),
              const Spacer(),
              Text(
                "RPE ${s['rpe']}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ],
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
        title: Text(widget.exercise['name']),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addSetDialog,
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
                children: [
                  // ⭐ Volume totale
                  ClipRRect(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Volume Totale",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${totalVolume.toStringAsFixed(1)} kg",
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ⭐ Lista set
                  ...sets.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: setCard(s),
                      )),
                ],
              ),
      ),
    );
  }
}
