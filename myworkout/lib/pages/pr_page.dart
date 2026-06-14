import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class ExercisePRPage extends StatefulWidget {
  final Map<String, dynamic> exercise;

  const ExercisePRPage({super.key, required this.exercise});

  @override
  State<ExercisePRPage> createState() => _ExercisePRPageState();
}

class _ExercisePRPageState extends State<ExercisePRPage> {
  List<Map<String, dynamic>> sets = [];
  double? prWeight;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);

    // 1) Carica tutti i set dell’esercizio
    sets = await SupabaseService.getExerciseSets(widget.exercise['id']);

    // 2) Carica PR globali
    final allPRs = await SupabaseService.getPersonalRecords();

    // 3) Trova PR dell’esercizio corrente
    final pr = allPRs.firstWhere(
      (p) => p['exercise_name'] == widget.exercise['name'],
      orElse: () => {},
    );

    if (pr.isNotEmpty) {
      prWeight = pr['weight']?.toDouble();
    }

    setState(() => loading = false);
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
    final exerciseName = widget.exercise['name'];

    return Scaffold(
      appBar: AppBar(
        title: Text("PR – $exerciseName"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ---------------------------
                // PR CARD
                // ---------------------------
                glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Personal Record",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        prWeight != null
                            ? "${prWeight!.toStringAsFixed(1)} kg"
                            : "Nessun PR registrato",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // ---------------------------
                // STORICO SET
                // ---------------------------
                glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Storico Set",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (sets.isEmpty)
                        const Text("Nessun set registrato"),
                      if (sets.isNotEmpty)
                        Column(
                          children: sets.map((s) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${s['reps']} reps",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "${s['weight']} kg",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
