/// Trigonometric mode enum
/// Represents the type of trigonometric functions to use
enum TrigMode {
  /// Standard trigonometric functions (sin, cos, tan)
  normal,

  /// Hyperbolic trigonometric functions (sinh, cosh, tanh)
  hyperbolic;

  /// Toggle between normal and hyperbolic mode
  TrigMode get toggle {
    return this == TrigMode.normal ? TrigMode.hyperbolic : TrigMode.normal;
  }

  /// Get the display label for the trig mode
  String get label {
    switch (this) {
      case TrigMode.normal:
        return '';
      case TrigMode.hyperbolic:
        return 'h';
    }
  }

  /// Get the full name of the trig mode
  String get fullName {
    switch (this) {
      case TrigMode.normal:
        return 'Normal';
      case TrigMode.hyperbolic:
        return 'Hyperbolic';
    }
  }

  /// Check if this is hyperbolic mode
  bool get isHyperbolic => this == TrigMode.hyperbolic;

  /// Check if this is normal mode
  bool get isNormal => this == TrigMode.normal;
}
