import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Pagine
import 'pages/splash_screen.dart';
import 'pages/main_navigation.dart';
import 'pages/workout_detail_page.dart';
import 'pages/exercise_detail_page.dart';
import 'pages/exercise_pr_page.dart';
import 'pages/progress.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⭐ Inizializzazione Supabase
  await Supabase.initialize(
    url: "https://vtfhecngpgvfaegfycnb.supabase.co",
    anonKey: "LA_TUA_ANON_KEY",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Workout",
      debugShowCheckedModeBanner: false,

      // ⭐ Tema coerente con tutta l’app
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
      ),

      // ⭐ Splash Screen come pagina iniziale
      home: const SplashScreen(),

      // ⭐ Routing completo
      routes: {
        "/home": (context) => const MainNavigation(),

        "/workout_detail": (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return WorkoutDetailPage(workout: args);
        },

        "/exercise_detail": (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return ExerciseDetailPage(exercise: args);
        },

        "/exercise_pr": (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return ExercisePRPage(exercise: args);
        },

        "/progress": (context) => const ProgressPage(),
      },
    );
  }
}
