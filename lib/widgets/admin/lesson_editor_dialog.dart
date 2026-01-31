import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/models/subject_model.dart';
import 'package:skool/widgets/admin/lesson_resource_dialog.dart';

class LessonEditorDialog extends StatefulWidget {
  final LessonModel? lesson;
  final Color accentColor;

  const LessonEditorDialog({super.key, this.lesson, required this.accentColor});

  @override
  State<LessonEditorDialog> createState() => _LessonEditorDialogState();
}

class _LessonEditorDialogState extends State<LessonEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _videoUrlController;
  late TextEditingController _durationController;
  late List<ResourceModel> _resources;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.lesson?.title ?? '');
    _videoUrlController = TextEditingController(text: widget.lesson?.videoUrl ?? '');
    _durationController = TextEditingController(text: widget.lesson?.duration ?? '');
    _resources = List.from(widget.lesson?.resources ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _videoUrlController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        widget.lesson == null ? 'إضافة درس' : 'تعديل الدرس',
        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Info
                TextFormField(
                  controller: _titleController,
                  validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
                  decoration: InputDecoration(
                    labelText: 'عنوان الدرس',
                    labelStyle: GoogleFonts.cairo(),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _videoUrlController,
                  decoration: InputDecoration(
                    labelText: 'رابط الفيديو',
                    labelStyle: GoogleFonts.cairo(),
                    hintText: 'https://...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.videocam),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  decoration: InputDecoration(
                    labelText: 'المدة (دقيقة:ثانية)',
                    labelStyle: GoogleFonts.cairo(),
                    hintText: '15:30',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.timer),
                  ),
                ),
                const SizedBox(height: 24),

                // Resources Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('المرفقات', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextButton.icon(
                      onPressed: _addResource,
                      icon: const Icon(Icons.add, size: 18),
                      label: Text('سند', style: GoogleFonts.cairo()),
                      style: TextButton.styleFrom(foregroundColor: widget.accentColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_resources.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    child: Center(
                      child: Text('لا توجد مرفقات', style: GoogleFonts.cairo(color: Colors.grey)),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _resources.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _buildResourceItem(_resources[index], index),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.accentColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            widget.lesson == null ? 'إضافة' : 'حفظ',
            style: GoogleFonts.cairo(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildResourceItem(ResourceModel resource, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            resource.type == 'pdf' ? Icons.picture_as_pdf : Icons.link,
            color: resource.type == 'pdf' ? Colors.red : Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resource.title, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(resource.url, style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
            onPressed: () => _editResource(resource, index),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
            onPressed: () => setState(() => _resources.removeAt(index)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Future<void> _addResource() async {
    final result = await showDialog<ResourceModel>(
      context: context,
      builder: (_) => const LessonResourceDialog(),
    );
    if (result != null) {
      setState(() => _resources.add(result));
    }
  }

  Future<void> _editResource(ResourceModel resource, int index) async {
    final result = await showDialog<ResourceModel>(
      context: context,
      builder: (_) => LessonResourceDialog(resource: resource),
    );
    if (result != null) {
      setState(() => _resources[index] = result);
    }
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final lesson = LessonModel(
        id: widget.lesson?.id ?? '', // ID handled by repo for new lessons if empty
        title: _titleController.text,
        videoUrl: _videoUrlController.text,
        duration: _durationController.text.isEmpty ? '0:00' : _durationController.text,
        order: widget.lesson?.order ?? 0,
        isCompleted: widget.lesson?.isCompleted ?? false,
        resources: _resources,
      );
      Navigator.pop(context, lesson);
    }
  }
}
