import 'package:flutter/material.dart';
import 'main_navigation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _loading = false;

  void _goToDashboard() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: _loading ? null : _goToDashboard,
          child: AnimatedOpacity(
            opacity: _loading ? 0.5 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Image.asset(
              'assets/logo.png',
              width: 180,
            ),
          ),
        ),
      ),
    );
  }
}
