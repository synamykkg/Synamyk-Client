import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldForAuth extends StatelessWidget {
  const TextFieldForAuth({
    super.key,
    required this.text,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.isPassword = false,
    this.isPhone = false,
    this.obscureText = false,
    this.onVisibilityToggle,
    this.errorText,
  });

  final String text;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final bool isPassword;
  final bool isPhone;
  final bool obscureText;
  final VoidCallback? onVisibilityToggle;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      // height: 45,
      child: TextField(
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        obscureText: obscureText,
        keyboardType: keyboardType ?? TextInputType.text,
        inputFormatters: inputFormatters,
        onChanged: onChanged,

        decoration: InputDecoration(
          errorText: errorText,
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),

          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          labelText: text,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixText: isPhone ? '+' : null,
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: onVisibilityToggle,
                  )
                  : null,
        ),
      ),
    );
  }
}
