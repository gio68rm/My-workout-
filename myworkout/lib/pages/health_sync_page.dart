import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:myworkout/services/supabase_service.dart';

class HealthSyncPage extends StatefulWidget {
  const HealthSyncPage({super.key});

  @override
  State<HealthSyncPage> createState() => _HealthSyncPageState();
}

class _HealthSyncPageState extends State<HealthSyncPage> {
  final Health _health = Health();

  bool _isSyncing = false;
  String _status = "Nessuna sincronizzazione eseguita";

  // Tipi di dati da leggere
  final List<HealthDataType> _types = const [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.HEART_RATE,
  ];

  Future<void> _syncHealthData() async {
    setState(() {
      _isSyncing = true;
      _status = "Sincronizzazione in corso...";
    });

    // Permessi di lettura
    final permissions =
        _types.map((e) => HealthDataAccess.READ).toList();

    // Richiesta permessi
    final hasPermissions =
        await _health.requestAuthorization(_types, permissions: permissions);

    if (!hasPermissions) {
      setState(() {
        _isSyncing = false;
        _status = "Permessi non concessi";
      });
      return;
    }

    // Intervallo: ultimi 7 giorni
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 7));

    // Lettura dati
    final data = await _health.getHealthDataFromTypes(
      types: _types,
      startTime: start,
      endTime: now,
    );

    int steps = 0;
    double activeEnergy = 0;
    double distance = 0;
    double heartRate = 0;

    for (final entry in data) {
      switch (entry.type) {
        case HealthDataType.STEPS:
          steps += (entry.value as num).toInt();
          break;

        case HealthDataType.ACTIVE_ENERGY_BURNED:
          activeEnergy += (entry.value as num).toDouble();
          break;

        case HealthDataType.DISTANCE_WALKING_RUNNING:
          distance += (entry.value as num).toDouble();
          break;

        case HealthDataType.HEART_RATE:
          heartRate = (entry.value as num).toDouble();
          break;

        default:
          break;
      }
    }

    await SupabaseService.insertHealthMetrics(
      steps: steps,
      activeEnergy: activeEnergy,
      distance: distance,
      heartRate: heartRate,
    );

    setState(() {
      _isSyncing = false;
      _status =
          "Sincronizzato:\nPassi: $steps\nEnergia: ${activeEnergy.toStringAsFixed(1)} kcal\nDistanza: ${distance.toStringAsFixed(2)} km\nHR: ${heartRate.toStringAsFixed(1)} bpm";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Sync"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Sincronizza i dati salute dal dispositivo",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSyncing ? null : _syncHealthData,
              child: _isSyncing
                  ? const CircularProgressIndicator()
                  : const Text("Sincronizza ora"),
            ),
            const SizedBox(height: 20),
            Text(
              _status,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
