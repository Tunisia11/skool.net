import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/user_model.dart';
import 'package:skool/models/student_model.dart';
import 'package:skool/models/teacher_model.dart';
import 'package:skool/l10n/app_localizations.dart';

class AdminReportsTab extends StatelessWidget {
  final List<UserModel> users;

  const AdminReportsTab({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Calculate simple stats

    final students = users.whereType<StudentModel>().toList();
    final totalBalance = students.fold(0.0, (sum, s) => sum + s.walletBalance);
    
    // Group students by grade (simple histogram data)
    final Map<String, int> studentsByGrade = {};
    for (var s in students) {
      final grade = s.grade.isEmpty ? 'Unknown' : s.grade;
      studentsByGrade[grade] = (studentsByGrade[grade] ?? 0) + 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.reports,
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          // Revenue/Wallet Card
          _buildSummaryCard(
            title: l10n.totalBalance,
            value: '${totalBalance.toStringAsFixed(2)} TND',
            icon: Icons.account_balance_wallet,
            color: Colors.green,
          ),
          const SizedBox(height: 24),

          // Grade Distribution
          Text(
            l10n.studentDistribution,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...studentsByGrade.entries.map((e) => _buildBarChartItem(context, e.key, e.value, students.length)),
          
          if (studentsByGrade.isEmpty)
             Center(child: Text(l10n.noUsersFound)), // Or specific no data string

          const SizedBox(height: 40),
          

          // Activity Section
          Text(
            l10n.recentActivity,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          if (users.isEmpty)
             Center(child: Text(l10n.noRecentActivity)),

          ..._buildRecentActivityList(context, l10n),
        ],
      ),
    );
  }

  List<Widget> _buildRecentActivityList(BuildContext context, AppLocalizations l10n) {
    // Sort users by createdAt descending
    final sortedUsers = List<UserModel>.from(users)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    // Take top 5
    final recentUsers = sortedUsers.take(5).toList();

    return recentUsers.map((user) {
      final timeAgo = _formatTimeAgo(user.createdAt);
      String action = l10n.newStudent;
      if (user is TeacherModel) {
        action = l10n.newTeacher;
      }
      
      return _buildActivityItem(
        '$action: ${user.name}',
        timeAgo,
      );
    }).toList();
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    // Note: Time ago logic is hardcoded in Arabic for now as requested by user context or arb file limitation.
    // Ideally this should also use localization logic/Intl.
    
    if (difference.inDays > 365) {
      return 'منذ ${(difference.inDays / 365).floor()} سنة';
    } else if (difference.inDays > 30) {
      return 'منذ ${(difference.inDays / 30).floor()} شهر';
    } else if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  Widget _buildSummaryCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.cairo(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.cairo(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartItem(BuildContext context, String label, int count, int total) {
    final double percentage = total == 0 ? 0 : count / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              Text('$count (${(percentage * 100).toStringAsFixed(1)}%)', style: GoogleFonts.cairo(color: Colors.grey)), 
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerRight, // Arabic RTL - should check locale direction for LTR support if needed
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivityItem(String title, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 12, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.w600))),
          Text(time, style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
