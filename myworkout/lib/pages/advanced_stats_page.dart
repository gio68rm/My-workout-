import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdvancedStatsPage extends StatefulWidget {
  const AdvancedStatsPage({super.key});

  @override
  State<AdvancedStatsPage> createState() => _AdvancedStatsPageState();
}

class _AdvancedStatsPageState extends State<AdvancedStatsPage> {
  double maxWeight = 0;
  double avgBodyFat = 0;
  double totalVolume = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    setState(() => loading = true);

    // ⭐ PR globale
    maxWeight = await SupabaseService.getGlobalMaxWeight();

    // ⭐ Body fat medio
    final bodyFatHistory = await SupabaseService.getBodyFatHistory();
    if (bodyFatHistory.isNotEmpty) {
      avgBodyFat =
          bodyFatHistory.reduce((a, b) => a + b) / bodyFatHistory.length;
    }

    // ⭐ Volume totale storico (per ora non abbiamo storico → lista vuota)
    final volumeHistory = <double>[]; // 🔥 FIX QUI
    if (volumeHistory.isNotEmpty) {
      totalVolume = volumeHistory.reduce((a, b) => a + b);
    }

    setState(() => loading = false);
  }

  Widget statCard(String title, String value, IconData icon, Color color) {
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
                    title,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text("Statistiche Avanzate"),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            : ListView(
                padding: const EdgeInsets.only(
                    top: 100, bottom: 100, left: 16, right: 16),
                children: [
                  statCard(
                    "PR Globale",
                    "${maxWeight.toStringAsFixed(1)} kg",
                    Icons.fitness_center,
                    Colors.deepPurple,
                  ),
                  const SizedBox(height: 20),

                  statCard(
                    "Body Fat Medio",
                    "${avgBodyFat.toStringAsFixed(1)}%",
                    Icons.percent,
                    Colors.pink,
                  ),
                  const SizedBox(height: 20),

                  statCard(
                    "Volume Totale Storico",
                    "${totalVolume.toStringAsFixed(1)} kg",
                    Icons.auto_graph,
                    Colors.blue,
                  ),
                ],
              ),
      ),
    );
  }
}
