import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/view_mode.dart';

/// Service for persisting user preferences using shared_preferences
class PreferencesService {
  /// SharedPreferences key for storing the last used calculator mode
  static const String _keyLastViewMode = 'last_view_mode';

  /// Get the singleton instance of SharedPreferences
  static SharedPreferences? _prefs;

  /// Initialize the preferences service
  /// Must be called before using other methods
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensure preferences are initialized
  static SharedPreferences get _preferences {
    if (_prefs == null) {
      throw Exception(
        'PreferencesService not initialized. Call init() first.',
      );
    }
    return _prefs!;
  }

  /// Save the last used view mode
  static Future<void> saveLastViewMode(ViewMode mode) async {
    await _preferences.setInt(_keyLastViewMode, mode.index);
  }

  /// Get the last used view mode
  /// Returns null if no saved mode exists
  static ViewMode? getLastViewMode() {
    final index = _preferences.getInt(_keyLastViewMode);
    if (index == null) return null;

    // Convert index to ViewMode
    return ViewMode.values.firstWhere(
      (mode) => mode.index == index,
      orElse: () => ViewMode.standard,
    );
  }

  /// Clear the last view mode (reset to default)
  static Future<void> clearLastViewMode() async {
    await _preferences.remove(_keyLastViewMode);
  }

  /// Clear all preferences
  static Future<void> clearAll() async {
    await _preferences.clear();
  }

  /// Private constructor to prevent instantiation
  PreferencesService._();
}
