import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorMessage;
  bool loading = false;

  Future<void> signIn() async {
    setState(() => loading = true);
    try {
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.session != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() => errorMessage = "Credenziali non valide");
      }
    } catch (e) {
      setState(() => errorMessage = e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> signUp() async {
    setState(() => loading = true);
    try {
      await SupabaseConfig.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() => errorMessage = "Registrazione completata. Ora effettua il login.");
    } catch (e) {
      setState(() => errorMessage = e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : signIn,
              child: loading ? const CircularProgressIndicator() : const Text("Accedi"),
            ),
            TextButton(
              onPressed: loading ? null : signUp,
              child: const Text("Registrati"),
            )
          ],
        ),
      ),
    );
  }
}
