import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'pages/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/main': (context) => const MainNavigation(),
      },
      home: const SplashScreen(),
    );
  }
}
