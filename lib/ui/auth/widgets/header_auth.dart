import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderAuth {
  static List<Widget> slivers(
    BuildContext context,
    Text title,
    String subtitle,
    String image,
  ) {
    return [
      const SliverAppBar(backgroundColor: Colors.white, elevation: 0),

      SliverToBoxAdapter(child: Image.asset(image, height: 100)),

      const SliverToBoxAdapter(child: SizedBox(height: 30)),

      SliverToBoxAdapter(
        child: Column(
          spacing: 16,
          children: [
            title,
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),

      const SliverToBoxAdapter(child: SizedBox(height: 40)),
    ];
  }
}
