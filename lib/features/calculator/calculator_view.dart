import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/theme_provider.dart';
import '../../shared/navigation/navigation_provider.dart';
import '../../core/domain/entities/view_mode.dart';
import 'calculator_provider.dart';
import '../../core/services/mode/mode_converter.dart';
import '../../core/services/layout/responsive_layout_service.dart';
import '../programmer/programmer_grid_body.dart';
import 'standard_grid_body.dart';
import '../scientific/scientific_grid_body.dart';
import '../date_calculation/date_calculation_body.dart';
import '../volume_converter/volume_converter_body.dart';
import 'navigation_drawer.dart';
import '../history/history_panel.dart';

/// Main calculator view with responsive layout
class CalculatorView extends ConsumerStatefulWidget {
  const CalculatorView({super.key});

  @override
  ConsumerState<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends ConsumerState<CalculatorView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(calculatorThemeProvider);
    final currentMode = ref.watch(currentModeProvider);

    // Sync calculator mode with navigation mode
    // Uses ModeConverter service for conversion
    ref.listen(currentModeProvider, (previous, next) {
      if (previous != next) {
        final calcMode = ModeConverter.viewToCalculator(next);
        ref.read(calculatorProvider.notifier).setMode(calcMode);
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.background,
      drawer: const CalculatorNavigationDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Update history panel visibility based on width
            // Uses ResponsiveLayoutService for layout logic
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref
                  .read(navigationProvider.notifier)
                  .updateHistoryPanelVisibility(constraints.maxWidth);
            });

            // Determine history panel visibility using ResponsiveLayoutService
            final showHistoryPanel = ResponsiveLayoutService.shouldShowHistoryPanel(constraints.maxWidth);

            // Determine if history panel should be shown
            // History/Memory panel is not needed for date calculation and converter modes
            final shouldShowHistoryPanel = showHistoryPanel &&
                currentMode != ViewMode.dateCalculation &&
                currentMode != ViewMode.volumeConverter;

            return Row(
              children: [
                // Main calculator area
                Expanded(
                  child: _buildCalculatorBody(context, ref, theme, currentMode),
                ),

                // History panel (when width >= 640 and not in date calculation mode)
                if (shouldShowHistoryPanel) const HistoryMemoryPanel(),
              ],
            );
          },
        ),
      ),
    );
  }


  Widget _buildCalculatorBody(
    BuildContext context,
    WidgetRef ref,
    calculatorTheme,
    ViewMode currentMode,
  ) {
    // For standard mode, use grid layout
    if (currentMode == ViewMode.standard) {
      return StandardGridBody(
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      );
    }

    // For scientific mode, use grid layout
    if (currentMode == ViewMode.scientific) {
      return ScientificGridBody(
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      );
    }

    // For programmer mode, use grid layout
    if (currentMode == ViewMode.programmer) {
      return ProgrammerGridBody(
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      );
    }

    // For date calculation mode
    if (currentMode == ViewMode.dateCalculation) {
      return DateCalculationBody(
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      );
    }

    // For volume converter mode
    if (currentMode == ViewMode.volumeConverter) {
      return VolumeConverterBody(
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      );
    }

    // Fallback (should never reach here as all modes are handled above)
    return const SizedBox.shrink();
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
