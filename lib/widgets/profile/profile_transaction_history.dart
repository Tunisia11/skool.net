import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/transaction_model.dart';
import 'package:skool/widgets/profile/profile_transaction_item.dart';

/// A card widget displaying transaction history.
class ProfileTransactionHistory extends StatelessWidget {
  final List<TransactionModel> transactions;
  final VoidCallback? onViewAllTap;

  const ProfileTransactionHistory({
    super.key,
    required this.transactions,
    this.onViewAllTap,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'سجل المعاملات',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: onViewAllTap,
                child: Text(
                  'عرض الكل',
                  style: GoogleFonts.cairo(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Transactions List
          ...transactions.map(
            (transaction) => ProfileTransactionItem(transaction: transaction),
          ),
        ],
      ),
    );
  }
}
