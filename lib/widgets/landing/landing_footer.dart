import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Footer widget for the Landing page.
class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      color: Colors.white,
      child: Center(
        child: Text(
          '© 2025 Skool. All rights reserved.',
          style: GoogleFonts.cairo(
            fontSize: isMobile ? 12 : 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
