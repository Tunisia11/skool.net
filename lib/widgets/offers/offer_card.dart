import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/offer_model.dart';

/// A card widget displaying an individual offer with features and subscribe button.
class OfferCard extends StatelessWidget {
  final OfferModel offer;
  final bool isRecommended;
  final VoidCallback? onSubscribeTap;

  const OfferCard({
    super.key,
    required this.offer,
    this.isRecommended = false,
    this.onSubscribeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isRecommended
              ? offer.primaryColor
              : Colors.grey.withValues(alpha: 0.2),
          width: isRecommended ? 3 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isRecommended
                ? offer.primaryColor.withValues(alpha: 0.15)
                : Colors.grey.withValues(alpha: 0.08),
            blurRadius: isRecommended ? 20 : 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildPriceAndFeatures(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [offer.primaryColor, offer.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(offer.icon, color: Colors.white, size: 40),
              if (isRecommended)
                _buildBadge('موصى به')
              else if (offer.isPopular)
                _buildPopularBadge(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            offer.name,
            style: GoogleFonts.cairo(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            offer.description,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPopularBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            'الأكثر شعبية',
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceAndFeatures() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            offer.priceDisplay,
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: offer.primaryColor,
            ),
          ),
          if (offer.discountPercentage != null) ...[
            const SizedBox(height: 4),
            Text(
              'وفر ${offer.discountPercentage}% عند الاشتراك السنوي',
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 24),

          // Target Audience
          if (offer.targetGrades.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: offer.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'للتلامذة: ${offer.targetGrades.join("، ")}',
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: offer.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Features List
          ...offer.features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 24),

          // Subscribe Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSubscribeTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: offer.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'اشترك الآن',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
