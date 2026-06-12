import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';

class EditDocumentsSection extends StatefulWidget {
  const EditDocumentsSection({super.key});

  @override
  State<EditDocumentsSection> createState() => _EditDocumentsSectionState();
}

class _EditDocumentsSectionState extends State<EditDocumentsSection> {
  final List<Map<String, dynamic>> _documents = [
    {
      "name": "Medical Registration Certificate.pdf",
      "type": "Verification Doc",
      "verified": true,
    },
    {
      "name": "MBBS Degree Certificate.pdf",
      "type": "Education Doc",
      "verified": true,
    },
    {
      "name": "MD Degree Certificate.pdf",
      "type": "Education Doc",
      "verified": true,
    },
  ];

  void _simulateUpload() {
    setState(() {
      _documents.add({
        "name": "Additional_Specialization_Doc.pdf",
        "type": "Other Cert",
        "verified": false, // Newly uploaded simulated doc
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Document uploaded successfully!")),
    );
  }

  void _deleteDocument(int index) {
    setState(() {
      _documents.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Document removed.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;
    final fieldBg = isDark ? AppColors.terminalDarkFieldFill : Colors.grey.shade50;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Documents & Certificates",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 14.h),

          // Documents List
          ..._documents.asMap().entries.map((entry) {
            final idx = entry.key;
            final doc = entry.value;
            final isVerified = doc["verified"] as bool;

            return Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: fieldBg,
                border: Border.all(color: borderColor, width: 0.5),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.picture_as_pdf_outlined, color: Colors.red, size: 20.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc["name"] as String,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          doc["type"] as String,
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 9.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Verified badge
                  if (isVerified) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F9F58).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_outlined, color: const Color(0xFF0F9F58), size: 10.sp),
                          SizedBox(width: 4.w),
                          Text(
                            "Verified",
                            style: TextStyle(
                              color: const Color(0xFF0F9F58),
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        "Uploaded",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  IconButton(
                    onPressed: () => _deleteDocument(idx),
                    icon: Icon(Icons.delete_outline, color: AppColors.error, size: 16.sp),
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(28.r, 28.r),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 6.h),

          // Dotted / Premium Upload More Button
          GestureDetector(
            onTap: _simulateUpload,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.4),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, size: 20.sp, color: AppColors.primary),
                  SizedBox(height: 6.h),
                  Text(
                    "Upload More Documents",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                  Text(
                    "PDF, JPG, PNG (Max. 10 MB per file)",
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 9.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
