import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../calculator/calculator_provider.dart';
import 'scientific_provider.dart';
import '../../shared/theme/theme_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_icons.dart';
import '../../core/widgets/calc_button.dart';
import 'flyouts/flyout_container.dart';

/// Scientific calculator button panel - Microsoft Calculator layout
/// Grid: 5 columns × 10 rows
class ScientificButtonPanelLayout extends ConsumerWidget {
  const ScientificButtonPanelLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.read(calculatorProvider.notifier);
    final theme = ref.watch(calculatorThemeProvider);
    final isShifted = ref.watch(scientificShiftProvider);

    return Container(
      color: theme.background,
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          // Row 0: DEG and F-E buttons
          Expanded(flex: 1, child: _buildAngleAndFERow(ref, calculator, theme)),

          // Row 1: Memory buttons (MC, MR, M+, M-, MS, M)
          Expanded(flex: 1, child: _buildMemoryButtonsRow(calculator, theme)),

          // Row 2: Operator Panel - Trig and Func buttons
          Expanded(
            flex: 1,
            child: _buildOperatorPanelRow(ref, calculator, theme),
          ),

          // Row 3: Shift, π, e, CE/C, ⌫
          Expanded(flex: 1, child: _buildRow1(ref, calculator, theme)),

          // Rows 4-9: Main grid with scientific functions, operators, and number pad
          Expanded(
            flex: 6,
            child: _buildMainGrid(ref, calculator, theme, isShifted),
          ),
        ],
      ),
    );
  }

  /// Build a toggleable button with visual feedback for selected state
  Widget _buildToggleableButton({
    String? text,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    // Use different button type based on selection state
    // This provides visual feedback without needing to wrap CalcButton
    return CalcButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      type: isSelected ? CalcButtonType.emphasized : CalcButtonType.operator,
    );
  }

  /// Row 1: Operator Panel - Trig and Func flyout buttons
  Widget _buildOperatorPanelRow(
    WidgetRef ref,
    CalculatorNotifier calculator,
    CalculatorTheme theme,
  ) {
    return Row(
      children: [
        // Trig flyout
        Expanded(
          child: TrigFlyoutButton(
            ref: ref,
            calculator: calculator,
            theme: theme,
          ),
        ),
        const SizedBox(width: 2),
        // Func flyout
        Expanded(
          child: FuncFlyoutButton(calculator: calculator, theme: theme),
        ),
        const SizedBox(width: 2),
        // Empty space (3 columns to align with row 1)
        const Expanded(child: SizedBox()),
        const SizedBox(width: 2),
        const Expanded(child: SizedBox()),
        const SizedBox(width: 2),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  /// Row 2: Shift, π, e, CE/C, ⌫
  /// Note: CE and C share the same position (like Microsoft Calculator)
  Widget _buildRow1(
    WidgetRef ref,
    CalculatorNotifier calculator,
    CalculatorTheme theme,
  ) {
    final isShifted = ref.watch(scientificShiftProvider);
    final calcState = ref.watch(calculatorProvider);
    // Show CE when there's input, show C when display is just "0"
    final showCE = calcState.display != '0' || calcState.expression.isNotEmpty;

    return Row(
      children: [
        // Shift button (2nd)
        _buildToggleableButton(
          icon: CalculatorIcons.shift,
          isSelected: isShifted,
          onPressed: () {
            ref.read(scientificShiftProvider.notifier).toggle();
          },
        ),
        // π
        CalcButton(
          icon: CalculatorIcons.pi,
          onPressed: calculator.pi,
          type: CalcButtonType.operator,
        ),
        // e (Euler) - uses text, not icon
        CalcButton(
          text: 'e',
          onPressed: calculator.euler,
          type: CalcButtonType.operator,
        ),
        // CE or C (shared position)
        CalcButton(
          text: showCE ? 'CE' : 'C',
          onPressed: showCE ? calculator.clearEntry : calculator.clear,
          type: CalcButtonType.operator,
        ),
        // Backspace
        CalcButton(
          icon: CalculatorIcons.backspace,
          onPressed: calculator.backspace,
          type: CalcButtonType.operator,
        ),
      ],
    );
  }

  /// Row 0: DEG and F-E buttons
  Widget _buildAngleAndFERow(
    WidgetRef ref,
    CalculatorNotifier calculator,
    CalculatorTheme theme,
  ) {
    final scientificState = ref.watch(scientificProvider);

    return Row(
      children: [
        // DEG button (cycles through DEG/RAD/GRAD)
        CalcButton(
          text: scientificState.angleType.label,
          onPressed: () {
            final notifier = ref.read(scientificProvider.notifier);
            notifier.toggleAngleType();
            calculator.setAngleType(scientificState.angleType.value);
          },
          type: CalcButtonType.operator,
        ),
        const SizedBox(width: 2),
        // F-E button (toggle scientific notation)
        _buildToggleableButton(
          text: 'F-E',
          isSelected: scientificState.isFEChecked,
          onPressed: () {
            final notifier = ref.read(scientificProvider.notifier);
            notifier.toggleFE();
            calculator.toggleFE();
          },
        ),
        const SizedBox(width: 2),
        // Empty space (3 columns to align with memory row)
        const Expanded(child: SizedBox()),
        const SizedBox(width: 2),
        const Expanded(child: SizedBox()),
        const SizedBox(width: 2),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  /// Row 1: Memory buttons (MC, MR, M+, M-, MS, M)
  Widget _buildMemoryButtonsRow(
    CalculatorNotifier calculator,
    CalculatorTheme theme,
  ) {
    return Row(
      children: [
        // MC (Memory Clear)
        CalcButton(
          icon: CalculatorIcons.memoryClear,
          type: CalcButtonType.memory,
          onPressed: calculator.memoryClear,
        ),
        const SizedBox(width: 2),
        // MR (Memory Recall)
        CalcButton(
          icon: CalculatorIcons.memoryRecall,
          type: CalcButtonType.memory,
          onPressed: calculator.memoryRecall,
        ),
        const SizedBox(width: 2),
        // M+ (Memory Add)
        CalcButton(
          icon: CalculatorIcons.memoryAdd,
          type: CalcButtonType.memory,
          onPressed: calculator.memoryAdd,
        ),
        const SizedBox(width: 2),
        // M- (Memory Subtract)
        CalcButton(
          icon: CalculatorIcons.memorySubtract,
          type: CalcButtonType.memory,
          onPressed: calculator.memorySubtract,
        ),
        const SizedBox(width: 2),
        // MS (Memory Store)
        CalcButton(
          icon: CalculatorIcons.memoryStore,
          type: CalcButtonType.memory,
          onPressed: calculator.memoryStore,
        ),
      ],
    );
  }

  /// Main grid: Rows 3-8
  /// Col 0: Scientific functions (vertical strip) - 1 column
  /// Col 1-4: Middle section (operators + number pad + operators) - 4 columns total
  ///   - Row 3: 1/x, |x|, exp, mod (spans all 4 columns)
  ///   - Rows 4-8: Buttons in columns 1-3, operators in column 4
  Widget _buildMainGrid(
    WidgetRef ref,
    CalculatorNotifier calculator,
    CalculatorTheme theme,
    bool isShifted,
  ) {
    return Row(
      children: [
        // Column 0: Scientific functions (x², √, ^, 10^x, log, ln)
        Expanded(
          child: _buildScientificFunctionsColumn(calculator, theme, isShifted),
        ),

        // Columns 1-4: Middle section (operators + number pad + standard operators)
        Expanded(
          flex: 4,
          child: _buildMiddleSectionWithOperators(calculator, theme),
        ),
      ],
    );
  }

  /// Column 0: Scientific functions vertical strip
  Widget _buildScientificFunctionsColumn(
    CalculatorNotifier calculator,
    CalculatorTheme theme,
    bool isShifted,
  ) {
    if (!isShifted) {
      return Column(
        children: [
          Expanded(
            child: CalcButton(
              icon: CalculatorIcons.square,
              type: CalcButtonType.operator,
              onPressed: calculator.square,
            ),
          ),
          Expanded(
            child: CalcButton(
              icon: CalculatorIcons.squareRoot,
              type: CalcButtonType.operator,
              onPressed: calculator.squareRoot,
            ),
          ),
          Expanded(
            child: CalcButton(
              icon: CalculatorIcons.power,
              type: CalcButtonType.operator,
              onPressed: calculator.power,
            ),
          ),
          Expanded(
            child: CalcButton(
              icon: CalculatorIcons.powerOf10,
              type: CalcButtonType.operator,
              onPressed: calculator.pow10,
            ),
          ),
          Expanded(
            child: CalcButton(
              text: 'log',
              type: CalcButtonType.operator,
              onPressed: calculator.log,
            ),
          ),
          Expanded(
            child: CalcButton(
              text: 'ln',
              type: CalcButtonType.operator,
              onPressed: calculator.ln,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: CalcButton(
              icon: CalculatorIcons.cube,
              type: CalcButtonType.operator,
              onPressed: calculator.cube,
            ),
          ),
          Expanded(
            child: CalcButton(
              icon: CalculatorIcons.cubeRoot,
              type: CalcButtonType.operator,
              onPressed: calculator.cubeRoot,
            ),
          ),
          Expanded(
            child: CalcButton(
              icon: CalculatorIcons.yRoot,
              type: CalcButtonType.operator,
              onPressed: calculator.yRoot,
            ),
          ),
          Expanded(
            child: CalcButton(
              icon: CalculatorIcons.powerOf2,
              type: CalcButtonType.operator,
              onPressed: calculator.pow2,
            ),
          ),
          Expanded(
            child: CalcButton(
              text: 'logᵧ',
              type: CalcButtonType.operator,
              onPressed: calculator.logBaseY,
            ),
          ),
          Expanded(
            child: CalcButton(
              icon: CalculatorIcons.powerOfE,
              type: CalcButtonType.operator,
              onPressed: calculator.powE,
            ),
          ),
        ],
      );
    }
  }

  /// Middle section: Rows 2-7, Columns 1-4 with standard operators in column 4
  /// Important: All columns have equal width (1:1:1:1 ratio)
  Widget _buildMiddleSectionWithOperators(
    CalculatorNotifier calculator,
    CalculatorTheme theme,
  ) {
    return Column(
      children: [
        // Row 2: 1/x, |x|, exp, mod (4 buttons, all 4 columns)
        Expanded(
          child: Row(
            children: [
              CalcButton(
                icon: CalculatorIcons.reciprocal,
                onPressed: calculator.reciprocal,
                type: CalcButtonType.operator,
              ),
              CalcButton(
                icon: CalculatorIcons.absoluteValue,
                onPressed: calculator.abs,
                type: CalcButtonType.operator,
              ),
              CalcButton(
                text: 'exp',
                onPressed: calculator.exp,
                type: CalcButtonType.operator,
              ),
              CalcButton(
                text: 'mod',
                onPressed: calculator.mod,
                type: CalcButtonType.operator,
              ),
            ],
          ),
        ),

        // Row 3: (, ), n!, ÷
        Expanded(
          child: Row(
            children: [
              CalcButton(
                text: '(',
                onPressed: calculator.openParen,
                type: CalcButtonType.operator,
              ),
              CalcButton(
                text: ')',
                onPressed: calculator.closeParen,
                type: CalcButtonType.operator,
              ),
              CalcButton(
                icon: CalculatorIcons.factorial,
                onPressed: calculator.factorial,
                type: CalcButtonType.operator,
              ),
              CalcButton(
                icon: CalculatorIcons.divide,
                onPressed: calculator.divide,
                type: CalcButtonType.operator,
              ),
            ],
          ),
        ),

        // Row 4: 7, 8, 9, ×
        Expanded(
          child: Row(
            children: [
              CalcButton(
                text: '7',
                onPressed: () => calculator.inputDigit(7),
              ),
              CalcButton(
                text: '8',
                onPressed: () => calculator.inputDigit(8),
              ),
              CalcButton(
                text: '9',
                onPressed: () => calculator.inputDigit(9),
              ),
              CalcButton(
                icon: CalculatorIcons.multiply,
                onPressed: calculator.multiply,
                type: CalcButtonType.operator,
              ),
            ],
          ),
        ),

        // Row 5: 4, 5, 6, -
        Expanded(
          child: Row(
            children: [
              CalcButton(
                text: '4',
                onPressed: () => calculator.inputDigit(4),
              ),
              CalcButton(
                text: '5',
                onPressed: () => calculator.inputDigit(5),
              ),
              CalcButton(
                text: '6',
                onPressed: () => calculator.inputDigit(6),
              ),
              CalcButton(
                icon: CalculatorIcons.minus,
                onPressed: calculator.subtract,
                type: CalcButtonType.operator,
              ),
            ],
          ),
        ),

        // Row 6: 1, 2, 3, +
        Expanded(
          child: Row(
            children: [
              CalcButton(
                text: '1',
                onPressed: () => calculator.inputDigit(1),
              ),
              CalcButton(
                text: '2',
                onPressed: () => calculator.inputDigit(2),
              ),
              CalcButton(
                text: '3',
                onPressed: () => calculator.inputDigit(3),
              ),
              CalcButton(
                icon: CalculatorIcons.plus,
                onPressed: calculator.add,
                type: CalcButtonType.operator,
              ),
            ],
          ),
        ),

        // Row 7: ±, 0, ., =
        Expanded(
          child: Row(
            children: [
              CalcButton(
                icon: CalculatorIcons.negate,
                onPressed: calculator.inputNegate,
                type: CalcButtonType.number,
              ),
              CalcButton(
                text: '0',
                onPressed: () => calculator.inputDigit(0),
              ),
              CalcButton(
                text: '.',
                onPressed: calculator.inputDecimal,
              ),
              CalcButton(
                icon: CalculatorIcons.equals,
                onPressed: calculator.equals,
                type: CalcButtonType.emphasized,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
