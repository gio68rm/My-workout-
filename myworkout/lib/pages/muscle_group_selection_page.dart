import 'package:flutter/material.dart';

class MuscleGroupSelectionPage extends StatefulWidget {
  const MuscleGroupSelectionPage({super.key});

  @override
  State<MuscleGroupSelectionPage> createState() =>
      _MuscleGroupSelectionPageState();
}

class _MuscleGroupSelectionPageState extends State<MuscleGroupSelectionPage> {
  final List<Map<String, dynamic>> groups = [
    {'id': 1, 'name': 'Chest', 'icon': Icons.fitness_center},
    {'id': 2, 'name': 'Back', 'icon': Icons.swap_vert},
    {'id': 3, 'name': 'Shoulders', 'icon': Icons.accessibility_new},
    {'id': 4, 'name': 'Legs', 'icon': Icons.directions_run},
    {'id': 5, 'name': 'Arms', 'icon': Icons.pan_tool},
    {'id': 6, 'name': 'Abs', 'icon': Icons.sports_kabaddi},
  ];

  final Set<int> selected = {};

  void toggle(int id) {
    setState(() {
      if (selected.contains(id)) {
        selected.remove(id);
      } else {
        selected.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Muscle Groups"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // ⭐ GRID 2x3
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: groups.map((g) {
                final bool active = selected.contains(g['id']);

                return GestureDetector(
                  onTap: () => toggle(g['id']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: active ? Colors.green.shade400 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: active ? Colors.green : Colors.grey.shade400,
                        width: 2,
                      ),
                      boxShadow: [
                        if (active)
                          BoxShadow(
                            color: Colors.green.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          g['icon'],
                          size: 48,
                          color: active ? Colors.white : Colors.black87,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          g['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: active ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // ⭐ START BUTTON
          if (selected.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, selected.toList());
                },
                child: const Text(
                  "Start Workout",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
