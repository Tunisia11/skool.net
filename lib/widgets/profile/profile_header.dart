import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/user_model.dart';

/// Header widget for the Profile page displaying user greeting and wallet badge.
class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ملفي الشخصي',
              style: GoogleFonts.cairo(
                fontSize: 20,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'مرحباً، ${user.fullName} 👋',
              style: GoogleFonts.cairo(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: AppColors.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                user.formattedBalance,
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
