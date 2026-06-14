import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/supabase_service.dart';

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
    final weights = await SupabaseService.getWeightHistory();
    final fats = await SupabaseService.getBodyFatHistory();

    setState(() {
      weightHistory = weights;
      bodyFatHistory = fats;
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistiche Avanzate"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Andamento Peso",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildLineChart(weightHistory, Colors.blue),

            const SizedBox(height: 32),

            const Text(
              "Andamento Body Fat",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildLineChart(bodyFatHistory, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(List<double> values, Color color) {
    if (values.isEmpty) {
      return const Text("Nessun dato disponibile");
    }

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          minY: values.reduce((a, b) => a < b ? a : b) - 1,
          maxY: values.reduce((a, b) => a > b ? a : b) + 1,
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (int i = 0; i < values.length; i++)
                  FlSpot(i.toDouble(), values[i]),
              ],
              isCurved: true,
              color: color,
              barWidth: 3,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
