import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/offer_model.dart';

/// A banner widget showing the recommended offer for the user.
class OffersRecommendationBanner extends StatelessWidget {
  final OfferModel offer;
  final String userGrade;

  const OffersRecommendationBanner({
    super.key,
    required this.offer,
    required this.userGrade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            offer.primaryColor.withValues(alpha: 0.1),
            offer.secondaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: offer.primaryColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: offer.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome,
              color: offer.primaryColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'العرض الموصى به لك',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${offer.name} - مناسب لمستوى $userGrade',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
