import 'package:flutter/material.dart';
import 'supabase_config.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⭐ INIZIALIZZAZIONE SUPABASE (OBBLIGATORIA PER WEB)
  await SupabaseConfig.initialize();

  runApp(const MyApp());
}
