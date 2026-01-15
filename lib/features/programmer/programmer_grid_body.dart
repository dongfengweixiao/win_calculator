import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../calculator/calculator_provider.dart';
import '../calculator/display_panel.dart';
import '../../shared/theme/theme_provider.dart';
import '../../shared/navigation/navigation_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_icons.dart';
import '../../core/widgets/calc_button.dart';
import '../../core/domain/entities/view_mode.dart';
import 'programmer_provider.dart';
import 'services/programmer_button_service.dart';
import 'flyouts/bitwise_flyout.dart';
import 'flyouts/shift_flyout.dart';
import '../../l10n/l10n.dart';

/// Programmer calculator complete body using grid layout
/// 5 columns × 14 rows
///
/// Grid structure:
/// - Row 0: Header (spans all 5 columns)
/// - Row 1: Display (spans all 5 columns)
/// - Row 2: HEX button (spans all 5 columns)
/// - Row 3: DEC button (spans all 5 columns)
/// - Row 4: OCT button (spans all 5 columns)
/// - Row 5: BIN button (spans all 5 columns)
/// - Row 6: Control buttons (spans all 5 columns, horizontal layout)
/// - Row 7: Bitwise and Shift flyout buttons (2 columns, 3 empty)
/// - Row 8-13: Main button grid
class ProgrammerGridBody extends ConsumerWidget {
  /// Callback when hamburger menu button is pressed
  final VoidCallback? onMenuPressed;

