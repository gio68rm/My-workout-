import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://vtfhecngpgvfaegfycnb.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0ZmhlY25ncGd2ZmFlZ2Z5Y25iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEyNzkyMTEsImV4cCI6MjA5Njg1NTIxMX0.K36HstAy5qGS9AgFQUJpfj5KZJ4WHLSXfyfPC38Iht0';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
