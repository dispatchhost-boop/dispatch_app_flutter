import 'package:flutter/services.dart';

class AadhaarNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Remove spaces
    String digitsOnly = newValue.text.replaceAll(' ', '');

    // Limit to 12 digits max
    if (digitsOnly.length > 12) {
      digitsOnly = digitsOnly.substring(0, 12);
    }

    // Add space after every 4 digits (only two spaces total for 12 digits)
    StringBuffer formatted = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      formatted.write(digitsOnly[i]);
      if ((i + 1) % 4 == 0 && i + 1 != digitsOnly.length) {
        formatted.write(' ');
      }
    }

    return TextEditingValue(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
