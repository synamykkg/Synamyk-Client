import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    final limited =
        digitsOnly.length > 12 ? digitsOnly.substring(0, 12) : digitsOnly;

    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      buffer.write(limited[i]);
      if ((i + 1) % 3 == 0 && i + 1 != limited.length) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}