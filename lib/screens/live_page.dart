import 'package:flutter/material.dart';
import 'package:skool/models/live_lesson.dart';
import 'package:skool/widgets/app_sidebar.dart';
import 'package:skool/widgets/live/live.dart';
import 'package:skool/screens/dashboard_page.dart';
import 'package:skool/screens/profile_page.dart';
import 'package:skool/screens/offers_page.dart';
import 'package:skool/screens/subjects_page.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<LiveLesson> _allLessons;
  late List<LiveLesson> _upcomingLessons;
  late List<LiveLesson> _recordedLessons;
  bool _hasLiveNow = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLessons();
  }

  void _loadLessons() {
    _allLessons = LiveLesson.getFakeLessons();
    _upcomingLessons = _allLessons.where((l) => l.type == 'upcoming').toList();
    _recordedLessons = _allLessons.where((l) => l.type == 'recorded').toList();
    _hasLiveNow = _allLessons.any((l) => l.type == 'live');
  }

  void _handleNavigation(String route) {
    if (route == 'home') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else if (route == 'profile') {
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SubjectsPage()),
      );
    } else if (route == 'live') {
      // Already on live page
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
          AppSidebar(
            currentRoute: 'live',
            onNavigate: _handleNavigation,
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                const LiveHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_hasLiveNow) const LiveNoLiveHero(),
                        const SizedBox(height: 30),
                        LiveTabs(
                          controller: _tabController,
                          onTap: () => setState(() {}),
                        ),
                        const SizedBox(height: 20),
                        LiveLessonsGrid(
                          lessons: _tabController.index == 0
                              ? _upcomingLessons
                              : _recordedLessons,
                          isReplay: _tabController.index == 1,
                        ),
                      ],
                    ),
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
