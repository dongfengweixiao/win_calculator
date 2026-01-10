import '../../domain/entities/angle_type.dart';

/// Angle service
/// Manages angle type conversions and cycling
class AngleService {
  /// Cycle to the next angle type
  static AngleType cycleAngleType(AngleType current) {
    return current.next;
  }

  /// Get angle type value
  static int getAngleTypeValue(AngleType type) {
    return type.value;
  }

  /// Get angle type label
  static String getAngleTypeLabel(AngleType type) {
    return type.label;
  }

  /// Get angle type from value
  static AngleType fromValue(int value) {
    return AngleType.fromValue(value);
  }

  /// Convert degrees to radians
  static double degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }

  /// Convert radians to degrees
  static double radiansToDegrees(double radians) {
    return radians * (180 / 3.14159265359);
  }

  /// Convert gradians to degrees
  static double gradiansToDegrees(double gradians) {
    return gradians * (180 / 200);
  }

  /// Convert degrees to gradians
  static double degreesToGradians(double degrees) {
    return degrees * (200 / 180);
  }

  /// Private constructor to prevent instantiation
  AngleService._();
}
