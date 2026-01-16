/// Helper class to add emoji icons to whimsical units based on Unit ID
class UnitIcons {
  /// Mapping of Unit IDs to their emoji icons
  /// Based on: wincalc_engine/src/unit_icons.dart
  /// Unit IDs must match the IDs defined in calc_manager_wrapper.cpp
  static const Map<int, String> _icons = {
    // Volume units (category 11)
    1220: '☕',   // CoffeeCup (Metric cup)
    1221: '🛁',   // Bathtub
    1222: '🏊',   // SwimmingPool

    // Length units (category 0)
    129: '🍌',    // Banana
    130: '🎂',    // Cake
  };

  /// Get the emoji icon for a unit ID
  /// Returns empty string if no icon is defined for the unit
  static String getIcon(int unitId) {
    return _icons[unitId] ?? '';
  }

  /// Format a suggested value with its icon if available
  /// Example: "☕ 4.23 Metric cups" or just "4.23 Liters" (no icon)
  static String formatWithIcon(String value, String unit, int unitId) {
    final icon = getIcon(unitId);
    if (icon.isEmpty) {
      return '$value $unit';
    }
    return '$icon $value $unit';
  }

  /// Check if a unit is whimsical (has an icon)
  static bool isWhimsical(int unitId) {
    return _icons.containsKey(unitId);
  }
}
