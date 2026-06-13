import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class PRPage extends StatefulWidget {
  const PRPage({super.key});

  @override
  State<PRPage> createState() => _PRPageState();
}

class _PRPageState extends State<PRPage> {
  List<Map<String, dynamic>> prs = [];

  @override
  void initState() {
    super.initState();
    loadPRs();
  }

  Future<void> loadPRs() async {
    final data = await SupabaseService.getPersonalRecords();
    setState(() => prs = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Personal Records"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 100, bottom: 50),
          itemCount: prs.length,
          itemBuilder: (context, i) {
            final pr = prs[i];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ClipRRect(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pr['exercise_name'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _metric("Max Weight", "${pr['max_weight']} kg", Icons.fitness_center),
                            _metric("Max Volume", "${pr['max_volume']} kg", Icons.auto_graph),
                            _metric("Best RPE", "${pr['best_rpe']}", Icons.bolt),
                          ],
                        ),

                        const SizedBox(height: 12),
                        Text(
                          "Last record: ${pr['record_date']}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _metric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.blue),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
