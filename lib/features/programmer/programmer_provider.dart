import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wincalc_engine/wincalc_engine.dart';
import '../calculator/calculator_provider.dart';
import 'bit_converter.dart';

/// Shift mode enum
enum ShiftMode {
  arithmetic('算术移位'),
  logical('逻辑移位'),
  rotate('旋转循环移位'),
  rotateCarry('带进位旋转循环移位');

  final String label;
  const ShiftMode(this.label);
}

/// Programmer number base type
enum ProgrammerBase {
  hex(16, 'HEX'),
  dec(10, 'DEC'),
  oct(8, 'OCT'),
  bin(2, 'BIN');

  final int value;
  final String label;

  const ProgrammerBase(this.value, this.label);
}

/// Programmer word size type
enum WordSize {
  qword(64, 'QWORD'),
  dword(32, 'DWORD'),
  word(16, 'WORD'),
  byte(8, 'BYTE');

  final int bits;
  final String label;

  const WordSize(this.bits, this.label);
}

/// Programmer input mode
enum ProgrammerInputMode {
  fullKeypad,
  bitFlip;

  String get label {
    switch (this) {
      case ProgrammerInputMode.fullKeypad:
        return '全键盘';
      case ProgrammerInputMode.bitFlip:
        return '位翻转';
    }
  }
}

/// Programmer calculator state
class ProgrammerState {
  final ProgrammerBase currentBase;
  final String hexValue;
  final String decValue;
  final String octValue;
  final String binValue;
  final WordSize wordSize;
  final ProgrammerInputMode inputMode;
  final ShiftMode shiftMode;

  /// Bit values for bit flip mode (64 bits)
  /// bitValues[0] represents bit 63 (MSB, 2^63)
  /// bitValues[63] represents bit 0 (LSB, 2^0)
  final List<bool> bitValues;

  const ProgrammerState({
    required this.currentBase,
    required this.hexValue,
    required this.decValue,
    required this.octValue,
    required this.binValue,
    required this.wordSize,
    required this.inputMode,
    required this.shiftMode,
    required this.bitValues,
  });

  ProgrammerState copyWith({
    ProgrammerBase? currentBase,
    String? hexValue,
    String? decValue,
    String? octValue,
    String? binValue,
    WordSize? wordSize,
    ProgrammerInputMode? inputMode,
    ShiftMode? shiftMode,
    List<bool>? bitValues,
  }) {
    return ProgrammerState(
      currentBase: currentBase ?? this.currentBase,
      hexValue: hexValue ?? this.hexValue,
      decValue: decValue ?? this.decValue,
      octValue: octValue ?? this.octValue,
      binValue: binValue ?? this.binValue,
      wordSize: wordSize ?? this.wordSize,
      inputMode: inputMode ?? this.inputMode,
      shiftMode: shiftMode ?? this.shiftMode,
      bitValues: bitValues ?? this.bitValues,
    );
  }
}

/// Programmer calculator state notifier
class ProgrammerNotifier extends Notifier<ProgrammerState> {
  bool _initialized = false;

  @override
  ProgrammerState build() {
    return ProgrammerState(
      currentBase: ProgrammerBase.dec,
      hexValue: '0',
      decValue: '0',
      octValue: '0',
      binValue: '0',
      wordSize: WordSize.qword,
      inputMode: ProgrammerInputMode.fullKeypad,
      shiftMode: ShiftMode.logical,
      bitValues: List.generate(64, (index) => false),
    );
  }

  /// Initialize programmer mode settings when activated
  /// This should be called when switching to programmer mode
  void initialize() {
    if (!_initialized) {
      final calculator = ref.read(calculatorProvider.notifier);

      // Set default word size to QWORD (64-bit)
      calculator.setQword();

      // Set radix to match the default base (HEX)
      _setRadixForBase(state.currentBase);

      _initialized = true;
    }
  }

  /// Update all base values directly from calculator engine
  /// This is the preferred method for programmer mode as it gets results
  /// directly from wincalc_engine's base conversion functions
  ///
  /// Following Microsoft Calculator architecture: work with strings from engine,
  /// parse to BigInt only for bit array calculation (UI needs)
  void updateValuesFromCalculator() {
    final calculator = ref.read(calculatorProvider.notifier);
    final hexVal = calculator.getResultHex();
    final decVal = calculator.getResultDec();
    final octVal = calculator.getResultOct();
    final binVal = calculator.getResultBin();

    // Parse hex value as BigInt to update bit values
    // Use hex because it's always unsigned and handles all word sizes correctly
    try {
      // Remove spaces from hex string for parsing
      final cleanHex = hexVal.replaceAll(' ', '');
      final bigIntValue = BigInt.tryParse(cleanHex, radix: 16);

      if (bigIntValue != null) {
        // Update bit values using BigInt (no overflow issues)
        final newBitValues = List<bool>.generate(64, (index) {
          final bitNumber = 63 - index; // 0 is LSB, 63 is MSB
          return (bigIntValue >> bitNumber) & BigInt.one == BigInt.one;
        });

        state = state.copyWith(
          hexValue: hexVal,
          decValue: decVal,
          octValue: octVal,
          binValue: binVal,
          bitValues: newBitValues,
        );
      } else {
        // If parsing fails, just update the display values without bit array
        state = state.copyWith(
          hexValue: hexVal,
          decValue: decVal,
          octValue: octVal,
          binValue: binVal,
        );
      }
    } catch (e) {
      // If parsing fails, just update the display values without bit array
      state = state.copyWith(
        hexValue: hexVal,
        decValue: decVal,
        octValue: octVal,
        binValue: binVal,
      );
    }
  }

