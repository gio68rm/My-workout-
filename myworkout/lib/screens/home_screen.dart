import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "MyWorkout",
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dashboard",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // START WORKOUT BUTTON
            GestureDetector(
              onTap: () {
                // TODO: collegare alla pagina Start Workout
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade400,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Start Workout",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.play_arrow, size: 32, color: Colors.black),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // QUICK ACTIONS
            const Text(
              "Quick Actions",
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _quickButton(Icons.fitness_center, "Workouts"),
                _quickButton(Icons.timer, "Timer"),
                _quickButton(Icons.bar_chart, "Stats"),
                _quickButton(Icons.person, "Profile"),
              ],
            ),

            const SizedBox(height: 30),

            // RECENT WORKOUTS
            const Text(
              "Recent Workouts",
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: [
                  _workoutTile("Full Body", "45 min • Yesterday"),
                  _workoutTile("Chest & Arms", "30 min • 2 days ago"),
                  _workoutTile("Leg Day", "50 min • 4 days ago"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // QUICK BUTTON WIDGET
  Widget _quickButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  // WORKOUT TILE WIDGET
  Widget _workoutTile(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(color: Colors.white54, fontSize: 14)),
            ],
          ),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }
}
