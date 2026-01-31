import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/repositories/auth_repository.dart';
import 'package:skool/models/user_model.dart';
import 'package:skool/models/student_model.dart';
import 'package:skool/models/teacher_model.dart';
import 'package:skool/cubits/auth/auth_cubit.dart';
import 'package:skool/cubits/auth/auth_state.dart';
import 'package:skool/screens/admin/user_details_page.dart';
import 'package:skool/screens/admin/admin_subjects_page.dart';
import 'package:skool/screens/admin/tabs/admin_reports_tab.dart';
import 'package:skool/screens/admin/tabs/admin_settings_tab.dart';
import 'package:skool/l10n/app_localizations.dart';


class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  String _selectedFilter = 'all'; // all, student, teacher, admin
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await context.read<AuthRepository>().getAllUsers();
      if (!mounted) return;
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterUsers() {
    setState(() {
      _filteredUsers = _users.where((user) {
        // Search filter
        final matchesSearch = user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.email.toLowerCase().contains(_searchQuery.toLowerCase());
        
        // Role filter
        bool matchesRole = true;
        if (_selectedFilter == 'student') {
          matchesRole = user is StudentModel;
        } else if (_selectedFilter == 'teacher') {
          matchesRole = user is TeacherModel;
        } else if (_selectedFilter == 'admin') {
          matchesRole = user.role == UserRole.admin;
        }
        
        return matchesSearch && matchesRole;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;


    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      body: Row(
        children: [
          // Sidebar (hidden on mobile)
          if (!isMobile) _buildSidebar(isMobile),
          
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                _buildTopBar(isMobile),
                
                // Content
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? _buildErrorState()
                          : _buildContent(isMobile),
                ),
              ],
            ),
          ),
        ],
      ),
      // Drawer for mobile
      drawer: isMobile ? Drawer(child: _buildSidebar(isMobile)) : null,
    );
  }

  Widget _buildSidebar(bool isMobile) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: isMobile ? double.infinity : 280,
      color: Colors.white,
      child: Column(
        children: [
          // Logo Area
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.school, color: AppColors.primary, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.adminPanel,
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildNavItem(0, Icons.dashboard, l10n.dashboard),
                _buildNavItem(1, Icons.people, l10n.users),
                _buildNavItem(2, Icons.menu_book, l10n.subjects),
                _buildNavItem(3, Icons.bar_chart, l10n.reports),
                _buildNavItem(4, Icons.settings, l10n.settings),
                
                const Divider(height: 32),
                
                // Logout
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    l10n.logout,
                    style: GoogleFonts.cairo(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    context.read<AuthCubit>().logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedNavIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () {
          if (index == 2) {
            // Navigate to subjects management
            final authState = context.read<AuthCubit>().state;
            String userId = '';
            if (authState is AuthAuthenticated) {
              userId = authState.user.id;
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AdminSubjectsPage(userId: userId)),
            );
          } else {
            setState(() => _selectedNavIndex = index);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: GoogleFonts.cairo(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(bool isMobile) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isMobile)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          
          Text(
            l10n.adminPanel,
            style: GoogleFonts.cairo(
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          
          const Spacer(),
          
          // Refresh Button
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchUsers();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('Error: $_error', style: GoogleFonts.cairo(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchUsers();
            },
            icon: const Icon(Icons.refresh),
            label: Text('Retry', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    switch (_selectedNavIndex) {
      case 3:
        return AdminReportsTab(users: _users);
      case 4:
        return const AdminSettingsTab();
      case 0:
      case 1:
      default:
        return _buildDashboardContent(isMobile);
    }
  }

  Widget _buildDashboardContent(bool isMobile) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row
          _buildStatsRow(isMobile),
          const SizedBox(height: 32),
          
          // Search and Filter Section
          _buildSearchAndFilter(isMobile),
          const SizedBox(height: 24),
          
          // Users List Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.userList,
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${_filteredUsers.length}',
                style: GoogleFonts.cairo(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Users List
          ..._filteredUsers.map((user) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildUserCard(user),
          )),
          
          if (_filteredUsers.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noUsersFound,
                      style: GoogleFonts.cairo(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool isMobile) {
    final l10n = AppLocalizations.of(context)!;
    final studentCount = _users.whereType<StudentModel>().length;
    final teacherCount = _users.whereType<TeacherModel>().length;
    final adminCount = _users.where((u) => u.role == UserRole.admin).length;

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              _buildStatCard(l10n.totalUsers, _users.length.toString(), AppColors.primary, Icons.people),
              const SizedBox(width: 12),
              _buildStatCard(l10n.students, studentCount.toString(), Colors.green, Icons.school),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard(l10n.teachers, teacherCount.toString(), Colors.orange, Icons.person),
              const SizedBox(width: 12),
              _buildStatCard(l10n.admins, adminCount.toString(), Colors.purple, Icons.admin_panel_settings),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        _buildStatCard(l10n.totalUsers, _users.length.toString(), AppColors.primary, Icons.people),
        const SizedBox(width: 16),
        _buildStatCard(l10n.students, studentCount.toString(), Colors.green, Icons.school),
        const SizedBox(width: 16),
        _buildStatCard(l10n.teachers, teacherCount.toString(), Colors.orange, Icons.person),
        const SizedBox(width: 16),
        _buildStatCard(l10n.admins, adminCount.toString(), Colors.purple, Icons.admin_panel_settings),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.cairo(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter(bool isMobile) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: (value) {
              _searchQuery = value;
              _filterUsers();
            },
            decoration: InputDecoration(
              hintText: l10n.searchUser,
              hintStyle: GoogleFonts.cairo(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              filled: true,
              fillColor: const Color(0xFFF4F7FE),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
          const SizedBox(height: 16),
          
          // Filter Chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildFilterChip('all', l10n.all, Icons.people),
              _buildFilterChip('student', l10n.students, Icons.school),
              _buildFilterChip('teacher', l10n.teachers, Icons.person),
              _buildFilterChip('admin', l10n.admins, Icons.admin_panel_settings),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;
    return InkWell(
      onTap: () {
        setState(() => _selectedFilter = value);
        _filterUsers();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.cairo(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    final isStudent = user is StudentModel;
    final isTeacher = user is TeacherModel;
    final isAdmin = user.role == UserRole.admin;
    
    Color roleColor = Colors.grey;
    String roleLabel = user.role.name;
    
    if (isStudent) {
      roleColor = Colors.green;
      roleLabel = 'طالب';
    } else if (isTeacher) {
      roleColor = Colors.orange;
      roleLabel = 'معلم';
    } else if (isAdmin) {
      roleColor = Colors.purple;
      roleLabel = 'مدير';
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UserDetailsPage(user: user)),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [roleColor, roleColor.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: GoogleFonts.cairo(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            
            // Role Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: roleColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                roleLabel,
                style: GoogleFonts.cairo(
                  color: roleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
