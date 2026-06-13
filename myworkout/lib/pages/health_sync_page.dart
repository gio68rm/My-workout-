import 'package:flutter/material.dart';
import 'package:health/health.dart';
import '../services/supabase_service.dart';

class HealthSyncPage extends StatefulWidget {
  const HealthSyncPage({super.key});

  @override
  State<HealthSyncPage> createState() => _HealthSyncPageState();
}

class _HealthSyncPageState extends State<HealthSyncPage> {
  final HealthFactory _health = HealthFactory();
  String status = "Premi il bottone per sincronizzare da Apple Health";
  bool loading = false;
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await SupabaseService.getHealthMetrics();
    setState(() => history = data);
  }

  Future<void> _syncFromAppleHealth() async {
    setState(() {
      loading = true;
      status = "Lettura dati da Apple Health...";
    });

    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.DISTANCE_WALKING_RUNNING,
      HealthDataType.HEART_RATE,
    ];

    final permissions = types.map((e) => HealthDataAccess.READ).toList();

    final granted = await _health.requestAuthorization(types, permissions: permissions);

    if (!granted) {
      setState(() {
        loading = false;
        status = "Permessi non concessi";
      });
      return;
    }

    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    try {
      final data = await _health.getHealthDataFromTypes(yesterday, now, types);

      double steps = 0;
      double calories = 0;
      double distance = 0;
      double heartRate = 0;

      for (var d in data) {
        switch (d.type) {
          case HealthDataType.STEPS:
            steps += (d.value as num).toDouble();
            break;
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            calories += (d.value as num).toDouble();
            break;
          case HealthDataType.DISTANCE_WALKING_RUNNING:
            distance += (d.value as num).toDouble();
            break;
          case HealthDataType.HEART_RATE:
            heartRate = (d.value as num).toDouble();
            break;
          default:
            break;
        }
      }

      await SupabaseService.insertHealthMetrics(
        steps: steps,
        calories: calories,
        distance: distance,
        heartRate: heartRate,
      );

      await _loadHistory();

      setState(() {
        loading = false;
        status = "Sincronizzazione completata";
      });
    } catch (e) {
      setState(() {
        loading = false;
        status = "Errore: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final latest = history.isNotEmpty ? history.first : null;

    return Scaffold(
      appBar: AppBar(title: const Text("Apple Health Sync")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: loading ? null : _syncFromAppleHealth,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Sincronizza da Apple Health"),
            ),
            const SizedBox(height: 16),
            Text(status, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 24),
            if (latest != null) ...[
              const Text("Ultima sincronizzazione",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Passi: ${latest['steps']}"),
              Text("Calorie: ${latest['calories']} kcal"),
              Text("Distanza: ${(latest['distance_m'] / 1000).toStringAsFixed(2)} km"),
              Text("Battito: ${latest['heart_rate']} bpm"),
            ],

            const SizedBox(height: 24),
            const Text("Storico sincronizzazioni",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, i) {
                  final item = history[i];
                  return Card(
                    child: ListTile(
                      title: Text("Passi: ${item['steps']}"),
                      subtitle: Text(
                        "Calorie: ${item['calories']} kcal\n"
                        "Distanza: ${(item['distance_m'] / 1000).toStringAsFixed(2)} km\n"
                        "Battito: ${item['heart_rate']} bpm\n"
                        "Data: ${item['created_at']}",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
