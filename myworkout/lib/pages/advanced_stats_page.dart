import 'package:flutter/material.dart';
import 'package:myworkout/services/supabase_service.dart';

class AdvancedStatsPage extends StatefulWidget {
  const AdvancedStatsPage({super.key});

  @override
  State<AdvancedStatsPage> createState() => _AdvancedStatsPageState();
}

class _AdvancedStatsPageState extends State<AdvancedStatsPage> {
  List<double> weightHistory = [];
  List<double> bodyFatHistory = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final weights = await SupabaseService.getWeightHistory();
      final fats = await SupabaseService.getBodyFatHistory();

      setState(() {
        weightHistory = weights
            .map((e) => (e['weight'] as num).toDouble())
            .toList();

        bodyFatHistory = fats
            .map((e) => (e['body_fat'] as num).toDouble())
            .toList();

        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Statistiche Avanzate")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Andamento Peso", style: TextStyle(fontSize: 18)),
            Text(weightHistory.toString()),

            const SizedBox(height: 20),

            const Text("Andamento Body Fat", style: TextStyle(fontSize: 18)),
            Text(bodyFatHistory.toString()),
          ],
        ),
      ),
    );
  }
}