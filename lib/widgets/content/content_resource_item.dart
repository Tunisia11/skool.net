import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/subject_model.dart';

/// A single resource item widget.
class ContentResourceItem extends StatelessWidget {
  final ResourceModel resource;
  final VoidCallback? onTap;

  const ContentResourceItem({
    super.key,
    required this.resource,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.file_download_outlined, color: Colors.blue, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                resource.title,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(Icons.lock, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
