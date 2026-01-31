import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/subject_model.dart';
import 'package:skool/widgets/content/content_resource_item.dart';

/// A list widget displaying lesson resources.
class ContentResourcesList extends StatelessWidget {
  final List<ResourceModel> resources;
  final void Function(ResourceModel resource)? onResourceTap;

  const ContentResourcesList({
    super.key,
    required this.resources,
    this.onResourceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.picture_as_pdf, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'الملفات الملحقة',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...resources.map((res) => ContentResourceItem(
                resource: res,
                onTap: onResourceTap != null ? () => onResourceTap!(res) : null,
              )),
        ],
      ),
    );
  }
}
