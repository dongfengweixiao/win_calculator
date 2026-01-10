import '../../domain/constants/display_limits.dart';

/// Responsive layout service
/// Handles responsive layout logic based on screen size
class ResponsiveLayoutService {
  /// Determine if history panel should be shown
  static bool shouldShowHistoryPanel(double width) {
    return width >= DisplayLimits.historyPanelBreakpoint;
  }

  /// Get history panel display mode
  static HistoryPanelMode getHistoryPanelMode(double width) {
    if (width >= DisplayLimits.historyPanelBreakpoint) {
      return HistoryPanelMode.sidePanel;
    } else {
      return HistoryPanelMode.bottomSheet;
    }
  }

  /// Determine if tablet layout should be used
  static bool isTabletLayout(double width) {
    return width >= DisplayLimits.tabletBreakpoint;
  }

  /// Determine if desktop layout should be used
  static bool isDesktopLayout(double width) {
    return width >= DisplayLimits.desktopBreakpoint;
  }

  /// Get maximum width for history panel
  static double getMaxHistoryPanelWidth() {
    return DisplayLimits.maxHistoryPanelWidth;
  }

  /// Get minimum width for history panel
  static double getMinHistoryPanelWidth() {
    return DisplayLimits.minHistoryPanelWidth;
  }

  /// Calculate history panel width based on screen size
  static double calculateHistoryPanelWidth(double screenWidth) {
    final maxWidth = getMaxHistoryPanelWidth();
    final minWidth = getMinHistoryPanelWidth();

    // Use 25% of screen width, but keep within min/max bounds
    final calculatedWidth = screenWidth * 0.25;

    if (calculatedWidth < minWidth) {
      return minWidth;
    } else if (calculatedWidth > maxWidth) {
      return maxWidth;
    }

    return calculatedWidth;
  }

  /// Determine if navigation drawer should be used
  static bool shouldUseDrawer(double width) {
    return width < DisplayLimits.desktopBreakpoint;
  }

  /// Private constructor to prevent instantiation
  ResponsiveLayoutService._();
}

/// History panel display mode
enum HistoryPanelMode {
  /// Show as side panel
  sidePanel,

  /// Show as bottom sheet
  bottomSheet,
}
