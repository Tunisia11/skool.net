import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A hero widget displayed when no live session is currently active.
class LiveNoLiveHero extends StatelessWidget {
  const LiveNoLiveHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6B7FD7),
            const Color(0xFF6B7FD7).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B7FD7).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sensors_off_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'لا يوجد بث مباشر حالياً',
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'تصفح الحصص القادمة أو شاهد تسجيلات الحصص السابقة',
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
