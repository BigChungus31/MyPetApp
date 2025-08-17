import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance!;

  late final SupabaseClient _client;
  SupabaseClient get client => _client;

  SupabaseService._();

  static Future<void> initialize() async {
    if (_instance != null) return;

    _instance = SupabaseService._();
    await _instance!._init();
  }

  Future<void> _init() async {
    try {
      // Load environment configuration
      final String envString = await rootBundle.loadString('env.json');
      final Map<String, dynamic> env = json.decode(envString);

      final String supabaseUrl = env['SUPABASE_URL'] ?? '';
      final String supabaseKey = env['SUPABASE_ANON_KEY'] ?? '';

      if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
        throw Exception(
            'Missing Supabase configuration. Please update env.json');
      }

      // Initialize Supabase
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
        debug: kDebugMode,
      );

      _client = Supabase.instance.client;
      debugPrint('✅ Supabase initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize Supabase: $e');
      rethrow;
    }
  }

  // Authentication helpers
  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  // Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
