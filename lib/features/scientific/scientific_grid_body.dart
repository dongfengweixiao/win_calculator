import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../calculator/calculator_provider.dart';
import '../calculator/display_panel.dart';
import 'scientific_provider.dart';
import '../../shared/theme/theme_provider.dart';
import '../../shared/navigation/navigation_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_icons.dart';
import '../../core/widgets/calc_button.dart';
import 'flyouts/flyout_container.dart';
import '../../l10n/l10n.dart';

/// Scientific calculator complete body using grid layout
/// 5 columns × 12 rows
///
/// Grid structure:
/// - Row 0: Header (spans all 5 columns)
/// - Row 1: Display (spans all 5 columns)
/// - Row 2: DEG, F-E buttons (2 columns, 3 empty)
/// - Row 3: Memory buttons (MC, MR, M+, M-, MS) - spans all 5 columns
/// - Row 4: Trig, Func flyout buttons (2 columns, 3 empty)
/// - Row 5-11: Main button grid
class ScientificGridBody extends ConsumerWidget {
  /// Callback when hamburger menu button is pressed
  final VoidCallback? onMenuPressed;

  const ScientificGridBody({super.key, this.onMenuPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.read(calculatorProvider.notifier);
    final theme = ref.watch(calculatorThemeProvider);
    final isShifted = ref.watch(scientificShiftProvider);
    final showHistoryPanel = ref.watch(showHistoryPanelProvider);
    final navState = ref.watch(navigationProvider);
    final memoryCount = ref.watch(calculatorProvider).memoryCount;

    return LayoutGrid(
      // 5 equal columns
      columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr],

      // 12 rows with different heights
      rowSizes: [
        48.px,   // Row 0: Header
        2.fr,    // Row 1: Display
        40.px,   // Row 2: DEG and F-E
        40.px,   // Row 3: Memory buttons
        40.px,   // Row 4: Trig and Func flyouts
        1.fr,    // Row 5: Shift, π, e, CE/C, ⌫
        1.fr,    // Row 6: Scientific func row
        1.fr,    // Row 7: (, ), n!, ÷
        1.fr,    // Row 8: 7, 8, 9, ×
        1.fr,    // Row 9: 4, 5, 6, -
        1.fr,    // Row 10: 1, 2, 3, +
        1.fr,    // Row 11: ±, 0, ., =
      ],

      // Add gaps between columns and rows
      columnGap: 2,
      rowGap: 2,

      children: [
        // Row 0: Header (spans all 5 columns)
        _buildHeader(context, ref, theme, navState, showHistoryPanel, onMenuPressed)
            .withGridPlacement(columnStart: 0, rowStart: 0, columnSpan: 5, rowSpan: 1),

        // Row 1: Display (spans all 5 columns)
        const DisplayPanel()
            .withGridPlacement(columnStart: 0, rowStart: 1, columnSpan: 5, rowSpan: 1),

        // Row 2: DEG and F-E buttons
        _buildDEGButton(ref, calculator, theme)
            .withGridPlacement(columnStart: 0, rowStart: 2),
        _buildFEButton(ref, calculator, theme)
            .withGridPlacement(columnStart: 1, rowStart: 2),

        // Row 3: Memory buttons (spans all 5 columns, uses Row inside)
        (Container(
          color: theme.background,
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                child: CalcButton(
                  icon: CalculatorIcons.memoryClear,
                  type: CalcButtonType.memory,
                  onPressed: calculator.memoryClear,
                  isDisabled: memoryCount == 0,
                ),
              ),
              Expanded(
                child: CalcButton(
                  icon: CalculatorIcons.memoryRecall,
                  type: CalcButtonType.memory,
                  onPressed: calculator.memoryRecall,
                  isDisabled: memoryCount == 0,
                ),
              ),
              Expanded(
                child: CalcButton(
                  icon: CalculatorIcons.memoryAdd,
                  type: CalcButtonType.memory,
                  onPressed: calculator.memoryAdd,
                ),
              ),
              Expanded(
                child: CalcButton(
                  icon: CalculatorIcons.memorySubtract,
                  type: CalcButtonType.memory,
                  onPressed: calculator.memorySubtract,
                ),
              ),
              Expanded(
                child: CalcButton(
                  icon: CalculatorIcons.memoryStore,
                  type: CalcButtonType.memory,
                  onPressed: calculator.memoryStore,
                ),
              ),
              // Add M button when history panel is hidden
              if (!showHistoryPanel)
                Expanded(
                  child: CalcButton(
                    text: 'M',
                    type: CalcButtonType.memory,
                    onPressed: calculator.memoryRecall,
                    isDisabled: memoryCount == 0,
                  ),
                ),
            ],
          ),
        )).withGridPlacement(columnStart: 0, rowStart: 3, columnSpan: 5, rowSpan: 1),

