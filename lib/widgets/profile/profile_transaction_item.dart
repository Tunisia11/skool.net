import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/transaction_model.dart';

/// A transaction item widget displaying transaction details.
class ProfileTransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const ProfileTransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: transaction.typeColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          right: BorderSide(color: transaction.typeColor, width: 3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: transaction.typeColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              transaction.typeIcon,
              color: transaction.typeColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.formattedDate,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            transaction.formattedAmount,
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: transaction.typeColor,
            ),
          ),
        ],
      ),
    );
  }
}
