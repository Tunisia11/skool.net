import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/user_model.dart';
import 'package:skool/widgets/profile/profile_info_row.dart';

/// A card widget displaying user profile information.
class ProfileUserInfoCard extends StatelessWidget {
  final UserModel user;

  const ProfileUserInfoCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=400&h=400&fit=crop',
            ),
            backgroundColor: Colors.grey,
          ),
          const SizedBox(height: 20),

          // Name
          Text(
            user.fullName,
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // User Details
          ProfileInfoRow(
            icon: Icons.location_on,
            label: 'الولاية',
            value: user.state,
          ),
          const SizedBox(height: 16),
          ProfileInfoRow(
            icon: Icons.school,
            label: 'المستوى الدراسي',
            value: user.grade,
          ),
          if (user.displaySection != null) ...[
            const SizedBox(height: 16),
            ProfileInfoRow(
              icon: Icons.category,
              label: user.isBacStudent ? 'شعبة الباكالوريا' : 'الشعبة',
              value: user.displaySection!,
            ),
          ],
        ],
      ),
    );
  }
}
