/// Angle type enum
/// Represents the angle measurement system used in trigonometric calculations
enum AngleType {
  /// Degrees mode (0-360)
  degree(0, 'DEG'),

  /// Radians mode (0-2π)
  radian(1, 'RAD'),

  /// Gradians mode (0-400)
  gradian(2, 'GRAD');

  final int value;
  final String label;

  const AngleType(this.value, this.label);

  /// Legacy enum values for compatibility
  static const degrees = AngleType.degree;
  static const radians = AngleType.radian;
  static const gradians = AngleType.gradian;

  /// Cycle to the next angle type
  AngleType get next {
    final index = (value + 1) % AngleType.values.length;
    return AngleType.values[index];
  }

  /// Get angle type from integer value
  static AngleType fromValue(int value) {
    return AngleType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => AngleType.degree,
    );
  }

  /// Get the full name of the angle type
  String get fullName {
    switch (this) {
      case AngleType.degree:
        return 'Degree';
      case AngleType.radian:
        return 'Radian';
      case AngleType.gradian:
        return 'Grad';
    }
  }

  /// Get the symbol for the angle type
  String get symbol {
    switch (this) {
      case AngleType.degree:
        return '°';
      case AngleType.radian:
        return 'rad';
      case AngleType.gradian:
        return 'grad';
    }
  }
}
