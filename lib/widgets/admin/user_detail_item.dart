import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Detail item widget for displaying learning profile details.
class UserDetailItem extends StatelessWidget {
  final String label;
  final String value;

  const UserDetailItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
          Text(value,
              style: GoogleFonts.cairo(
                  fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
