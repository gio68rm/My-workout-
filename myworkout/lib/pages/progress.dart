import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Weight Trend (Last 7 Days)',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 72.4),
                      FlSpot(1, 72.2),
                      FlSpot(2, 72.0),
                      FlSpot(3, 71.8),
                      FlSpot(4, 71.6),
                      FlSpot(5, 71.5),
                      FlSpot(6, 71.4),
                    ],
                    isCurved: true,
                    color: Colors.orangeAccent,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Body Fat Trend (Last 7 Days)',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 18.2),
                      FlSpot(1, 18.1),
                      FlSpot(2, 18.0),
                      FlSpot(3, 17.9),
                      FlSpot(4, 17.8),
                      FlSpot(5, 17.7),
                      FlSpot(6, 17.6),
                    ],
                    isCurved: true,
                    color: Colors.greenAccent,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Workout Frequency (Sessions per Week)',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(toY: 3, color: Colors.blueAccent),
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(toY: 4, color: Colors.blueAccent),
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(toY: 5, color: Colors.blueAccent),
                  ]),
                  BarChartGroupData(x: 3, barRods: [
                    BarChartRodData(toY: 4, color: Colors.blueAccent),
                  ]),
                  BarChartGroupData(x: 4, barRods: [
                    BarChartRodData(toY: 6, color: Colors.blueAccent),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
