import 'package:flutter/material.dart';
import 'package:myworkout/services/supabase_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? bodyMetrics;
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    try {
      final latest = await SupabaseService.getLatestBodyMetric();

      setState(() {
        bodyMetrics = latest;
        loading = false;
        error = latest == null;
      });
    } catch (e) {
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error) {
      return Scaffold(
        body: Center(
          child: Text(
            "Nessun dato disponibile",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
          ),
        ),
      );
    }

    final weight = bodyMetrics?['weight']?.toString() ?? '--';
    final fat = bodyMetrics?['body_fat']?.toString() ?? '--';
    final muscle = bodyMetrics?['muscle_mass']?.toString() ?? '--';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ultime metriche corporee",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _metricCard("Peso", "$weight kg"),
                _metricCard("Body Fat", "$fat %"),
                _metricCard("Muscoli", "$muscle kg"),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Altre sezioni…",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(String title, String value) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
