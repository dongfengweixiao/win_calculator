import 'package:flutter/widgets.dart';
import '../../shared/widgets/unit_converter_body.dart';

/// Volume converter page body
///
/// This is now a thin wrapper around the generic UnitConverterBody
/// with volume-specific configuration.
class VolumeConverterBody extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const VolumeConverterBody({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UnitConverterBody(
      onMenuPressed: onMenuPressed,
      config: const UnitConverterConfig(
        categoryId: 11, // Volume category ID
        titleKey: 'volumeConverterTitle',
        defaultUnit1: 'Liters',
        defaultUnit2: 'Milliliters',
        showSignToggle: false, // Volume doesn't need negative values
      ),
    );
  }
}
