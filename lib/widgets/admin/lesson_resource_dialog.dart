import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/subject_model.dart';

class LessonResourceDialog extends StatefulWidget {
  final ResourceModel? resource;

  const LessonResourceDialog({super.key, this.resource});

  @override
  State<LessonResourceDialog> createState() => _LessonResourceDialogState();
}

class _LessonResourceDialogState extends State<LessonResourceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _urlController;
  String _selectedType = 'pdf';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.resource?.title ?? '');
    _urlController = TextEditingController(text: widget.resource?.url ?? '');
    _selectedType = widget.resource?.type ?? 'pdf';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        widget.resource == null ? 'إضافة مرفق' : 'تعديل المرفق',
        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Selection
              Text('نوع المرفق', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildTypeChip('pdf', 'ملف PDF', Icons.picture_as_pdf),
                  const SizedBox(width: 8),
                  _buildTypeChip('link', 'رابط خارجي', Icons.link),
                ],
              ),
              const SizedBox(height: 16),

              // Title Field
              TextFormField(
                controller: _titleController,
                validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
                decoration: InputDecoration(
                  labelText: 'عنوان المرفق',
                  labelStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),

              // URL Field
              TextFormField(
                controller: _urlController,
                validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
                decoration: InputDecoration(
                  labelText: 'رابط المرفق',
                  labelStyle: GoogleFonts.cairo(),
                  hintText: 'https://...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.link),
                ),
              ),
            ],
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
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            widget.resource == null ? 'إضافة' : 'حفظ',
            style: GoogleFonts.cairo(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeChip(String type, String label, IconData icon) {
    final isSelected = _selectedType == type;
    return InkWell(
      onTap: () => setState(() => _selectedType = type),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? null : Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.cairo(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final resource = ResourceModel(
        id: widget.resource?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        type: _selectedType,
        url: _urlController.text,
      );
      Navigator.pop(context, resource);
    }
  }
}
