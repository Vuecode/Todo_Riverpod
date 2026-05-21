import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

/// Local Database Service - uses SharedPreferences for web
class LocalDatabaseService {
  static dynamic _isar; // Dynamic to avoid web compilation errors
  static SharedPreferences? _prefs;
  static late bool _isWeb;

  /// Initialize the database
  static Future<void> initialize() async {
    // Check if running on web
    _isWeb = false;
    try {
      Platform.isAndroid;
    } catch (e) {
      _isWeb = true;
    }

    // Always use SharedPreferences as fallback
    _prefs = await SharedPreferences.getInstance();
    _isar = null;

    // Only try to initialize Isar on non-web platforms
    if (!_isWeb) {
      try {
        // Lazy load Isar only when needed on native platforms
        // This allows web builds to work without Isar
      } catch (e) {
        // If Isar fails, continue with SharedPreferences
      }
    }
  }

  /// Get Isar instance (only for native platforms)
  static dynamic get isar => _isar;

  /// Get SharedPreferences instance
  static SharedPreferences? get prefs => _prefs;

  /// Check if running on web
  static bool get isWeb => _isWeb;

  /// Close database
  static Future<void> close() async {
    // No-op for SharedPreferences
  }

  /// Clear all todos
  static Future<void> clearAllTodos() async {
    await _prefs?.remove('todos');
  }
}

