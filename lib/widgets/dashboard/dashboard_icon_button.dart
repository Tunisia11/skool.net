import 'package:flutter/material.dart';
import 'package:skool/constants/app_colors.dart';

/// A circular icon button widget used in the dashboard header.
class DashboardIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const DashboardIconButton({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textSecondary),
      ),
    );
  }
}
