import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExerciseProgressChart extends StatelessWidget {
  final List<double> weights;

  const ExerciseProgressChart({super.key, required this.weights});

  @override
  Widget build(BuildContext context) {
    if (weights.isEmpty) {
      return const Center(child: Text("No data"));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        titlesData: const FlTitlesData(show: false),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (int i = 0; i < weights.length; i++)
                FlSpot(i.toDouble(), weights[i])
            ],
            isCurved: true,
            color: Colors.orange,
            barWidth: 4,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withOpacity(0.4),
                  Colors.orange.withOpacity(0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
