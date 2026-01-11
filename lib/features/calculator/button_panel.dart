import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'calculator_provider.dart';
import '../../shared/theme/theme_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_font_sizes.dart';
import '../../core/theme/app_icons.dart';
import '../../core/widgets/calc_button.dart';

/// Standard calculator button panel
class StandardButtonPanel extends ConsumerWidget {
  const StandardButtonPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.read(calculatorProvider.notifier);
    final theme = ref.watch(calculatorThemeProvider);

    return Container(
      color: theme.background,
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          // Memory row
          _buildMemoryRow(calculator),

          // Clear row: %, CE, C, ⌫
          _buildClearRow(calculator),

          // Function row: 1/x, x², √x, ÷
          _buildFunctionRow(calculator),

          // Number rows
          Expanded(child: _buildNumberRow7(calculator)),
          Expanded(child: _buildNumberRow4(calculator)),
          Expanded(child: _buildNumberRow1(calculator)),
          Expanded(child: _buildLastRow(calculator)),
        ],
      ),
    );
  }

  Widget _buildMemoryRow(CalculatorNotifier calculator) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          CalcButton(
            text: 'MC',
            type: CalcButtonType.memory,
            onPressed: calculator.memoryClear,
          ),
          CalcButton(
            text: 'MR',
            type: CalcButtonType.memory,
            onPressed: calculator.memoryRecall,
          ),
          CalcButton(
            text: 'M+',
            type: CalcButtonType.memory,
            onPressed: calculator.memoryAdd,
          ),
          CalcButton(
            text: 'M-',
            type: CalcButtonType.memory,
            onPressed: calculator.memorySubtract,
          ),
          CalcButton(
            text: 'MS',
            type: CalcButtonType.memory,
            onPressed: calculator.memoryStore,
          ),
        ],
      ),
    );
  }

  Widget _buildClearRow(CalculatorNotifier calculator) {
    return Expanded(
      child: Row(
        children: [
          CalcButton(
            icon: CalculatorIcons.percent,
            type: CalcButtonType.operator,
            onPressed: calculator.percent,
          ),
          CalcButton(
            text: 'CE',
            type: CalcButtonType.operator,
            fontSize: CalculatorFontSizes.numeric16,
            onPressed: calculator.clearEntry,
          ),
          CalcButton(
            text: 'C',
            type: CalcButtonType.operator,
            fontSize: CalculatorFontSizes.numeric16,
            onPressed: calculator.clear,
          ),
          CalcButton(
            icon: CalculatorIcons.backspace,
            type: CalcButtonType.operator,
            onPressed: calculator.backspace,
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionRow(CalculatorNotifier calculator) {
    return Expanded(
      child: Row(
        children: [
          CalcButton(
            icon: CalculatorIcons.reciprocal,
            type: CalcButtonType.operator,
            onPressed: calculator.reciprocal,
          ),
          CalcButton(
            icon: CalculatorIcons.square,
            type: CalcButtonType.operator,
            onPressed: calculator.square,
          ),
          CalcButton(
            icon: CalculatorIcons.squareRoot,
            type: CalcButtonType.operator,
            onPressed: calculator.squareRoot,
          ),
          CalcButton(
            icon: CalculatorIcons.divide,
            type: CalcButtonType.operator,
            onPressed: calculator.divide,
          ),
        ],
      ),
    );
  }

  Widget _buildNumberRow7(CalculatorNotifier calculator) {
    return Row(
      children: [
        CalcButton(
          text: '7',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(7),
        ),
        CalcButton(
          text: '8',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(8),
        ),
        CalcButton(
          text: '9',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(9),
        ),
        CalcButton(
          icon: CalculatorIcons.multiply,
          type: CalcButtonType.operator,
          onPressed: calculator.multiply,
        ),
      ],
    );
  }

  Widget _buildNumberRow4(CalculatorNotifier calculator) {
    return Row(
      children: [
        CalcButton(
          text: '4',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(4),
        ),
        CalcButton(
          text: '5',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(5),
        ),
        CalcButton(
          text: '6',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(6),
        ),
        CalcButton(
          icon: CalculatorIcons.minus,
          type: CalcButtonType.operator,
          onPressed: calculator.subtract,
        ),
      ],
    );
  }

  Widget _buildNumberRow1(CalculatorNotifier calculator) {
    return Row(
      children: [
        CalcButton(
          text: '1',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(1),
        ),
        CalcButton(
          text: '2',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(2),
        ),
        CalcButton(
          text: '3',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(3),
        ),
        CalcButton(
          icon: CalculatorIcons.plus,
          type: CalcButtonType.operator,
          onPressed: calculator.add,
        ),
      ],
    );
  }

  Widget _buildLastRow(CalculatorNotifier calculator) {
    return Row(
      children: [
        CalcButton(
          icon: CalculatorIcons.negate,
          type: CalcButtonType.number,
          onPressed: calculator.inputNegate,
        ),
        CalcButton(
          text: '0',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(0),
        ),
        CalcButton(
          text: '.',
          type: CalcButtonType.number,
          onPressed: calculator.inputDecimal,
        ),
        CalcButton(
          icon: CalculatorIcons.equals,
          type: CalcButtonType.emphasized,
          onPressed: calculator.equals,
        ),
      ],
    );
  }
}
