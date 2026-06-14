import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myworkout/services/supabase_service.dart';


class ExercisePRPage extends StatefulWidget {
  final Map<String, dynamic> exercise;

  const ExercisePRPage({
    super.key,
    required this.exercise,
  });

  @override
  State<ExercisePRPage> createState() => _ExercisePRPageState();
}

class _ExercisePRPageState extends State<ExercisePRPage> {
  List<Map<String, dynamic>> progress = [];
  bool loading = true;
  double maxWeight = 0;

  @override
  void initState() {
    super.initState();
    loadPR();
  }

  Future<void> loadPR() async {
    setState(() => loading = true);

    progress = await SupabaseService.getExerciseProgress(widget.exercise['id']);

    maxWeight = 0;
    for (final p in progress) {
      final w = (p['weight'] as num?)?.toDouble() ?? 0;
      if (w > maxWeight) maxWeight = w;
    }

    setState(() => loading = false);
  }

  Widget prCard() {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Personal Record",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${maxWeight.toStringAsFixed(1)} kg",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Peso massimo mai sollevato",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget historyCard(Map<String, dynamic> p) {
    final weight = (p['weight'] as num?)?.toDouble() ?? 0;
    final date = p['date']?.toString().substring(0, 10) ?? "—";

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
                "$weight kg",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: TextStyle(
                  fontSize: 14,
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
        title: Text("${widget.exercise['name']} — PR"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8EAF6), Color(0xFFFFFFFF)],
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
                  prCard(),
                  const SizedBox(height: 30),

                  const Text(
                    "Storico PR",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ...progress.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: historyCard(p),
                      )),
                ],
              ),
      ),
    );
  }
}
