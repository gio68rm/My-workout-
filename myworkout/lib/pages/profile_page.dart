import 'package:flutter/material.dart';
import 'package:myworkout/services/supabase_service.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? bodyMetrics;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    final latest = await SupabaseService.getLatestBodyMetric();
    setState(() {
      bodyMetrics = latest;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final weight = bodyMetrics?['weight']?.toString() ?? '--';
    final fat = bodyMetrics?['body_fat']?.toString() ?? '--';
    final muscle = bodyMetrics?['muscle_mass']?.toString() ?? '--';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Le tue metriche corporee",
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
              "Impostazioni profilo",
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
        color: Colors.green.shade50,
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
