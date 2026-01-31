import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/user_model.dart';
import 'package:skool/models/student_model.dart';
import 'package:skool/models/teacher_model.dart';
import 'package:skool/repositories/auth_repository.dart';

class UserDetailsPage extends StatefulWidget {
  final UserModel user;

  const UserDetailsPage({super.key, required this.user});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late UserModel _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'تفاصيل المستخدم',
          style: GoogleFonts.cairo(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
            ),
            onPressed: () => _showEditDialog(context),
            tooltip: 'تعديل',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            child: isMobile
                ? Column(
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 24),
                      _buildActionButtons(context),
                      const SizedBox(height: 24),
                      _buildBasicInfoSection(),
                      const SizedBox(height: 24),
                      if (_user is StudentModel) _buildStudentSpecifics(_user as StudentModel),
                      if (_user is TeacherModel) _buildTeacherSpecifics(_user as TeacherModel),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 320,
                        child: Column(
                          children: [
                            _buildProfileHeader(),
                            const SizedBox(height: 24),
                            _buildActionButtons(context),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: Column(
                          children: [
                            _buildBasicInfoSection(),
                            const SizedBox(height: 24),
                            if (_user is StudentModel) _buildStudentSpecifics(_user as StudentModel),
                            if (_user is TeacherModel) _buildTeacherSpecifics(_user as TeacherModel),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    final roleColor = _getRoleColor(_user.role);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, roleColor.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: roleColor.withValues(alpha: 0.1),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [roleColor, roleColor.withValues(alpha: 0.5)],
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Text(
                _user.name.isNotEmpty ? _user.name[0].toUpperCase() : '?',
                style: GoogleFonts.cairo(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: roleColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _user.name,
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [roleColor, roleColor.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getRoleLabel(_user.role),
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQuickStat('تاريخ التسجيل', _formatDate(_user.createdAt)),
              if (_user is StudentModel && (_user as StudentModel).age > 0) ...[
                Container(
                  height: 30,
                  width: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.grey.withValues(alpha: 0.2),
                ),
                _buildQuickStat('العمر', '${(_user as StudentModel).age} سنة'),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        Text(label, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الإجراءات', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          _buildActionButton(
            icon: Icons.lock_reset,
            label: 'إعادة تعيين كلمة المرور',
            color: Colors.orange,
            onTap: () => _resetPassword(),
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            icon: Icons.swap_horiz,
            label: 'تغيير الدور',
            color: Colors.indigo,
            onTap: () => _showChangeRoleDialog(),
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            icon: Icons.account_balance_wallet,
            label: 'تعديل الرصيد',
            color: Colors.teal,
            onTap: () => _showBalanceDialog(),
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            icon: Icons.block,
            label: 'تعليق الحساب',
            color: Colors.red.withValues(alpha: 0.8),
            onTap: () => _banUser(),
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            icon: Icons.delete_outline,
            label: 'حذف الحساب',
            color: Colors.red,
            onTap: () => _showDeleteDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(label, style: GoogleFonts.cairo(color: color, fontWeight: FontWeight.w600)),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: color.withValues(alpha: 0.5), size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.info_outline, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Text('المعلومات الأساسية', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 24),
          _infoRow(Icons.email_outlined, 'البريد الإلكتروني', _user.email),
          if (_user.phoneNumber != null && _user.phoneNumber!.isNotEmpty) ...[
            const Divider(height: 30),
            _infoRow(Icons.phone_outlined, 'رقم الهاتف', '+216 ${_user.phoneNumber!}'),
          ],
          const Divider(height: 30),
          _infoRow(Icons.calendar_today_outlined, 'تاريخ التسجيل', _formatDate(_user.createdAt)),
        ],
      ),
    );
  }

  Widget _buildStudentSpecifics(StudentModel student) {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.school_outlined, color: Colors.green),
              ),
              const SizedBox(width: 12),
              Text('بيانات الطالب', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 24),
          _infoRow(Icons.school_outlined, 'المستوى الدراسي', student.grade),
          const Divider(height: 30),
          _infoRow(Icons.account_balance_wallet, 'الرصيد', '${student.walletBalance.toStringAsFixed(2)} د.ت'),
          if (student.state.isNotEmpty) ...[
            const Divider(height: 30),
            _infoRow(Icons.location_on_outlined, 'الولاية', student.state),
          ],
          if (student.gender != null && student.gender!.isNotEmpty) ...[
            const Divider(height: 30),
            _infoRow(Icons.person_outline, 'الجنس', student.gender!),
          ],
          if (student.learningProfile != null) ...[
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo.withValues(alpha: 0.1), Colors.purple.withValues(alpha: 0.05)]),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.psychology_outlined, color: Colors.indigo),
                    const SizedBox(width: 8),
                    Text('الملف التعليمي', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.indigo)),
                  ]),
                  const SizedBox(height: 16),
                  _detailItem('الهدف الأساسي', student.learningProfile!.primaryGoal),
                  const SizedBox(height: 10),
                  _detailItem('أسلوب التعلم', student.learningProfile!.learningStyle),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTeacherSpecifics(TeacherModel teacher) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.person_outline, color: Colors.orange),
            ),
            const SizedBox(width: 12),
            Text('بيانات المعلم', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ]),
          const SizedBox(height: 24),
          _infoRow(Icons.work_outline, 'الحالة', 'نشط'),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSecondary)),
          Text(value, style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ]),
      ),
    ]);
  }

  Widget _detailItem(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  // ==================== ACTION METHODS ====================

  Future<void> _resetPassword() async {
    final confirm = await _showConfirmDialog('إعادة تعيين كلمة المرور', 'سيتم إرسال رابط إعادة تعيين كلمة المرور إلى ${_user.email}');
    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      await context.read<AuthRepository>().resetPassword(_user.email);
      _showSuccessSnackbar('تم إرسال رابط إعادة تعيين كلمة المرور');
    } catch (e) {
      _showErrorSnackbar('فشل إرسال الرابط: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showChangeRoleDialog() {
    UserRole selectedRole = _user.role;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('تغيير الدور', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: UserRole.values.map((role) => RadioListTile<UserRole>(
              title: Text(_getRoleLabel(role), style: GoogleFonts.cairo()),
              value: role,
              groupValue: selectedRole,
              onChanged: (v) => setDialogState(() => selectedRole = v!),
              activeColor: AppColors.primary,
            )).toList(),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.grey))),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await _updateRole(selectedRole);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: Text('تأكيد', style: GoogleFonts.cairo(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateRole(UserRole newRole) async {
    setState(() => _isLoading = true);
    try {
      await context.read<AuthRepository>().updateUserRole(_user.id, newRole);
      _showSuccessSnackbar('تم تغيير الدور بنجاح');
    } catch (e) {
      _showErrorSnackbar('فشل تغيير الدور: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showBalanceDialog() {
    final currentBalance = _user is StudentModel ? (_user as StudentModel).walletBalance : 0.0;
    final controller = TextEditingController(text: currentBalance.toStringAsFixed(2));
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('تعديل الرصيد', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('الرصيد الحالي: ${currentBalance.toStringAsFixed(2)} د.ت', style: GoogleFonts.cairo(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
              decoration: InputDecoration(
                labelText: 'الرصيد الجديد',
                labelStyle: GoogleFonts.cairo(),
                suffixText: 'د.ت',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              final newBalance = double.tryParse(controller.text) ?? 0.0;
              Navigator.pop(ctx);
              await _updateBalance(newBalance);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Text('تحديث', style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _updateBalance(double newBalance) async {
    setState(() => _isLoading = true);
    try {
      await context.read<AuthRepository>().updateUserBalance(_user.id, newBalance);
      _showSuccessSnackbar('تم تحديث الرصيد إلى ${newBalance.toStringAsFixed(2)} د.ت');
    } catch (e) {
      _showErrorSnackbar('فشل تحديث الرصيد: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _banUser() async {
    final confirm = await _showConfirmDialog('تعليق الحساب', 'هل أنت متأكد من تعليق حساب ${_user.name}؟');
    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      await context.read<AuthRepository>().banUser(_user.id);
      _showSuccessSnackbar('تم تعليق الحساب بنجاح');
    } catch (e) {
      _showErrorSnackbar('فشل تعليق الحساب: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          const Icon(Icons.warning_amber, color: Colors.red),
          const SizedBox(width: 8),
          Text('حذف الحساب', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.red)),
        ]),
        content: Text('هل أنت متأكد من حذف حساب ${_user.name}؟\nهذا الإجراء لا يمكن التراجع عنه.', style: GoogleFonts.cairo()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _deleteUser();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Text('حذف', style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUser() async {
    setState(() => _isLoading = true);
    try {
      await context.read<AuthRepository>().deleteUser(_user.id);
      _showSuccessSnackbar('تم حذف الحساب بنجاح');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showErrorSnackbar('فشل حذف الحساب: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<bool?> _showConfirmDialog(String title, String message) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text(message, style: GoogleFonts.cairo()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.grey))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Text('تأكيد', style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle, color: Colors.white),
        const SizedBox(width: 10),
        Text(message, style: GoogleFonts.cairo()),
      ]),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.error_outline, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(child: Text(message, style: GoogleFonts.cairo())),
      ]),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('تعديل المستخدم', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text('سيتم إضافة نموذج التعديل قريباً', style: GoogleFonts.cairo()),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إغلاق', style: GoogleFonts.cairo(color: AppColors.primary)))],
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin: return Colors.purple;
      case UserRole.teacher: return Colors.orange;
      case UserRole.student: return Colors.green;
    }
  }

  String _getRoleLabel(UserRole role) {
    switch (role) {
      case UserRole.admin: return 'مدير';
      case UserRole.teacher: return 'معلم';
      case UserRole.student: return 'طالب';
    }
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