  const ProgrammerGridBody({super.key, this.onMenuPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(calculatorThemeProvider);
    final programmerState = ref.watch(programmerProvider);
    final calculatorState = ref.watch(calculatorProvider);
    final buttonService = ProgrammerButtonService(ref);
    final showHistoryPanel = ref.watch(showHistoryPanelProvider);
    final navState = ref.watch(navigationProvider);

    // Initialize radix when switching to programmer mode
    ref.listen<NavigationState>(navigationProvider, (previous, next) {
      final previousMode = previous?.currentMode;
      final currentMode = next.currentMode;

      // When switching to programmer mode, initialize radix
      if (currentMode == ViewMode.programmer && previousMode != ViewMode.programmer) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(programmerProvider.notifier).initialize();
        });
      }
    });

    // Also initialize if currently in programmer mode (app startup case)
    if (navState.currentMode == ViewMode.programmer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(programmerProvider.notifier).initialize();
      });
    }

    // Listen to calculator state changes and update programmer display values
    // This ensures that when users input numbers, all base displays are synchronized
    ref.listen<CalculatorState>(calculatorProvider, (previous, next) {
      // Only update when in programmer mode and display value changed
      if (navState.currentMode == ViewMode.programmer &&
          previous?.display != next.display) {
        ref.read(programmerProvider.notifier).updateValuesFromCalculator();
      }
    });

    return LayoutGrid(
      // 5 equal columns
      columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr],

      // 14 rows with different heights
      rowSizes: [
        48.px,   // Row 0: Header
        2.fr,    // Row 1: Display
        40.px,   // Row 2: HEX
        40.px,   // Row 3: DEC
        40.px,   // Row 4: OCT
        40.px,   // Row 5: BIN
        40.px,   // Row 6: Control buttons
        40.px,   // Row 7: Bitwise and Shift flyouts
        1.fr,    // Row 8: A, <<, >>, C/CE, DEL
        1.fr,    // Row 9: B, (, ), %, ÷
        1.fr,    // Row 10: C, 7, 8, 9, ×
        1.fr,    // Row 11: D, 4, 5, 6, -
        1.fr,    // Row 12: E, 1, 2, 3, +
        1.fr,    // Row 13: F, ±, 0, ., =
      ],

      // Add gaps between columns and rows
      columnGap: 2,
      rowGap: 2,

      children: [
        // Row 0: Header (spans all 5 columns)
        _buildHeader(context, ref, theme, navState, onMenuPressed)
            .withGridPlacement(columnStart: 0, rowStart: 0, columnSpan: 5, rowSpan: 1),

        // Row 1: Display (spans all 5 columns)
        const DisplayPanel()
            .withGridPlacement(columnStart: 0, rowStart: 1, columnSpan: 5, rowSpan: 1),

        // Row 2: HEX button
        _buildBaseButton(
          context,
          'HEX',
          programmerState.hexValue,
          programmerState.currentBase == ProgrammerBase.hex,
          theme,
          () => _handleBaseSelected(ref, ProgrammerBase.hex),
        ).withGridPlacement(columnStart: 0, rowStart: 2, columnSpan: 5, rowSpan: 1),

        // Row 3: DEC button
        _buildBaseButton(
          context,
          'DEC',
          programmerState.decValue,
          programmerState.currentBase == ProgrammerBase.dec,
          theme,
          () => _handleBaseSelected(ref, ProgrammerBase.dec),
        ).withGridPlacement(columnStart: 0, rowStart: 3, columnSpan: 5, rowSpan: 1),

        // Row 4: OCT button
        _buildBaseButton(
          context,
          'OCT',
          programmerState.octValue,
          programmerState.currentBase == ProgrammerBase.oct,
          theme,
          () => _handleBaseSelected(ref, ProgrammerBase.oct),
        ).withGridPlacement(columnStart: 0, rowStart: 4, columnSpan: 5, rowSpan: 1),

        // Row 5: BIN button
        _buildBinButton(
          context,
          'BIN',
          programmerState.binValue,
          programmerState.currentBase == ProgrammerBase.bin,
          theme,
          () => _handleBaseSelected(ref, ProgrammerBase.bin),
        ).withGridPlacement(columnStart: 0, rowStart: 5, columnSpan: 5, rowSpan: 1),

        // Row 6: Control buttons (spans all 5 columns, horizontal layout)
        (Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.background,
            border: Border(
              top: BorderSide(color: theme.divider, width: 1),
              bottom: BorderSide(color: theme.divider, width: 1),
            ),
          ),
          child: Row(
            children: [
              // Full keypad button
              Expanded(
                child: _ControlButton(
                  icon: CalculatorIcons.fullKeypad,
                  tooltip: '全键盘',
                  isSelected: programmerState.inputMode == ProgrammerInputMode.fullKeypad,
                  theme: theme,
                  onTap: () => ref.read(programmerProvider.notifier).toggleInputMode(),
                ),
              ),
              const SizedBox(width: 8),
              // Bit flip button
              Expanded(
                child: _ControlButton(
                  icon: CalculatorIcons.bitFlip,
                  tooltip: '位翻转',
                  isSelected: programmerState.inputMode == ProgrammerInputMode.bitFlip,
                  theme: theme,
                  onTap: () => ref.read(programmerProvider.notifier).toggleInputMode(),
                ),
              ),
              const SizedBox(width: 8),
              // Word size button
              Expanded(
                child: _ControlButton(
                  label: programmerState.wordSize.label,
                  isSelected: false,
                  theme: theme,
                  onTap: () => ref.read(programmerProvider.notifier).cycleWordSize(),
                ),
              ),
              const SizedBox(width: 8),
              // MS button
              Expanded(
                child: _ControlButton(
                  label: 'MS',
                  isSelected: false,
                  theme: theme,
                  onTap: () {
                    final calculator = ref.read(calculatorProvider.notifier);
                    calculator.memoryStore();
                  },
                ),
              ),
              // Add M button when history panel is hidden
              if (!showHistoryPanel) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: _ControlButton(
                    label: 'M',
                    isSelected: false,
                    theme: theme,
                    onTap: () {
                      final calculator = ref.read(calculatorProvider.notifier);
                      calculator.memoryRecall();
                    },
                  ),
                ),
              ],
            ],
          ),
        )).withGridPlacement(columnStart: 0, rowStart: 6, columnSpan: 5, rowSpan: 1),

        // Row 7: Bitwise and Shift flyout buttons (horizontal layout, left aligned)
        (Container(
          color: theme.background,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              BitwiseFlyoutButton(
                programmer: ref.read(programmerProvider.notifier),
                theme: theme,
              ),
              const SizedBox(width: 8),
              ShiftFlyoutButton(
                programmer: ref.read(programmerProvider.notifier),
                theme: theme,
                currentMode: programmerState.shiftMode,
              ),
            ],
          ),
        )).withGridPlacement(columnStart: 0, rowStart: 7, columnSpan: 5, rowSpan: 1),

        // Row 8-13: Full keypad OR bit flip grid based on input mode
        ..._buildFullKeypad(
          ref,
          theme,
          programmerState,
          calculatorState,
          buttonService,
        ),

        // Bit flip grid (spans rows 8-13)
        if (programmerState.inputMode == ProgrammerInputMode.bitFlip)
          _buildBitFlipGrid(ref, theme, programmerState)
              .withGridPlacement(columnStart: 0, rowStart: 8, columnSpan: 5, rowSpan: 6),
      ],
    );
  }

  /// Handle base selection (HEX/DEC/OCT/BIN)
  void _handleBaseSelected(WidgetRef ref, ProgrammerBase base) {
    // Update programmer provider state (will also sync radix to calculator engine)
    ref.read(programmerProvider.notifier).setCurrentBase(base);
  }

  /// Build base conversion button (HEX/DEC/OCT)
  Widget _buildBaseButton(
    BuildContext context,
    String label,
    String value,
    bool isSelected,
    CalculatorTheme theme,
    VoidCallback onTap,
  ) {
    return Container(
      color: theme.background,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.textPrimary.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border(
                left: BorderSide(
                  color: isSelected ? theme.accent : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build BIN button with formatted binary value
  Widget _buildBinButton(
    BuildContext context,
    String label,
    String value,
    bool isSelected,
    CalculatorTheme theme,
    VoidCallback onTap,
  ) {
    // Format binary value with spaces every 4 bits
    final formattedValue = _formatBinary(value);

    return Container(
      color: theme.background,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.textPrimary.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border(
                left: BorderSide(
                  color: isSelected ? theme.accent : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    formattedValue,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Format binary value with spaces every 4 bits (nibble)
  String _formatBinary(String binary) {
    if (binary.isEmpty) return '';
    // Remove any existing spaces
    final clean = binary.replaceAll(' ', '');
    // Add space every 4 characters from right to left
    final buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(clean[clean.length - 1 - i]);
    }
    // Reverse the result
    final result = buffer.toString().split('').reversed.join('');
    return result;
  }

  /// Build programmer calculator button
  Widget _buildProgrammerButton(
    String label,
    WidgetRef ref,
    CalculatorTheme theme,
    ProgrammerState programmerState,
    CalculatorState calculatorState,
    ProgrammerButtonService buttonService,
  ) {
    final buttonService = ProgrammerButtonService(ref);
    final isDisabled = buttonService.isButtonDisabled(label, programmerState);
    final labelInfo = _getLabelInfo(label, calculatorState);
    final buttonType = _getButtonType(label);

    return CalcButton(
      text: labelInfo.displayLabel,
      icon: labelInfo.icon,
      type: buttonType,
      isDisabled: isDisabled,
      onPressed: isDisabled
          ? null
          : () => buttonService.handleButtonPress(label, programmerState),
    );
  }

  /// Get label info for button (handles special labels like C/CE)
  _LabelInfo _getLabelInfo(String label, CalculatorState calculatorState) {
    IconData? icon;
    String displayLabel = label;

    if (label == 'C/CE') {
      // Show CE when there's input, show C when display is just "0"
      final showCE = calculatorState.display != '0' || calculatorState.expression.isNotEmpty;
      displayLabel = showCE ? 'CE' : 'C';
    } else if (label == 'DEL') {
      icon = CalculatorIcons.backspace;
      displayLabel = ''; // Use icon only
    }

    return _LabelInfo(
      displayLabel: displayLabel,
      icon: icon,
    );
  }

  /// Build bit flip grid
  /// Uses nested LayoutGrid: 19 columns (16 button columns + 3 gap columns) × 8 rows
  /// Columns are grouped in sets of 4 with gaps between groups
  Widget _buildBitFlipGrid(
    WidgetRef ref,
    CalculatorTheme theme,
    ProgrammerState programmerState,
  ) {
    const totalGridRows = 8; // 4 button rows + 4 label rows

    // Create 19 columns: 4 buttons + gap + 4 buttons + gap + 4 buttons + gap + 4 buttons
    final columnSizes = [
      // First group (bits 63-48)
      ...List.generate(4, (index) => 1.fr),
      8.px, // Gap
      // Second group (bits 47-32)
      ...List.generate(4, (index) => 1.fr),
      8.px, // Gap
      // Third group (bits 31-16)
      ...List.generate(4, (index) => 1.fr),
      8.px, // Gap
      // Fourth group (bits 15-0)
      ...List.generate(4, (index) => 1.fr),
    ];

    return Container(
      color: theme.background,
      padding: const EdgeInsets.all(2),
      child: LayoutGrid(
        columnSizes: columnSizes,
        // Rows: button rows (24px) + label rows (fixed 10px)
        rowSizes: List.generate(totalGridRows, (index) {
          return index.isEven ? 24.px : 20.px;
        }),
        columnGap: 2,
        rowGap: 2,

        children: _buildBitGridChildren(
          ref,
          theme,
          programmerState,
        ),
      ),
    );
  }

  /// Build children for bit flip grid
  List<Widget> _buildBitGridChildren(
    WidgetRef ref,
    CalculatorTheme theme,
    ProgrammerState programmerState,
  ) {
    final children = <Widget>[];

    // Bit labels to show: 60, 56, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 8, 4, 0
    const shownLabels = {60, 56, 52, 48, 44, 40, 36, 32, 28, 24, 20, 16, 12, 8, 4, 0};

    // 4 button rows, each with 16 bits
    for (int buttonRowIndex = 0; buttonRowIndex < 4; buttonRowIndex++) {
      final gridRow = buttonRowIndex * 2; // Even rows for buttons
      // Row 0: bits 63-48, Row 1: bits 47-32, Row 2: bits 31-16, Row 3: bits 15-0
      final startBit = 63 - buttonRowIndex * 16;

      // Add 16 bit buttons
      for (int colIndex = 0; colIndex < 16; colIndex++) {
        final bitNumber = startBit - colIndex;
        final arrayIndex = 63 - bitNumber;
        final bitValue = programmerState.bitValues[arrayIndex];
        final isEnabled = bitNumber < programmerState.wordSize.bits;

        // Calculate grid column, accounting for gap columns after every 4 columns
        // Gap columns are at indices: 4, 9, 14
        final groupIndex = colIndex ~/ 4; // 0, 1, 2, 3
        final gapColumnsBefore = groupIndex; // Number of gap columns before this group
        final gridColumn = colIndex + gapColumnsBefore;

        children.add(
          _BitToggleButton(
            bitNumber: bitNumber,
            value: bitValue,
            isEnabled: isEnabled,
            theme: theme,
            onTap: isEnabled
                ? () => ref.read(programmerProvider.notifier).toggleBit(bitNumber)
                : null,
            alwaysShow: true,
          ).withGridPlacement(
            columnStart: gridColumn,
            rowStart: gridRow,
          ),
        );
      }

      // Add bit labels (next row, only show specific labels)
      final labelRow = gridRow + 1;
      for (int colIndex = 0; colIndex < 16; colIndex++) {
        final bitNumber = startBit - colIndex;
        final shouldShowLabel = shownLabels.contains(bitNumber);
        final label = shouldShowLabel ? '$bitNumber' : '';

        // Calculate grid column, accounting for gap columns after every 4 columns
        final groupIndex = colIndex ~/ 4;
        final gapColumnsBefore = groupIndex;
        final gridColumn = colIndex + gapColumnsBefore;

        children.add(
          Center(
            child: Text(
              label,
              style: TextStyle(
                color: bitNumber < programmerState.wordSize.bits && shouldShowLabel
                    ? theme.textSecondary
                    : Colors.transparent,
                fontSize: 9,
              ),
            ),
          ).withGridPlacement(
            columnStart: gridColumn,
            rowStart: labelRow,
          ),
        );
      }
    }

    return children;
  }

  /// Build full keypad buttons (rows 8-13)
  /// Returns a list of 30 buttons (5 columns × 6 rows)
  List<Widget> _buildFullKeypad(
    WidgetRef ref,
    CalculatorTheme theme,
    ProgrammerState programmerState,
    CalculatorState calculatorState,
    ProgrammerButtonService buttonService,
  ) {
    // Only show full keypad when in fullKeypad mode
    if (programmerState.inputMode != ProgrammerInputMode.fullKeypad) {
      return [];
    }

    return [
      // Row 8: A, <<, >>, C/CE, DEL
      _buildProgrammerButton('A', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 0, rowStart: 8),
      _buildProgrammerButton('<<', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 1, rowStart: 8),
      _buildProgrammerButton('>>', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 2, rowStart: 8),
      _buildProgrammerButton('C/CE', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 3, rowStart: 8),
      _buildProgrammerButton('DEL', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 4, rowStart: 8),

      // Row 9: B, (, ), %, ÷
      _buildProgrammerButton('B', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 0, rowStart: 9),
      _buildProgrammerButton('(', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 1, rowStart: 9),
      _buildProgrammerButton(')', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 2, rowStart: 9),
      _buildProgrammerButton('%', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 3, rowStart: 9),
      _buildProgrammerButton('÷', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 4, rowStart: 9),

      // Row 10: C, 7, 8, 9, ×
      _buildProgrammerButton('C', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 0, rowStart: 10),
      _buildProgrammerButton('7', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 1, rowStart: 10),
      _buildProgrammerButton('8', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 2, rowStart: 10),
      _buildProgrammerButton('9', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 3, rowStart: 10),
      _buildProgrammerButton('×', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 4, rowStart: 10),

      // Row 11: D, 4, 5, 6, -
      _buildProgrammerButton('D', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 0, rowStart: 11),
      _buildProgrammerButton('4', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 1, rowStart: 11),
      _buildProgrammerButton('5', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 2, rowStart: 11),
      _buildProgrammerButton('6', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 3, rowStart: 11),
      _buildProgrammerButton('-', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 4, rowStart: 11),

      // Row 12: E, 1, 2, 3, +
      _buildProgrammerButton('E', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 0, rowStart: 12),
      _buildProgrammerButton('1', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 1, rowStart: 12),
      _buildProgrammerButton('2', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 2, rowStart: 12),
      _buildProgrammerButton('3', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 3, rowStart: 12),
      _buildProgrammerButton('+', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 4, rowStart: 12),

      // Row 13: F, ±, 0, ., =
      _buildProgrammerButton('F', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 0, rowStart: 13),
      _buildProgrammerButton('±', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 1, rowStart: 13),
      _buildProgrammerButton('0', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 2, rowStart: 13),
      _buildProgrammerButton('.', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 3, rowStart: 13),
      _buildProgrammerButton('=', ref, theme, programmerState, calculatorState, buttonService)
          .withGridPlacement(columnStart: 4, rowStart: 13),
    ];
  }

  /// Get button type based on label
  CalcButtonType _getButtonType(String label) {
    if (label == '=') {
      return CalcButtonType.emphasized;
    } else if (['+', '-', '×', '÷', '%', '<<', '>>', '(', ')', 'DEL'].contains(label)) {
      return CalcButtonType.operator;
    } else if (label == 'C/CE') {
      // C/CE button is always operator style (clear button)
      return CalcButtonType.operator;
    } else {
      return CalcButtonType.number;
    }
  }

  /// Build header widget
  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    CalculatorTheme theme,
    navState,
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
    return l10n.programmerMode;
  }
}

/// Label info for button display
class _LabelInfo {
  final String displayLabel;
  final IconData? icon;

  _LabelInfo({
    required this.displayLabel,
    this.icon,
  });
}

/// Control button widget for mode and word size toggles
class _ControlButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final String? tooltip;
  final bool isSelected;
  final CalculatorTheme theme;
  final VoidCallback onTap;

  const _ControlButton({
    this.label,
    this.icon,
    this.tooltip,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.theme.textPrimary.withValues(alpha: 0.1)
                : (_isHovered
                    ? widget.theme.textPrimary.withValues(alpha: 0.05)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: widget.theme.textPrimary,
                    size: 18,
                  ),
                  if (widget.label != null) const SizedBox(width: 6),
                ],
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: TextStyle(
                      color: widget.theme.textPrimary,
                      fontSize: 14,
                      fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Header button widget
class _HeaderButton extends StatefulWidget {
  final IconData icon;
  final CalculatorTheme theme;
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

/// Bit toggle button for bit flip mode
class _BitToggleButton extends StatefulWidget {
  final int bitNumber;
  final bool value;
  final bool isEnabled;
  final CalculatorTheme theme;
  final VoidCallback? onTap;
  final bool alwaysShow;

  const _BitToggleButton({
    required this.bitNumber,
    required this.value,
    required this.isEnabled,
    required this.theme,
    required this.onTap,
    this.alwaysShow = false,
  });

  @override
  State<_BitToggleButton> createState() => _BitToggleButtonState();
}

class _BitToggleButtonState extends State<_BitToggleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Hide if not enabled and not always show
    if (!widget.isEnabled && !widget.alwaysShow) {
      return const SizedBox.expand();
    }

    // Determine background and text colors based on state
    final backgroundColor = widget.isEnabled
        ? (widget.value
            ? widget.theme.buttonAltDefault
            : (_isHovered
                ? widget.theme.buttonSubtleHover
                : widget.theme.buttonSubtleDefault))
        : widget.theme.buttonDisabled;
    final textColor = widget.isEnabled
        ? (widget.value
            ? widget.theme.textPrimary
            : widget.theme.textSecondary)
        : widget.theme.textDisabled;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: MouseRegion(
        onEnter: widget.isEnabled ? (_) => setState(() => _isHovered = true) : null,
        onExit: widget.isEnabled ? (_) => setState(() => _isHovered = false) : null,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Center(
              child: Text(
                widget.isEnabled ? (widget.value ? '1' : '0') : '0',
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: widget.value && widget.isEnabled ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
