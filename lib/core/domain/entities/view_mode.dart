/// View mode enum
/// Represents the different calculator modes available in the UI
enum ViewMode {
  /// Standard calculator mode
  standard,

  /// Scientific calculator mode
  scientific,

  /// Programmer calculator mode (not yet implemented)
  programmer,

  // Date calculation mode (not yet implemented)
  // dateCalculation,
}

/// Extension on ViewMode to provide conversion and display methods
extension ViewModeExtension on ViewMode {
  /// Get the display name for the view mode
  String get displayName {
    switch (this) {
      case ViewMode.standard:
        return '标准';
      case ViewMode.scientific:
        return '科学';
      case ViewMode.programmer:
        return '程序员';
    }
  }

  /// Get the icon label for the view mode
  String get iconLabel {
    switch (this) {
      case ViewMode.standard:
        return 'STD';
      case ViewMode.scientific:
        return 'SCI';
      case ViewMode.programmer:
        return 'PROG';
    }
  }
}
