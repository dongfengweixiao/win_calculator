import 'package:example/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../calculator/calculator_provider.dart';
import 'programmer_provider.dart';
import '../../shared/theme/theme_provider.dart';
import '../../core/theme/app_icons.dart';
import '../../core/widgets/calc_button.dart';
import 'services/programmer_button_service.dart';
import 'flyouts/bitwise_flyout.dart';
import 'flyouts/shift_flyout.dart';

/// Programmer calculator button panel layout
/// Full keypad mode: 6 rows x 5 columns
class ProgrammerButtonLayout extends ConsumerWidget {
  const ProgrammerButtonLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(calculatorThemeProvider);
    final programmerState = ref.watch(programmerProvider);
    final calculatorState = ref.watch(calculatorProvider);
    final buttonService = ProgrammerButtonService(ref);

    return Container(
      color: theme.background,
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          // Flyout buttons row
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BitwiseFlyoutButton(
                  programmer: ref.read(programmerProvider.notifier),
                  theme: theme,
                ),
                const SizedBox(width: 4),
                ShiftFlyoutButton(
                  programmer: ref.read(programmerProvider.notifier),
                  theme: theme,
                  currentMode: programmerState.shiftMode,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Keypad rows
          Expanded(
            child: _ButtonRow(
              labels: const ['A', '<<', '>>', 'C/CE', 'DEL'],
              theme: theme,
              programmerState: programmerState,
              calculatorState: calculatorState,
              buttonService: buttonService,
            ),
          ),
          Expanded(
            child: _ButtonRow(
              labels: const ['B', '(', ')', '%', '÷'],
              theme: theme,
              programmerState: programmerState,
              calculatorState: calculatorState,
              buttonService: buttonService,
            ),
          ),
          Expanded(
            child: _ButtonRow(
              labels: const ['C', '7', '8', '9', '×'],
              theme: theme,
              programmerState: programmerState,
              calculatorState: calculatorState,
              buttonService: buttonService,
            ),
          ),
          Expanded(
            child: _ButtonRow(
              labels: const ['D', '4', '5', '6', '-'],
              theme: theme,
              programmerState: programmerState,
              calculatorState: calculatorState,
              buttonService: buttonService,
            ),
          ),
          Expanded(
            child: _ButtonRow(
              labels: const ['E', '1', '2', '3', '+'],
              theme: theme,
              programmerState: programmerState,
              calculatorState: calculatorState,
              buttonService: buttonService,
            ),
          ),
          Expanded(
            child: _ButtonRow(
              labels: const ['F', '±', '0', '.', '='],
              theme: theme,
              programmerState: programmerState,
              calculatorState: calculatorState,
              buttonService: buttonService,
            ),
          ),
        ],
      ),
    );
  }
}

/// Button row widget
class _ButtonRow extends StatelessWidget {
  final List<String> labels;
  final dynamic theme;
  final ProgrammerState programmerState;
  final CalculatorState calculatorState;
  final ProgrammerButtonService buttonService;

  const _ButtonRow({
    required this.labels,
    required this.theme,
    required this.programmerState,
    required this.calculatorState,
    required this.buttonService,
  });

  CalcButtonType _getButtonType(String label) {
    if (label == '=') {
      return CalcButtonType.emphasized;
    } else if (['+', '-', '×', '÷', '%', '<<', '>>', '(', ')', 'C', 'CE'].contains(label)) {
      return CalcButtonType.operator;
    } else {
      return CalcButtonType.number;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: labels.map((label) {
        final isDisabled = buttonService.isButtonDisabled(label, programmerState);
        final labelInfo = _getLabelInfo(label, calculatorState);
        final buttonType = _getButtonType(label);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: CalcButton(
              text: labelInfo.displayLabel,
              icon: labelInfo.icon,
              type: buttonType,
              isDisabled: isDisabled,
              onPressed: isDisabled
                  ? null
                  : () => buttonService.handleButtonPress(label, programmerState),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Get label display info (text/icon)
  _LabelInfo _getLabelInfo(String label, CalculatorState calculatorState) {
    String? displayLabel = label;
    IconData? icon;

    switch (label) {
      case 'C/CE':
        // Show CE when display is not '0', otherwise show C
        displayLabel = calculatorState.display != '0' ? 'CE' : 'C';
        break;
      case 'DEL':
        icon = CalculatorIcons.backspace;
        displayLabel = null;
        break;
      case '+':
        icon = CalculatorIcons.plus;
        displayLabel = null;
        break;
      case '-':
        icon = CalculatorIcons.minus;
        displayLabel = null;
        break;
      case '×':
        icon = CalculatorIcons.multiply;
        displayLabel = null;
        break;
      case '÷':
        icon = CalculatorIcons.divide;
        displayLabel = null;
        break;
      case '=':
        icon = CalculatorIcons.equals;
        displayLabel = null;
        break;
      case '±':
        icon = CalculatorIcons.negate;
        displayLabel = null;
        break;
    }

    return _LabelInfo(displayLabel, icon);
  }
}

/// Label info class
class _LabelInfo {
  final String? displayLabel;
  final IconData? icon;

  _LabelInfo(this.displayLabel, this.icon);
}
