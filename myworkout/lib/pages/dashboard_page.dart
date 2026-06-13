import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? bodyMetrics;
  Map<String, dynamic>? dailyMetrics;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);

    bodyMetrics = await SupabaseService.getBodyMetrics();
    dailyMetrics = await SupabaseService.getDailyMetrics();

    setState(() => loading = false);
  }

  // ⭐ Card generica stile Apple Fitness
  Widget metricCard(String label, String value, IconData icon, Color color) {
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
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ⭐ Card progressi (peso + body fat + muscle mass)
  Widget progressCard() {
    final weight = (bodyMetrics?['weight'] ?? 0).toDouble();
    final prevWeight = (dailyMetrics?['prev_weight'] ?? weight).toDouble();

    final bodyFat = (bodyMetrics?['body_fat'] ?? 0).toDouble();
    final prevBodyFat = (dailyMetrics?['prev_body_fat'] ?? bodyFat).toDouble();

    final muscle = (bodyMetrics?['muscle_mass'] ?? 0).toDouble();
    final prevMuscle = (dailyMetrics?['prev_muscle_mass'] ?? muscle).toDouble();

    final weightDiff = weight - prevWeight;
    final fatDiff = bodyFat - prevBodyFat;
    final muscleDiff = muscle - prevMuscle;

    Color trendColor(double diff) {
      if (diff < 0) return Colors.green; // miglioramento
      if (diff > 0) return Colors.red;   // peggioramento
      return Colors.grey;
    }

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
                "Progressi",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),

              // ⭐ Peso
              Row(
                children: [
                  const Icon(Icons.monitor_weight, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    "Peso: ${weight.toStringAsFixed(1)} kg",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  Text(
                    "${weightDiff >= 0 ? "+" : ""}${weightDiff.toStringAsFixed(1)} kg",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: trendColor(weightDiff),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ⭐ Body Fat
              Row(
                children: [
                  const Icon(Icons.percent, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    "Body Fat: ${bodyFat.toStringAsFixed(1)}%",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  Text(
                    "${fatDiff >= 0 ? "+" : ""}${fatDiff.toStringAsFixed(1)}%",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: trendColor(fatDiff),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ⭐ Muscle Mass
              Row(
                children: [
                  const Icon(Icons.fitness_center, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    "Muscle Mass: ${muscle.toStringAsFixed(1)} kg",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  Text(
                    "${muscleDiff >= 0 ? "+" : ""}${muscleDiff.toStringAsFixed(1)} kg",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: trendColor(muscleDiff),
                    ),
                  ),
                ],
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
        title: const Text("Dashboard"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
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
                  metricCard(
                    "Peso",
                    "${(bodyMetrics?['weight'] ?? 0).toStringAsFixed(1)} kg",
                    Icons.monitor_weight,
                    Colors.blue,
                  ),
                  const SizedBox(height: 20),

                  metricCard(
                    "Body Fat",
                    "${(bodyMetrics?['body_fat'] ?? 0).toStringAsFixed(1)}%",
                    Icons.percent,
                    Colors.pink,
                  ),
                  const SizedBox(height: 20),

                  metricCard(
                    "Muscle Mass",
                    "${(bodyMetrics?['muscle_mass'] ?? 0).toStringAsFixed(1)} kg",
                    Icons.fitness_center,
                    Colors.green,
                  ),
                  const SizedBox(height: 30),

                  progressCard(),
                ],
              ),
      ),
    );
  }
}
