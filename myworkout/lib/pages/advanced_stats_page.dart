import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdvancedStatsPage extends StatefulWidget {
  const AdvancedStatsPage({super.key});

  @override
  State<AdvancedStatsPage> createState() => _AdvancedStatsPageState();
}

class _AdvancedStatsPageState extends State<AdvancedStatsPage> {
  List<Map<String, dynamic>> weightHistory = [];
  List<Map<String, dynamic>> prs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    setState(() => loading = true);

    weightHistory = await SupabaseService.getBodyMetrics();
    prs = await SupabaseService.getPersonalRecords();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistiche Avanzate"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ---------------------------
                // PESO CORPOREO
                // ---------------------------
                glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Peso Corporeo",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (weightHistory.isEmpty)
                        const Text("Nessun dato disponibile"),
                      if (weightHistory.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ultimo peso: ${weightHistory.first['weight']} kg",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (weightHistory.length > 1)
                              Text(
                                "Precedente: ${weightHistory[1]['weight']} kg",
                                style: const TextStyle(fontSize: 16),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // ---------------------------
                // PERSONAL RECORDS
                // ---------------------------
                glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Personal Records",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (prs.isEmpty)
                        const Text("Nessun PR registrato"),
                      if (prs.isNotEmpty)
                        Column(
                          children: prs.map((pr) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    pr['exercise_name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "${pr['weight']} kg",
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
