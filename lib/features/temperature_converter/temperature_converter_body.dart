import 'package:flutter/widgets.dart';
import '../../shared/widgets/unit_converter_body.dart';

/// Temperature converter page body
///
/// This is now a thin wrapper around the generic UnitConverterBody
/// with temperature-specific configuration.
class TemperatureConverterBody extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const TemperatureConverterBody({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UnitConverterBody(
      onMenuPressed: onMenuPressed,
      config: const UnitConverterConfig(
        categoryId: 2, // Temperature category ID
        titleKey: 'temperatureConverterTitle',
        defaultUnit1: 'Celsius',
        defaultUnit2: 'Fahrenheit',
        showSignToggle: true, // Temperature needs positive/negative support
      ),
    );
  }
}
