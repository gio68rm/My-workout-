import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<Map<String, dynamic>> metrics = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMetrics();
  }

  Future<void> loadMetrics() async {
    setState(() => loading = true);

    final data = await SupabaseService.getBodyMetrics();
    metrics = data;

    setState(() => loading = false);
  }

  // ---------------------------
  // GLASS CARD
  // ---------------------------
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

  // ---------------------------
  // ADD WEIGHT MODAL
  // ---------------------------
  void openAddWeightModal() {
    final weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Aggiungi Peso"),
          content: TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Peso (kg)"),
          ),
          actions: [
            TextButton(
              child: const Text("Annulla"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Salva"),
              onPressed: () async {
                final weight = double.tryParse(weightController.text) ?? 0;

                if (weight > 0) {
                  await SupabaseService.addBodyMetric(weight);
                  Navigator.pop(context);
                  loadMetrics();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // ---------------------------
  // BUILD
  // ---------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progressi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: openAddWeightModal,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : metrics.isEmpty
              ? const Center(
                  child: Text(
                    "Nessun dato registrato",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: metrics.length,
                  itemBuilder: (context, index) {
                    final m = metrics[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: glassCard(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${m['weight']} kg",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              m['created_at']
                                  .toString()
                                  .substring(0, 10), // yyyy-mm-dd
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
