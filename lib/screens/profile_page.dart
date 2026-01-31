import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/models/student_model.dart';
import 'package:skool/models/user_model.dart';
import 'package:skool/models/transaction_model.dart';
import 'package:skool/widgets/app_sidebar.dart';
import 'package:skool/widgets/recharge_dialog.dart';
import 'package:skool/widgets/profile/profile.dart';
import 'package:skool/screens/dashboard_page.dart';
import 'package:skool/screens/offers_page.dart';
import 'package:skool/screens/subjects_page.dart';

class ProfilePage extends StatefulWidget {
  final UserModel? user;

  const ProfilePage({super.key, this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel currentUser;
  late List<TransactionModel> transactions;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user ?? UserModel.getDemoUser();
    transactions = TransactionModel.getFakeTransactions();
  }

  void _addFunds(double amount) {
    if (currentUser is StudentModel) {
      final student = currentUser as StudentModel;
      setState(() {
        currentUser = student.copyWith(
          walletBalance: student.walletBalance + amount,
        );
        // Add new transaction to history
        transactions.insert(
          0,
          TransactionModel(
            id: 't${DateTime.now().millisecondsSinceEpoch}',
            amount: amount,
            type: TransactionType.recharge,
            dateTime: DateTime.now(),
            description: 'شحن رصيد - بطاقة ائتمان',
          ),
        );
      });
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم شحن المحفظة بنجاح',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showRechargeDialog() {
    showDialog(
      context: context,
      builder: (context) => RechargeDialog(onRecharge: _addFunds),
    );
  }

  void _handleNavigation(String route) {
    if (route == 'home') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else if (route == 'profile') {
      // Already on profile page
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar
          AppSidebar(currentRoute: 'profile', onNavigate: _handleNavigation),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  ProfileHeader(user: currentUser),
                  const SizedBox(height: 30),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column - User Info & Wallet
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            ProfileUserInfoCard(user: currentUser),
                            const SizedBox(height: 20),
                            ProfileWalletCard(
                              user: currentUser,
                              onRechargeTap: _showRechargeDialog,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),

                      // Right Column - Transaction History
                      Expanded(
                        flex: 3,
                        child: ProfileTransactionHistory(
                          transactions: transactions,
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
}
