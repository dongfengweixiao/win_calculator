import '../../domain/entities/trig_mode.dart';

/// Trigonometric mode service
/// Manages trigonometric function mode (normal/hyperbolic)
class TrigModeService {
  /// Toggle trigonometric mode
  static TrigMode toggleTrigMode(TrigMode current) {
    return current.toggle;
  }

  /// Get trig mode label
  static String getTrigModeLabel(TrigMode mode) {
    return mode.label;
  }

  /// Get full name of trig mode
  static String getTrigModeFullName(TrigMode mode) {
    return mode.fullName;
  }

  /// Check if mode is hyperbolic
  static bool isHyperbolic(TrigMode mode) {
    return mode.isHyperbolic;
  }

  /// Check if mode is normal
  static bool isNormal(TrigMode mode) {
    return mode.isNormal;
  }

  /// Get function name based on trig mode
  static String getFunctionName(String baseName, TrigMode mode) {
    if (mode.isHyperbolic) {
      return 'a$baseName';
    }
    return baseName;
  }

  /// Private constructor to prevent instantiation
  TrigModeService._();
}
