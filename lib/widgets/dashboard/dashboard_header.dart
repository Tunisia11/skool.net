import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/widgets/dashboard/dashboard_icon_button.dart';

/// Header widget for the Dashboard page.
class DashboardHeader extends StatelessWidget {
  final String userName;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;

  const DashboardHeader({
    super.key,
    required this.userName,
    this.onSearchTap,
    this.onNotificationTap,
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
              'لوحة التحكم',
              style: GoogleFonts.cairo(
                fontSize: 20,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'أهلاً، $userName 👋',
              style: GoogleFonts.cairo(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            DashboardIconButton(
              icon: Icons.search,
              onTap: onSearchTap,
            ),
            const SizedBox(width: 10),
            DashboardIconButton(
              icon: Icons.notifications_none,
              onTap: onNotificationTap,
            ),
            const SizedBox(width: 10),
            _buildWalletBadge(),
          ],
        ),
      ],
    );
  }

  Widget _buildWalletBadge() {
    return Container(
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
          Icon(Icons.account_balance_wallet, color: AppColors.secondary, size: 20),
          const SizedBox(width: 8),
          Text('0 TND', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
