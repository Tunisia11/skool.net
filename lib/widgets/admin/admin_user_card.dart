import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/user_model.dart';
import 'package:skool/models/student_model.dart';

/// User card widget for the admin panel.
class AdminUserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;

  const AdminUserCard({
    super.key,
    required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isStudent = user is StudentModel;
    String subtitle = user.role.name;
    if (isStudent) {
      subtitle += ' • ${(user as StudentModel).grade ?? "No Grade"}';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
            style: GoogleFonts.cairo(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.name,
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.email,
              style: GoogleFonts.cairo(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isStudent
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                subtitle,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: isStudent ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isStudent && (user as StudentModel).learningProfile != null) ...[
              const SizedBox(height: 8),
              Text(
                'Goal: ${(user as StudentModel).learningProfile!.primaryGoal}',
                style:
                    GoogleFonts.cairo(fontSize: 12, color: Colors.blueGrey),
              ),
            ]
          ],
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}
