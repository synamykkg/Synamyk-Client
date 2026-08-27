import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Text(
            'SYNAMYK',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF35004E),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(
              image: AssetImage('assets/images/logo/synamyk_logo.png'),
            ),
          ],
        ),
      ),
    );
  }
}
