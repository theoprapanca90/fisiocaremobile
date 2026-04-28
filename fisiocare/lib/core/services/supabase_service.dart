import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // ──────────────────────────────────────────────────────────────────
  // GANTI dengan URL dan ANON KEY dari Supabase project kamu:
  // Dashboard → Settings → API → Project URL & anon/public key
  // ──────────────────────────────────────────────────────────────────
  static const String supabaseUrl = 'https://bbvfvyxflwtbhkbgczgf.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJidmZ2eXhmbHd0YmhrYmdjemdmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzYxNDE1MzYsImV4cCI6MjA5MTcxNzUzNn0.yoxF-7-FFFaqMwHDO9DpnHr7qAD0uldf54J1JIw71v0';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
  static GoTrueClient get auth => Supabase.instance.client.auth;
}
