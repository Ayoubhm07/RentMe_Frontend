// File: token_input_formatter.dart
import 'package:flutter/services.dart';

class TokenInputFormatter extends TextInputFormatter {
  final int maxToken;

  TokenInputFormatter({required this.maxToken});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    } else if (int.parse(newValue.text) > maxToken) {
      return TextEditingValue(
        text: maxToken.toString(),
        selection: TextSelection.collapsed(offset: maxToken.toString().length),
      );
    }
    return newValue;
  }
}
