import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonForAuth extends StatelessWidget {
  const ButtonForAuth({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    required this.textColor,
    this.isLoading = false,
    required this.isValid,
  });

  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final bool isLoading;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,

      child: Container(
        width: 350,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isValid ? color : Color(0xFFE5E5E5),
        ),
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                  : Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
        ),
      ),
    );
  }
}
