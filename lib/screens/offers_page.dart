import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/models/offer_model.dart';
import 'package:skool/models/user_model.dart';
import 'package:skool/widgets/app_sidebar.dart';
import 'package:skool/widgets/offers/offers.dart';
import 'package:skool/screens/dashboard_page.dart';
import 'package:skool/screens/subjects_page.dart';
import 'package:skool/screens/profile_page.dart';

class OffersPage extends StatefulWidget {
  final UserModel? user;

  const OffersPage({super.key, this.user});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  late UserModel currentUser;
  late List<OfferModel> offers;
  OfferModel? recommendedOffer;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user ?? UserModel.getDemoUser();
    offers = OfferModel.getAllOffers();
    recommendedOffer = OfferModel.getRecommendedOffer(currentUser.grade);
  }

  void _handleNavigation(String route) {
    if (route == 'home') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else if (route == 'offers') {
      // Already on offers page
    } else if (route == 'subjects') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SubjectsPage()),
      );
    } else if (route == 'profile') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    }
  }

  void _handleSubscribe(OfferModel offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'الاشتراك في ${offer.name}',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(offer.icon, size: 60, color: offer.primaryColor),
            const SizedBox(height: 16),
            Text(
              'رائع! أنت على وشك الاشتراك في ${offer.name}',
              style: GoogleFonts.cairo(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              offer.priceDisplay,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: offer.primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'شكراً! تم تأكيد اشتراكك في ${offer.name}',
                    style: GoogleFonts.cairo(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: offer.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('تأكيد الاشتراك', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar
          AppSidebar(currentRoute: 'offers', onNavigate: _handleNavigation),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const OffersHeader(),
                  const SizedBox(height: 10),

                  // Recommendation Banner
                  if (recommendedOffer != null) ...[
                    OffersRecommendationBanner(
                      offer: recommendedOffer!,
                      userGrade: currentUser.grade,
                    ),
                    const SizedBox(height: 30),
                  ],

                  // Offers Grid
                  OffersGrid(
                    offers: offers,
                    recommendedOffer: recommendedOffer,
                    onSubscribeTap: _handleSubscribe,
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
