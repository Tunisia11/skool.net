import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A widget displaying an empty state message in the dashboard.
class DashboardEmptyState extends StatelessWidget {
  final String title;
  final String message;

  const DashboardEmptyState({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Icon(Icons.inbox, size: 48, color: Colors.grey[300]),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: GoogleFonts.cairo(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