        // Row 4: Trig and Func flyout buttons (horizontal layout, left aligned)
        (Container(
          color: theme.background,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              TrigFlyoutButton(
                ref: ref,
                calculator: calculator,
                theme: theme,
              ),
              const SizedBox(width: 8),
              FuncFlyoutButton(
                calculator: calculator,
                theme: theme,
              ),
            ],
          ),
        )).withGridPlacement(columnStart: 0, rowStart: 4, columnSpan: 5, rowSpan: 1),

        // Row 5: Shift, π, e, CE/C, ⌫
        _buildShiftButton(ref, theme)
            .withGridPlacement(columnStart: 0, rowStart: 5),
        _buildButton(theme, calculator, icon: CalculatorIcons.pi, type: CalcButtonType.operator, onPressed: calculator.pi)
            .withGridPlacement(columnStart: 1, rowStart: 5),
        _buildButton(theme, calculator, text: 'e', type: CalcButtonType.operator, onPressed: calculator.euler)
            .withGridPlacement(columnStart: 2, rowStart: 5),
        _buildCECButton(ref, calculator, theme)
            .withGridPlacement(columnStart: 3, rowStart: 5),
        _buildButton(theme, calculator, icon: CalculatorIcons.backspace, type: CalcButtonType.operator, onPressed: calculator.backspace)
            .withGridPlacement(columnStart: 4, rowStart: 5),

        // Row 6: Scientific functions (x², √, ^, 10^x, log) OR (x³, ∛, ʸ√x, 2^x, logᵧ)
        ..._buildScientificFunctionRow(calculator, theme, isShifted, rowStart: 6),

        // Row 7: (, ), n!, ÷
        _buildButton(theme, calculator, text: '(', type: CalcButtonType.operator, onPressed: calculator.openParen)
            .withGridPlacement(columnStart: 0, rowStart: 7),
        _buildButton(theme, calculator, text: ')', type: CalcButtonType.operator, onPressed: calculator.closeParen)
            .withGridPlacement(columnStart: 1, rowStart: 7),
        _buildButton(theme, calculator, icon: CalculatorIcons.factorial, type: CalcButtonType.operator, onPressed: calculator.factorial)
            .withGridPlacement(columnStart: 2, rowStart: 7),
        _buildButton(theme, calculator, icon: CalculatorIcons.divide, type: CalcButtonType.operator, onPressed: calculator.divide)
            .withGridPlacement(columnStart: 3, rowStart: 7),
        _buildButton(theme, calculator, icon: CalculatorIcons.modulo, type: CalcButtonType.operator, onPressed: calculator.mod)
            .withGridPlacement(columnStart: 4, rowStart: 7),

        // Row 8: 7, 8, 9, ×
        _buildButton(theme, calculator, text: '7', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(7))
            .withGridPlacement(columnStart: 0, rowStart: 8),
        _buildButton(theme, calculator, text: '8', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(8))
            .withGridPlacement(columnStart: 1, rowStart: 8),
        _buildButton(theme, calculator, text: '9', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(9))
            .withGridPlacement(columnStart: 2, rowStart: 8),
        _buildButton(theme, calculator, icon: CalculatorIcons.multiply, type: CalcButtonType.operator, onPressed: calculator.multiply)
            .withGridPlacement(columnStart: 3, rowStart: 8),
        _buildButton(theme, calculator, text: 'ln', type: CalcButtonType.operator, onPressed: calculator.ln)
            .withGridPlacement(columnStart: 4, rowStart: 8),

        // Row 9: 4, 5, 6, -
        _buildButton(theme, calculator, text: '4', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(4))
            .withGridPlacement(columnStart: 0, rowStart: 9),
        _buildButton(theme, calculator, text: '5', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(5))
            .withGridPlacement(columnStart: 1, rowStart: 9),
        _buildButton(theme, calculator, text: '6', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(6))
            .withGridPlacement(columnStart: 2, rowStart: 9),
        _buildButton(theme, calculator, icon: CalculatorIcons.minus, type: CalcButtonType.operator, onPressed: calculator.subtract)
            .withGridPlacement(columnStart: 3, rowStart: 9),
        _buildButton(theme, calculator, icon: CalculatorIcons.powerOfE, type: CalcButtonType.operator, onPressed: calculator.powE)
            .withGridPlacement(columnStart: 4, rowStart: 9),

        // Row 10: 1, 2, 3, +
        _buildButton(theme, calculator, text: '1', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(1))
            .withGridPlacement(columnStart: 0, rowStart: 10),
        _buildButton(theme, calculator, text: '2', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(2))
            .withGridPlacement(columnStart: 1, rowStart: 10),
        _buildButton(theme, calculator, text: '3', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(3))
            .withGridPlacement(columnStart: 2, rowStart: 10),
        _buildButton(theme, calculator, icon: CalculatorIcons.plus, type: CalcButtonType.operator, onPressed: calculator.add)
            .withGridPlacement(columnStart: 3, rowStart: 10),
        _buildButton(theme, calculator, text: 'exp', type: CalcButtonType.operator, onPressed: calculator.exp)
            .withGridPlacement(columnStart: 4, rowStart: 10),

        // Row 11: ±, 0, ., =
        _buildButton(theme, calculator, icon: CalculatorIcons.negate, type: CalcButtonType.number, onPressed: calculator.inputNegate)
            .withGridPlacement(columnStart: 0, rowStart: 11),
        _buildButton(theme, calculator, text: '0', type: CalcButtonType.number, onPressed: () => calculator.inputDigit(0))
            .withGridPlacement(columnStart: 1, rowStart: 11),
        _buildButton(theme, calculator, text: '.', type: CalcButtonType.number, onPressed: calculator.inputDecimal)
            .withGridPlacement(columnStart: 2, rowStart: 11),
        _buildButton(theme, calculator, icon: CalculatorIcons.equals, type: CalcButtonType.emphasized, onPressed: calculator.equals)
            .withGridPlacement(columnStart: 3, rowStart: 11),
        _buildButton(theme, calculator, icon: CalculatorIcons.reciprocal, type: CalcButtonType.operator, onPressed: calculator.reciprocal)
            .withGridPlacement(columnStart: 4, rowStart: 11),
      ],
    );
  }

  /// Build a list of widgets for scientific function row (5 buttons)
  /// Returns widgets for column 0-4 at the specified row
  List<Widget> _buildScientificFunctionRow(
    CalculatorNotifier calculator,
    CalculatorTheme theme,
    bool isShifted, {
    required int rowStart,
  }) {
    if (!isShifted) {
      // Normal mode: x², √, ^, 10^x, log
      return [
        _buildButton(theme, calculator, icon: CalculatorIcons.square, type: CalcButtonType.operator, onPressed: calculator.square)
            .withGridPlacement(columnStart: 0, rowStart: rowStart),
        _buildButton(theme, calculator, icon: CalculatorIcons.squareRoot, type: CalcButtonType.operator, onPressed: calculator.squareRoot)
            .withGridPlacement(columnStart: 1, rowStart: rowStart),
        _buildButton(theme, calculator, icon: CalculatorIcons.power, type: CalcButtonType.operator, onPressed: calculator.power)
            .withGridPlacement(columnStart: 2, rowStart: rowStart),
        _buildButton(theme, calculator, icon: CalculatorIcons.powerOf10, type: CalcButtonType.operator, onPressed: calculator.pow10)
            .withGridPlacement(columnStart: 3, rowStart: rowStart),
        _buildButton(theme, calculator, text: 'log', type: CalcButtonType.operator, onPressed: calculator.log)
            .withGridPlacement(columnStart: 4, rowStart: rowStart),
      ];
    } else {
      // Shift mode: x³, ∛, ʸ√x, 2^x, logᵧ
      return [
        _buildButton(theme, calculator, icon: CalculatorIcons.cube, type: CalcButtonType.operator, onPressed: calculator.cube)
            .withGridPlacement(columnStart: 0, rowStart: rowStart),
        _buildButton(theme, calculator, icon: CalculatorIcons.cubeRoot, type: CalcButtonType.operator, onPressed: calculator.cubeRoot)
            .withGridPlacement(columnStart: 1, rowStart: rowStart),
        _buildButton(theme, calculator, icon: CalculatorIcons.yRoot, type: CalcButtonType.operator, onPressed: calculator.yRoot)
            .withGridPlacement(columnStart: 2, rowStart: rowStart),
        _buildButton(theme, calculator, icon: CalculatorIcons.powerOf2, type: CalcButtonType.operator, onPressed: calculator.pow2)
            .withGridPlacement(columnStart: 3, rowStart: rowStart),
        _buildButton(theme, calculator, text: 'logᵧ', type: CalcButtonType.operator, onPressed: calculator.logBaseY)
            .withGridPlacement(columnStart: 4, rowStart: rowStart),
      ];
    }
  }

  /// Build DEG button
  Widget _buildDEGButton(
    WidgetRef ref,
    CalculatorNotifier calculator,
    CalculatorTheme theme,
  ) {
    final scientificState = ref.watch(scientificProvider);

    return CalcButton(
      text: scientificState.angleType.label,
      onPressed: () {
        final notifier = ref.read(scientificProvider.notifier);
        notifier.toggleAngleType();
        calculator.setAngleType(scientificState.angleType.value);
      },
      type: CalcButtonType.function,
    );
  }

  /// Build F-E toggle button
  Widget _buildFEButton(
    WidgetRef ref,
    CalculatorNotifier calculator,
    CalculatorTheme theme,
  ) {
    final scientificState = ref.watch(scientificProvider);

    return CalcButton(
      text: 'F-E',
      onPressed: () {
        final notifier = ref.read(scientificProvider.notifier);
        notifier.toggleFE();
        calculator.toggleFE();
      },
      type: scientificState.isFEChecked ? CalcButtonType.emphasized : CalcButtonType.function,
    );
  }

  /// Build Shift toggle button
  Widget _buildShiftButton(
    WidgetRef ref,
    CalculatorTheme theme,
  ) {
    final isShifted = ref.watch(scientificShiftProvider);

    return CalcButton(
      icon: CalculatorIcons.shift,
      onPressed: () {
        ref.read(scientificShiftProvider.notifier).toggle();
      },
      type: isShifted ? CalcButtonType.emphasized : CalcButtonType.operator,
    );
  }

  /// Build CE/C button (shared position, shows CE when there's input)
  Widget _buildCECButton(
    WidgetRef ref,
    CalculatorNotifier calculator,
    CalculatorTheme theme,
  ) {
    final calcState = ref.watch(calculatorProvider);
    final showCE = calcState.display != '0' || calcState.expression.isNotEmpty;

    return CalcButton(
      text: showCE ? 'CE' : 'C',
      onPressed: showCE ? calculator.clearEntry : calculator.clear,
      type: CalcButtonType.operator,
    );
  }

  /// Build header widget
  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    CalculatorTheme theme,
    navState,
    bool showHistoryPanel,
    VoidCallback? onMenuPressed,
  ) {
    return Container(
      height: 48,
      color: theme.background,
      child: Row(
        children: [
          // Hamburger button and mode name
          _buildHamburgerButton(context, ref, theme, onMenuPressed),

          const Spacer(),

          // History button (only when panel is hidden)
          if (!showHistoryPanel)
            _HeaderButton(
              icon: Icons.history,
              theme: theme,
              onPressed: () {
                // TODO: Show bottom history sheet
              },
            ),

          // Theme toggle button
          _HeaderButton(
            icon: theme.brightness == Brightness.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            theme: theme,
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
    );
  }

  /// Build hamburger button with mode name
  Widget _buildHamburgerButton(
    BuildContext context,
    WidgetRef ref,
    CalculatorTheme theme,
    VoidCallback? onMenuPressed,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onMenuPressed,
        child: Container(
          height: 48,
          padding: const EdgeInsets.only(left: 8, right: 16),
          color: theme.background,
          child: Row(
            children: [
              // Hamburger button
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Icon(
                  Icons.menu,
                  color: theme.textPrimary,
                  size: 20,
                ),
              ),

              // Mode name
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  _getModeDisplayName(context),
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get mode display name
  String _getModeDisplayName(BuildContext context) {
    final l10n = context.l10n;
    return l10n.scientificMode;
  }

  /// Helper to build a CalcButton
  Widget _buildButton(
    CalculatorTheme theme,
    CalculatorNotifier calculator, {
    String? text,
    IconData? icon,
    CalcButtonType type = CalcButtonType.number,
    VoidCallback? onPressed,
  }) {
    return CalcButton(
      text: text,
      icon: icon,
      type: type,
      onPressed: onPressed,
    );
  }
}

/// Header button widget
class _HeaderButton extends StatefulWidget {
  final IconData icon;
  final dynamic theme;
  final VoidCallback onPressed;

  const _HeaderButton({
    required this.icon,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_HeaderButton> createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<_HeaderButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.theme.textPrimary.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(widget.icon, color: widget.theme.textSecondary, size: 18),
        ),
      ),
    );
  }
}
