import 'package:flutter/services.dart';

/// The field only ever collects the 9-digit local number; the `+996`
/// country code is a fixed prefix shown separately (see [TextFieldForAuth]).
const int kLocalPhoneDigits = 9;

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    final limited =
        digitsOnly.length > kLocalPhoneDigits
            ? digitsOnly.substring(0, kLocalPhoneDigits)
            : digitsOnly;

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

/// Whether [raw] (whatever the phone field currently holds — digits and
/// formatting spaces) contains a complete 9-digit local number.
bool isCompleteLocalPhone(String raw) =>
    raw.replaceAll(RegExp(r'\D'), '').length == kLocalPhoneDigits;

/// Normalizes a phone field's raw value into the `996XXXXXXXXX` form the
/// backend expects (see `RegisterRequest.phone` pattern `^\+?996\d{9}$`).
/// Strips all formatting/whitespace and ensures the `996` country code is
/// present exactly once, regardless of whether the user typed it manually.
String normalizePhoneForApi(String raw) {
  var digits = raw.replaceAll(RegExp(r'\D'), '');
  if (!digits.startsWith('996')) {
    digits = '996$digits';
  }
  return digits;
}
