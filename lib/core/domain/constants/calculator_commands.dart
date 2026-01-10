import 'package:wincalc_engine/wincalc_engine.dart';

/// Calculator command constants
/// Centralized location for all calculator command codes
///
/// Commands are imported from wincalc_engine package and re-exported here
/// for convenience and to provide a single import point
class CalculatorCommands {
  // This file serves as documentation and central reference
  // Actual command values are defined in wincalc_engine package

  /// Digit commands (0-9)
  static const int CMD_0 = 0;
  static const int CMD_1 = 1;
  static const int CMD_2 = 2;
  static const int CMD_3 = 3;
  static const int CMD_4 = 4;
  static const int CMD_5 = 5;
  static const int CMD_6 = 6;
  static const int CMD_7 = 7;
  static const int CMD_8 = 8;
  static const int CMD_9 = 9;

  /// Basic operations
  static const int CMD_ADD = 100;
  static const int CMD_SUBTRACT = 101;
  static const int CMD_MULTIPLY = 102;
  static const int CMD_DIVIDE = 103;
  static const int CMD_MOD = 104;
  static const int CMD_EQUALS = 105;
  static const int CMD_PERCENT = 106;
  static const int CMD_NEGATE = 107;
  static const int CMD_DECIMAL = 108;

  /// Clear operations
  static const int CMD_CLEAR = 200;
  static const int CMD_CENTR = 201;
  static const int CMD_BACKSPACE = 202;

  /// Memory operations
  static const int CMD_MEMORY_CLEAR = 300;
  static const int CMD_MEMORY_RECALL = 301;
  static const int CMD_MEMORY_ADD = 302;
  static const int CMD_MEMORY_SUBTRACT = 303;
  static const int CMD_MEMORY_STORE = 304;

  /// Scientific functions - Basic
  static const int CMD_SQUARE = 400;
  static const int CMD_SQRT = 401;
  static const int CMD_RECIPROCAL = 402;
  static const int CMD_POWER = 403;
  static const int CMD_CUBE = 404;
  static const int CMD_CUBEROOT = 405;
  static const int CMD_ROOT = 406;

  /// Scientific functions - Exponential/Logarithmic
  static const int CMD_LN = 500;
  static const int CMD_LOG = 501;
  static const int CMD_LOGBASEY = 502;
  static const int CMD_POW10 = 503;
  static const int CMD_POW2 = 504;
  static const int CMD_POWE = 505;
  static const int CMD_EXP = 506;

  /// Scientific functions - Trigonometric
  static const int CMD_SIN = 600;
  static const int CMD_COS = 601;
  static const int CMD_TAN = 602;
  static const int CMD_ASIN = 603;
  static const int CMD_ACOS = 604;
  static const int CMD_ATAN = 605;

  /// Scientific functions - Additional Trig
  static const int CMD_SEC = 700;
  static const int CMD_CSC = 701;
  static const int CMD_COT = 702;
  static const int CMD_ASEC = 703;
  static const int CMD_ACSC = 704;
  static const int CMD_ACOT = 705;

  /// Scientific functions - Hyperbolic
  static const int CMD_SINH = 800;
  static const int CMD_COSH = 801;
  static const int CMD_TANH = 802;
  static const int CMD_ASINH = 803;
  static const int CMD_ACOSH = 804;
  static const int CMD_ATANH = 805;

  /// Scientific functions - Additional Hyperbolic
  static const int CMD_SECH = 900;
  static const int CMD_CSCH = 901;
  static const int CMD_COTH = 902;
  static const int CMD_ASECH = 903;
  static const int CMD_ACSCH = 904;
  static const int CMD_ACOTH = 905;

  /// Scientific functions - Other
  static const int CMD_FACTORIAL = 1000;
  static const int CMD_ABS = 1001;
  static const int CMD_FLOOR = 1002;
  static const int CMD_CEIL = 1003;
  static const int CMD_DMS = 1004;
  static const int CMD_DEGREES = 1005;
  static const int CMD_FE = 1006; // F-E toggle

  /// Constants
  static const int CMD_PI = 1100;
  static const int CMD_EULER = 1101;
  static const int CMD_RAND = 1102;

  /// Parentheses
  static const int CMD_OPENP = 1200;
  static const int CMD_CLOSEP = 1201;

  /// Angle mode
  static const int CMD_DEG = 1300;
  static const int CMD_RAD = 1301;
  static const int CMD_GRAD = 1302;

  /// Map digit to command
  static int mapDigit(int digit) {
    if (digit < 0 || digit > 9) {
      throw ArgumentError('Digit must be between 0 and 9');
    }
    return digit;
  }

  /// Check if command is a digit
  static bool isDigit(int command) {
    return command >= 0 && command <= 9;
  }

  /// Check if command is a basic operation
  static bool isBasicOperation(int command) {
    return command >= 100 && command <= 108;
  }

  /// Check if command is a clear operation
  static bool isClearOperation(int command) {
    return command >= 200 && command <= 202;
  }

  /// Check if command is a memory operation
  static bool isMemoryOperation(int command) {
    return command >= 300 && command <= 304;
  }

  /// Check if command is a scientific function
  static bool isScientificFunction(int command) {
    return (command >= 400 && command <= 905) || command == 1006;
  }

  /// Private constructor to prevent instantiation
  CalculatorCommands._();
}
