import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/health_sync_page.dart';
import 'pages/body_metrics_page.dart';
import 'pages/workouts_page.dart';
import 'pages/workout_detail_page.dart';
import 'pages/splash_page.dart';

class MyWorkoutApp extends StatelessWidget {
  const MyWorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MyWorkout",
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashPage(),
    );
  }
}