  /// Toggle a specific bit (bitNumber: 63-0, where 0 is LSB)
  /// When editing bits, this will:
  /// 1. Generate the new bit value as a binary string
  /// 2. Clear expression and result
  /// 3. Set radix to BINARY and input the binary string
  /// 4. Restore the original radix
  /// 5. Update local state from calculator engine
  ///
  /// Following Microsoft Calculator architecture:
  /// - Work with strings, not numbers
  /// - Let wincalc_engine handle all base conversions
  void toggleBit(int bitNumber) {
    // Convert bit number to array index (bitValues[0] = bit 63, bitValues[63] = bit 0)
    final arrayIndex = 63 - bitNumber;
    final newBitValues = List<bool>.from(state.bitValues);
    newBitValues[arrayIndex] = !newBitValues[arrayIndex];

    // Convert bit values directly to binary string (no BigInt conversion needed)
    final binaryStr = BitConverter.bitValuesToBinaryString(newBitValues, state.wordSize);

    // Step 1: Clear expression and result (clear twice for full clear)
    final calculator = ref.read(calculatorProvider.notifier);
    calculator.clear();
    calculator.clear();

    // Step 2: Set radix to BINARY and input the binary string
    // wincalc_engine will convert it to the current display base
    calculator.setRadix(CalcRadixType.CALC_RADIX_BINARY);
    _inputString(binaryStr);

    // Step 3: Restore the original radix
    _setRadixForBase(state.currentBase);

    // Step 4: Update local state from calculator engine
    // The engine will handle all signed/unsigned formatting based on word size
    updateValuesFromCalculator();

    // Also update bit values manually since calculator engine doesn't provide bit array
    _updateBitValuesOnly(newBitValues);
  }

  /// Update only bit values without changing display values
  void _updateBitValuesOnly(List<bool> newBitValues) {
    state = state.copyWith(bitValues: newBitValues);
  }

  /// Set calculator engine radix to match programmer base
  void _setRadixForBase(ProgrammerBase base) {
    final calculator = ref.read(calculatorProvider.notifier);
    switch (base) {
      case ProgrammerBase.hex:
        calculator.setRadix(CalcRadixType.CALC_RADIX_HEX);
        break;
      case ProgrammerBase.dec:
        calculator.setRadix(CalcRadixType.CALC_RADIX_DECIMAL);
        break;
      case ProgrammerBase.oct:
        calculator.setRadix(CalcRadixType.CALC_RADIX_OCTAL);
        break;
      case ProgrammerBase.bin:
        calculator.setRadix(CalcRadixType.CALC_RADIX_BINARY);
        break;
    }
  }

  /// Input a string directly to wincalc_engine
  /// Following Microsoft Calculator architecture: work with strings, not numbers
  void _inputString(String valueStr) {
    final calculator = ref.read(calculatorProvider.notifier);

    // Input each character
    for (int i = 0; i < valueStr.length; i++) {
      final char = valueStr[i];
      if (char == '-') {
        calculator.inputNegate();
      } else if (char.toUpperCase() == 'A') {
        calculator.inputDigit(10);
      } else if (char.toUpperCase() == 'B') {
        calculator.inputDigit(11);
      } else if (char.toUpperCase() == 'C') {
        calculator.inputDigit(12);
      } else if (char.toUpperCase() == 'D') {
        calculator.inputDigit(13);
      } else if (char.toUpperCase() == 'E') {
        calculator.inputDigit(14);
      } else if (char.toUpperCase() == 'F') {
        calculator.inputDigit(15);
      } else {
        final digit = int.tryParse(char);
        if (digit != null) {
          calculator.inputDigit(digit);
        }
      }
    }
  }

  /// Set current base
  void setCurrentBase(ProgrammerBase base) {
    state = state.copyWith(currentBase: base);
    // Sync radix to calculator engine
    _setRadixForBase(base);
  }

  /// Cycle word size and sync with calculator engine
  void cycleWordSize() {
    final sizes = WordSize.values;
    final currentIndex = sizes.indexOf(state.wordSize);
    final nextIndex = (currentIndex + 1) % sizes.length;
    final newWordSize = sizes[nextIndex];

    // Update local state
    state = state.copyWith(wordSize: newWordSize);

    // Sync with calculator engine
    final calculator = ref.read(calculatorProvider.notifier);
    switch (newWordSize) {
      case WordSize.qword:
        calculator.setQword();
        break;
      case WordSize.dword:
        calculator.setDword();
        break;
      case WordSize.word:
        calculator.setWord();
        break;
      case WordSize.byte:
        calculator.setByte();
        break;
    }
  }

  /// Toggle input mode
  void toggleInputMode() {
    final newMode = state.inputMode == ProgrammerInputMode.fullKeypad
        ? ProgrammerInputMode.bitFlip
        : ProgrammerInputMode.fullKeypad;
    state = state.copyWith(inputMode: newMode);
  }

  /// Set shift mode
  void setShiftMode(ShiftMode mode) {
    state = state.copyWith(shiftMode: mode);
  }

  /// Get display value for a base
  String getValueForBase(ProgrammerBase base) {
    switch (base) {
      case ProgrammerBase.hex:
        return state.hexValue;
      case ProgrammerBase.dec:
        return state.decValue;
      case ProgrammerBase.oct:
        return state.octValue;
      case ProgrammerBase.bin:
        return state.binValue;
    }
  }
}

/// Programmer calculator provider
final programmerProvider =
    NotifierProvider<ProgrammerNotifier, ProgrammerState>(() {
  return ProgrammerNotifier();
});
