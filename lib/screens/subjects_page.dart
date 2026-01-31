import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/cubits/auth/auth_cubit.dart';
import 'package:skool/cubits/auth/auth_state.dart';
import 'package:skool/models/subject_model.dart';
import 'package:skool/models/student_model.dart';
import 'package:skool/repositories/subject_repository.dart';
import 'package:skool/widgets/app_sidebar.dart';
import 'package:skool/screens/dashboard_page.dart';
import 'package:skool/screens/profile_page.dart';
import 'package:skool/screens/offers_page.dart';
import 'package:skool/screens/chapters_page.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  final SubjectRepository _repository = SubjectRepository();
  List<SubjectModel> _subjects = [];
  bool _isLoading = true;
  String? _error;
  String? _userGrade;

  @override
  void initState() {
    super.initState();
    _loadUserAndSubjects();
  }

  Future<void> _loadUserAndSubjects() async {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated && authState.user is StudentModel) {
      _userGrade = (authState.user as StudentModel).grade;
    }
    await _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    setState(() => _isLoading = true);
    try {
      final subjects = await _repository.getAllSubjects();
      // Filter by user grade if available
      final filtered = _userGrade != null
          ? subjects.where((s) => s.targetGrades.isEmpty || s.targetGrades.contains(_userGrade)).toList()
          : subjects;
      setState(() {
        _subjects = filtered;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _handleNavigation(String route) {
    if (route == 'home') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
    } else if (route == 'profile') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
    } else if (route == 'offers') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const OffersPage()));
    }
  }

  void _handleSubjectTap(SubjectModel subject) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ChaptersPage(subject: subject)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSidebar(currentRoute: 'subjects', onNavigate: _handleNavigation),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorState()
                    : _subjects.isEmpty
                        ? _buildEmptyState()
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeader(),
                                const SizedBox(height: 30),
                                _buildSubjectsGrid(),
                              ],
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المواد الدراسية', style: GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.bold)),
            Text('${_subjects.length} مادة متاحة', style: GoogleFonts.cairo(color: AppColors.textSecondary)),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: AppColors.primary),
          onPressed: _loadSubjects,
          tooltip: 'تحديث',
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('حدث خطأ في تحميل المواد', style: GoogleFonts.cairo(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadSubjects,
            icon: const Icon(Icons.refresh),
            label: Text('إعادة المحاولة', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_outlined, size: 80, color: Colors.grey.withValues(alpha: 0.5)),
          const SizedBox(height: 24),
          Text('لا توجد مواد متاحة حالياً', style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('سيتم إضافة المواد قريباً', style: GoogleFonts.cairo(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSubjectsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.3,
          ),
          itemCount: _subjects.length,
          itemBuilder: (context, index) => _buildSubjectCard(_subjects[index]),
        );
      },
    );
  }

  Widget _buildSubjectCard(SubjectModel subject) {
    return InkWell(
      onTap: () => _handleSubjectTap(subject),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: subject.color.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [subject.color, subject.color.withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(subject.iconData, color: Colors.white, size: 28),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: subject.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${subject.chapterCount} فصل',
                    style: GoogleFonts.cairo(fontSize: 12, color: subject.color, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              subject.name,
              style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.play_circle_outline, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${subject.videoCount} درس', style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
            const Spacer(),
            // Progress bar
            if (subject.progress > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('التقدم', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSecondary)),
                  Text('${(subject.progress * 100).toInt()}%', style: GoogleFonts.cairo(fontSize: 12, color: subject.color, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: subject.progress,
                  backgroundColor: Colors.grey.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation(subject.color),
                  minHeight: 6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
