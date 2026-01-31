import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/subject_model.dart';
import 'package:skool/repositories/subject_repository.dart';
import 'package:skool/screens/admin/admin_chapters_page.dart';

class AdminSubjectsPage extends StatefulWidget {
  final String userId;
  
  const AdminSubjectsPage({super.key, required this.userId});

  @override
  State<AdminSubjectsPage> createState() => _AdminSubjectsPageState();
}

class _AdminSubjectsPageState extends State<AdminSubjectsPage> {
  final SubjectRepository _repository = SubjectRepository();
  List<SubjectModel> _subjects = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    setState(() => _isLoading = true);
    try {
      final subjects = await _repository.getAllSubjects();
      setState(() {
        _subjects = subjects;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'إدارة المواد الدراسية',
          style: GoogleFonts.cairo(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _loadSubjects,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSubjectDialog(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('إضافة مادة', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState()
              : _subjects.isEmpty
                  ? _buildEmptyState()
                  : _buildSubjectsList(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('حدث خطأ', style: GoogleFonts.cairo(fontSize: 18, color: Colors.red)),
          const SizedBox(height: 8),
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
          Text('لا توجد مواد دراسية', style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('اضغط على زر الإضافة لإنشاء مادة جديدة', style: GoogleFonts.cairo(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSubjectsList() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_subjects.length} مادة',
            style: GoogleFonts.cairo(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: _subjects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildSubjectCard(_subjects[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(SubjectModel subject) {
    return InkWell(
      onTap: () => _navigateToChapters(subject),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: subject.color.withValues(alpha: 0.1), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [subject.color, subject.color.withValues(alpha: 0.7)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(subject.iconData, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject.name, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildStatChip(Icons.folder_outlined, '${subject.chapterCount} فصل'),
                      const SizedBox(width: 12),
                      _buildStatChip(Icons.play_circle_outline, '${subject.videoCount} درس'),
                    ],
                  ),
                  if (subject.targetGrades.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: subject.targetGrades.map((g) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: subject.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(g, style: GoogleFonts.cairo(fontSize: 11, color: subject.color)),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
            // Action buttons
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.grey.withValues(alpha: 0.5)),
              onSelected: (value) {
                if (value == 'edit') _showEditSubjectDialog(subject);
                if (value == 'delete') _confirmDeleteSubject(subject);
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'edit', child: Row(children: [
                  const Icon(Icons.edit_outlined, size: 18),
                  const SizedBox(width: 8),
                  Text('تعديل', style: GoogleFonts.cairo()),
                ])),
                PopupMenuItem(value: 'delete', child: Row(children: [
                  const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  const SizedBox(width: 8),
                  Text('حذف', style: GoogleFonts.cairo(color: Colors.red)),
                ])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(text, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  void _navigateToChapters(SubjectModel subject) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminChaptersPage(subject: subject)),
    ).then((_) => _loadSubjects());
  }

  void _showAddSubjectDialog() {
    _showSubjectDialog(null);
  }

  void _showEditSubjectDialog(SubjectModel subject) {
    _showSubjectDialog(subject);
  }

  void _showSubjectDialog(SubjectModel? subject) {
    final nameController = TextEditingController(text: subject?.name ?? '');
    String selectedIcon = subject?.icon ?? 'book';
    String selectedColor = subject?.colorHex ?? '#2196F3';
    List<String> selectedGrades = List<String>.from(subject?.targetGrades ?? []);

    final grades = [
      'السنة السابعة', 'السنة الثامنة', 'السنة التاسعة',
      'الأولى ثانوي', 'الثانية ثانوي', 'الثالثة ثانوي',
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            subject == null ? 'إضافة مادة جديدة' : 'تعديل المادة',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name field
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'اسم المادة',
                    labelStyle: GoogleFonts.cairo(),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),

                // Icon selection
                Text('الأيقونة', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: SubjectModel.iconOptions.map((opt) => InkWell(
                    onTap: () => setDialogState(() => selectedIcon = opt['value']),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selectedIcon == opt['value'] ? AppColors.primary : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(opt['icon'], color: selectedIcon == opt['value'] ? Colors.white : Colors.grey),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 20),

                // Color selection
                Text('اللون', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: SubjectModel.colorOptions.map((opt) {
                    final color = Color(int.parse(opt['hex'].replaceFirst('#', '0xFF')));
                    return InkWell(
                      onTap: () => setDialogState(() => selectedColor = opt['hex']),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == opt['hex'] ? Colors.black : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Grade selection
                Text('المستويات المستهدفة', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: grades.map((grade) => FilterChip(
                    label: Text(grade, style: GoogleFonts.cairo(fontSize: 12)),
                    selected: selectedGrades.contains(grade),
                    onSelected: (selected) {
                      setDialogState(() {
                        if (selected) {
                          selectedGrades.add(grade);
                        } else {
                          selectedGrades.remove(grade);
                        }
                      });
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  )).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                Navigator.pop(ctx);
                await _saveSubject(subject, nameController.text, selectedIcon, selectedColor, selectedGrades);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(subject == null ? 'إضافة' : 'حفظ', style: GoogleFonts.cairo(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSubject(SubjectModel? existing, String name, String icon, String colorHex, List<String> grades) async {
    try {
      if (existing == null) {
        final newSubject = SubjectModel(
          id: '',
          name: name,
          icon: icon,
          colorHex: colorHex,
          targetGrades: grades,
          createdBy: widget.userId,
          createdAt: DateTime.now(),
        );
        await _repository.createSubject(newSubject);
        _showSnackbar('تم إنشاء المادة بنجاح', Colors.green);
      } else {
        final updated = SubjectModel(
          id: existing.id,
          name: name,
          icon: icon,
          colorHex: colorHex,
          targetGrades: grades,
          createdBy: existing.createdBy,
          createdAt: existing.createdAt,
        );
        await _repository.updateSubject(updated);
        _showSnackbar('تم تحديث المادة بنجاح', Colors.green);
      }
      _loadSubjects();
    } catch (e) {
      _showSnackbar('حدث خطأ: $e', Colors.red);
    }
  }

  void _confirmDeleteSubject(SubjectModel subject) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          const Icon(Icons.warning_amber, color: Colors.red),
          const SizedBox(width: 8),
          Text('حذف المادة', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.red)),
        ]),
        content: Text('هل أنت متأكد من حذف "${subject.name}"?\nسيتم حذف جميع الفصول والدروس.', style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await _repository.deleteSubject(subject.id);
                _showSnackbar('تم حذف المادة', Colors.green);
                _loadSubjects();
              } catch (e) {
                _showSnackbar('فشل الحذف: $e', Colors.red);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('حذف', style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: GoogleFonts.cairo()),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }
}
