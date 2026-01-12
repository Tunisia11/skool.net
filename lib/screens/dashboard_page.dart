import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/cubits/auth/auth_cubit.dart';
import 'package:skool/cubits/auth/auth_state.dart';
import 'package:skool/models/student_model.dart';
import 'package:skool/screens/landing_page.dart';
import 'package:skool/screens/profile_page.dart';
import 'package:skool/screens/offers_page.dart';
import 'package:skool/screens/subjects_page.dart';
import 'package:skool/screens/live_page.dart';
import 'package:skool/widgets/app_sidebar.dart';
import 'package:skool/widgets/enhanced_calendar_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    String userName = 'Guest';
    String userGrade = '';
    
    if (authState is AuthAuthenticated) {
      userName = authState.user.name;
      if (authState.user is StudentModel) {
        userGrade = (authState.user as StudentModel).grade ?? '';
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE), // Light grey/blue background
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar
          AppSidebar(
            currentRoute: 'home',
            onNavigate: (route) {
              if (route == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              } else if (route == 'offers') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OffersPage()),
                );
              } else if (route == 'subjects') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubjectsPage()),
                );
              } else if (route == 'live') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LivePage()),
                );
              }
            },
          ),
          
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Header
                   _buildHeader(context, userName),
                   const SizedBox(height: 30),
                   
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       // Left Column (Main Stats & Courses)
                       Expanded(
                         flex: 3,
                         child: Column(
                           children: [
                               _buildWelcomeCard(userName),
                               const SizedBox(height: 20),
                               // Empty state for progress
                               _buildEmptyState('تقدمك الدراسي', 'لم تبدأ أي دورات بعد.'),
                               const SizedBox(height: 20),
                               // Empty state for classes
                               _buildEmptyState('الحصص القادمة', 'لا توجد حصص مجدولة قريبًا.'),
                           ],
                         ),
                       ),
                       const SizedBox(width: 30),
                       // Right Column (Profile Stats / Calendar)
                       Expanded(
                         flex: 1,
                         child: Column(
                           children: [
                             _buildProfileCard(userName, userGrade),
                             const SizedBox(height: 20),
                             const EnhancedCalendarCard(),
                           ],
                         ),
                       ),
                     ],
                   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('لوحة التحكم', style: GoogleFonts.cairo(fontSize: 20, color: AppColors.textSecondary)),
            Text('أهلاً، $userName 👋', style: GoogleFonts.cairo(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ],
        ),
        Row(
           children: [
             _iconButton(Icons.search),
             const SizedBox(width: 10),
             _iconButton(Icons.notifications_none),
             const SizedBox(width: 10),
             Container(
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(30),
                 boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10)],
               ),
               child: Row(
                 children: [
                   Icon(Icons.account_balance_wallet, color: AppColors.secondary, size: 20),
                   const SizedBox(width: 8),
                   Text('0 TND', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                 ],
               ),
             )
           ],
        ),
      ],
    );
  }
  
  Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
         boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10)],
      ),
      child: Icon(icon, color: AppColors.textSecondary),
    );
  }

  Widget _buildWelcomeCard(String userName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF868CFF), Color(0xFF4318FF)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('مجهود رائع يا $userName!', style: GoogleFonts.cairo(fontSize: 16, color: Colors.white.withValues(alpha: 0.8))),
                 const SizedBox(height: 8),
                 Text('ابدأ رحلتك التعليمية الآن!', 
                  style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, height: 1.4)),
                 const SizedBox(height: 20),
                 ElevatedButton(
                   onPressed: () {},
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     foregroundColor: const Color(0xFF4318FF),
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                   ),
                   child: Text('تصفح الدورات', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                 )
               ],
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Icon(Icons.inbox, size: 48, color: Colors.grey[300]),
                const SizedBox(height: 12),
                Text(message, style: GoogleFonts.cairo(color: Colors.grey[500])),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  
   Widget _buildProfileCard(String name, String grade) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
           CircleAvatar(
             radius: 40,
             backgroundColor: AppColors.primary.withValues(alpha: 0.1),
             child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?', 
                style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
           ),
           const SizedBox(height: 10),
           Text(name, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
           Text(grade, style: GoogleFonts.cairo(fontSize: 14, color: AppColors.textSecondary), textAlign: TextAlign.center),
           const SizedBox(height: 20),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               _statItem('0', 'الدورات'),
               _statItem('0', 'ساعة'),
               _statItem('-', 'المعدل'),
             ],
           ),
        ],
      ),
    );
  }
  
  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

}
