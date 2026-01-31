import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/subject_model.dart';
import 'package:skool/repositories/subject_repository.dart';
import 'package:skool/widgets/admin/lesson_editor_dialog.dart';

class AdminChaptersPage extends StatefulWidget {
  final SubjectModel subject;

  const AdminChaptersPage({super.key, required this.subject});

  @override
  State<AdminChaptersPage> createState() => _AdminChaptersPageState();
}

class _AdminChaptersPageState extends State<AdminChaptersPage> {
  final SubjectRepository _repository = SubjectRepository();
  List<ChapterModel> _chapters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChapters();
  }

  Future<void> _loadChapters() async {
    setState(() => _isLoading = true);
    try {
      final chapters = await _repository.getChapters(widget.subject.id);
      setState(() {
        _chapters = chapters;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.subject.name, style: GoogleFonts.cairo(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
            Text('إدارة الفصول', style: GoogleFonts.cairo(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddChapterDialog,
        backgroundColor: widget.subject.color,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('إضافة فصل', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chapters.isEmpty
              ? _buildEmptyState()
              : _buildChaptersList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 80, color: Colors.grey.withValues(alpha: 0.5)),
          const SizedBox(height: 24),
          Text('لا توجد فصول', style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('اضغط على زر الإضافة لإنشاء فصل جديد', style: GoogleFonts.cairo(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildChaptersList() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _chapters.length,
      onReorder: _reorderChapters,
      itemBuilder: (context, index) => _buildChapterCard(_chapters[index], index),
    );
  }

  Widget _buildChapterCard(ChapterModel chapter, int index) {
    return Card(
      key: ValueKey(chapter.id),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: widget.subject.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text('${index + 1}', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: widget.subject.color)),
          ),
        ),
        title: Text(chapter.title, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        subtitle: Text(chapter.description, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${chapter.lessons.length} درس', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(width: 8),
            const Icon(Icons.drag_handle, color: Colors.grey),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lessons list
                ...chapter.lessons.asMap().entries.map((entry) => _buildLessonTile(chapter, entry.value, entry.key)),
                
                const SizedBox(height: 12),
                // Add lesson button
                OutlinedButton.icon(
                  onPressed: () => _showAddLessonDialog(chapter),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text('إضافة درس', style: GoogleFonts.cairo()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: widget.subject.color,
                    side: BorderSide(color: widget.subject.color),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 8),
                // Chapter actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showEditChapterDialog(chapter),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: Text('تعديل', style: GoogleFonts.cairo(fontSize: 12)),
                    ),
                    TextButton.icon(
                      onPressed: () => _confirmDeleteChapter(chapter),
                      icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                      label: Text('حذف', style: GoogleFonts.cairo(fontSize: 12, color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonTile(ChapterModel chapter, LessonModel lesson, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha :0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: widget.subject.color, borderRadius: BorderRadius.circular(6)),
            child: Center(child: Text('${index + 1}', style: GoogleFonts.cairo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lesson.title, style: GoogleFonts.cairo(fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(lesson.duration, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSecondary)),
                    if (lesson.videoUrl.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      Icon(Icons.videocam, size: 12, color: Colors.green),
                      const SizedBox(width: 4),
                      Text('فيديو', style: GoogleFonts.cairo(fontSize: 11, color: Colors.green)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: () => _showEditLessonDialog(chapter, lesson),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
            onPressed: () => _confirmDeleteLesson(chapter, lesson),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }

  void _reorderChapters(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    setState(() {
      final chapter = _chapters.removeAt(oldIndex);
      _chapters.insert(newIndex, chapter);
    });
    // Update order in Firestore
    for (int i = 0; i < _chapters.length; i++) {
      final updated = ChapterModel(
        id: _chapters[i].id,
        title: _chapters[i].title,
        description: _chapters[i].description,
        order: i,
        isLocked: _chapters[i].isLocked,
        lessons: _chapters[i].lessons,
      );
      await _repository.updateChapter(widget.subject.id, updated);
    }
  }

  void _showAddChapterDialog() => _showChapterDialog(null);
  void _showEditChapterDialog(ChapterModel chapter) => _showChapterDialog(chapter);

  void _showChapterDialog(ChapterModel? chapter) {
    final titleController = TextEditingController(text: chapter?.title ?? '');
    final descController = TextEditingController(text: chapter?.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(chapter == null ? 'إضافة فصل' : 'تعديل الفصل', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'عنوان الفصل', labelStyle: GoogleFonts.cairo(), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'الوصف', labelStyle: GoogleFonts.cairo(), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty) return;
              Navigator.pop(ctx);
              try {
                if (chapter == null) {
                  final newChapter = ChapterModel(
                    id: '',
                    title: titleController.text,
                    description: descController.text,
                    order: _chapters.length,
                  );
                  await _repository.createChapter(widget.subject.id, newChapter);
                } else {
                  final updated = ChapterModel(
                    id: chapter.id,
                    title: titleController.text,
                    description: descController.text,
                    order: chapter.order,
                    isLocked: chapter.isLocked,
                    lessons: chapter.lessons,
                  );
                  await _repository.updateChapter(widget.subject.id, updated);
                }
                _loadChapters();
                _showSnackbar('تم الحفظ بنجاح', Colors.green);
              } catch (e) {
                _showSnackbar('خطأ: $e', Colors.red);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: widget.subject.color),
            child: Text(chapter == null ? 'إضافة' : 'حفظ', style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteChapter(ChapterModel chapter) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('حذف الفصل', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.red)),
        content: Text('هل أنت متأكد من حذف "${chapter.title}"?', style: GoogleFonts.cairo()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _repository.deleteChapter(widget.subject.id, chapter.id);
              _loadChapters();
              _showSnackbar('تم الحذف', Colors.green);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('حذف', style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddLessonDialog(ChapterModel chapter) => _showLessonDialog(chapter, null);
  void _showEditLessonDialog(ChapterModel chapter, LessonModel lesson) => _showLessonDialog(chapter, lesson);

  Future<void> _showLessonDialog(ChapterModel chapter, LessonModel? lesson) async {
    final result = await showDialog<LessonModel>(
      context: context,
      builder: (ctx) => LessonEditorDialog(
        lesson: lesson,
        accentColor: widget.subject.color,
      ),
    );

    if (result != null) {
      try {
        if (lesson == null) {
          // New lesson
          final newLesson = LessonModel(
            id: '',
            title: result.title,
            videoUrl: result.videoUrl,
            duration: result.duration,
            order: chapter.lessons.length,
            resources: result.resources,
          );
          await _repository.createLesson(widget.subject.id, chapter.id, newLesson);
        } else {
          // Update lesson
          final updated = LessonModel(
            id: lesson.id,
            title: result.title,
            videoUrl: result.videoUrl,
            duration: result.duration,
            order: lesson.order,
            isCompleted: lesson.isCompleted,
            resources: result.resources,
          );
          await _repository.updateLesson(widget.subject.id, chapter.id, updated);
        }
        _loadChapters();
        _showSnackbar('تم الحفظ بنجاح', Colors.green);
      } catch (e) {
        _showSnackbar('خطأ: $e', Colors.red);
      }
    }
  }

  void _confirmDeleteLesson(ChapterModel chapter, LessonModel lesson) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('حذف الدرس', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.red)),
        content: Text('هل أنت متأكد من حذف "${lesson.title}"?', style: GoogleFonts.cairo()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _repository.deleteLesson(widget.subject.id, chapter.id, lesson.id);
              _loadChapters();
              _showSnackbar('تم الحذف', Colors.green);
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
    ));
  }
}
