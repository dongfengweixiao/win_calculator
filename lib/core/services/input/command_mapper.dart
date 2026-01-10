import '../../domain/constants/calculator_commands.dart';

/// Command mapping service
/// Maps UI inputs to calculator commands
class CommandMapper {
  /// Map digit to command
  static int mapDigitToCommand(int digit) {
    if (!InputValidator.isValidDigit(digit)) {
      throw ArgumentError('Invalid digit: $digit');
    }
    return CalculatorCommands.mapDigit(digit);
  }

  /// Map operator symbol to command
  static int mapOperatorToCommand(String operator) {
    switch (operator) {
      case '+':
        return CalculatorCommands.CMD_ADD;
      case '-':
        return CalculatorCommands.CMD_SUBTRACT;
      case '×':
      case '*':
        return CalculatorCommands.CMD_MULTIPLY;
      case '÷':
      case '/':
        return CalculatorCommands.CMD_DIVIDE;
      case '%':
        return CalculatorCommands.CMD_PERCENT;
      case '=':
        return CalculatorCommands.CMD_EQUALS;
      default:
        throw ArgumentError('Unknown operator: $operator');
    }
  }

  /// Get clear command based on current state
  static int getClearCommand({
    required String display,
    required String expression,
  }) {
    // If there's input or expression, show CE (Clear Entry)
    // Otherwise show C (Clear All)
    if (display != '0' || expression.isNotEmpty) {
      return CalculatorCommands.CMD_CENTR; // CE
    } else {
      return CalculatorCommands.CMD_CLEAR; // C
    }
  }

  /// Get the text for clear button
  static String getClearButtonText({
    required String display,
    required String expression,
  }) {
    if (display != '0' || expression.isNotEmpty) {
      return 'CE';
    } else {
      return 'C';
    }
  }

  /// Check if should show CE
  static bool shouldShowCE({
    required String display,
    required String expression,
  }) {
    return display != '0' || expression.isNotEmpty;
  }

  /// Map memory operation to command
  static int mapMemoryOperationToCommand(String operation) {
    switch (operation.toUpperCase()) {
      case 'MC':
        return CalculatorCommands.CMD_MEMORY_CLEAR;
      case 'MR':
        return CalculatorCommands.CMD_MEMORY_RECALL;
      case 'M+':
        return CalculatorCommands.CMD_MEMORY_ADD;
      case 'M-':
        return CalculatorCommands.CMD_MEMORY_SUBTRACT;
      case 'MS':
        return CalculatorCommands.CMD_MEMORY_STORE;
      default:
        throw ArgumentError('Unknown memory operation: $operation');
    }
  }

  /// Private constructor to prevent instantiation
  CommandMapper._();

  /// Import InputValidator to use its methods
  static final InputValidator = _InputValidatorProxy();
}

class _InputValidatorProxy {
  bool isValidDigit(int digit) {
    // Reuse the InputValidator logic
    return digit >= 0 && digit <= 9;
  }
}
