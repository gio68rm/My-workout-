import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class BodyMetricsPage extends StatefulWidget {
  const BodyMetricsPage({super.key});

  @override
  State<BodyMetricsPage> createState() => _BodyMetricsPageState();
}

class _BodyMetricsPageState extends State<BodyMetricsPage> {
  final weightController = TextEditingController();
  final fatController = TextEditingController();
  final muscleController = TextEditingController();

  bool loading = false;
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await SupabaseService.getBodyMetrics();
    setState(() => history = data);
  }

  Future<void> _saveMetrics() async {
    final weight = double.tryParse(weightController.text);
    final fat = double.tryParse(fatController.text);
    final muscle = double.tryParse(muscleController.text);

    if (weight == null || fat == null || muscle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inserisci valori validi")),
      );
      return;
    }

    setState(() => loading = true);

    await SupabaseService.insertBodyMetrics(
      weight: weight,
      bodyFat: fat,
      muscleMass: muscle,
    );

    weightController.clear();
    fatController.clear();
    muscleController.clear();

    await _loadHistory();

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Body Metrics")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Peso (kg)"),
            ),
            TextField(
              controller: fatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Body Fat (%)"),
            ),
            TextField(
              controller: muscleController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Massa Muscolare (kg)"),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: loading ? null : _saveMetrics,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Salva"),
            ),

            const SizedBox(height: 24),
            const Text(
              "Storico Body Metrics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, i) {
                  final item = history[i];
                  return Card(
                    child: ListTile(
                      title: Text("Peso: ${item['weight']} kg"),
                      subtitle: Text(
                        "Body Fat: ${item['body_fat']}%\n"
                        "Muscolo: ${item['muscle_mass']} kg\n"
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
