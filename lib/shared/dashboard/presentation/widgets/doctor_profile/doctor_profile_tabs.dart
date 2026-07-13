import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class DoctorProfileTabs {
  static Widget buildPatientsTab(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.surface : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    final metadataConsultations = null;
    final List<Map<String, dynamic>> patients = [];
    final Set<String> uniqueNames = {};

    if (metadataConsultations != null) {
      for (var item in metadataConsultations) {
        if (item is Map) {
          final name = (item['name'] ?? '').toString();
          if (name.isNotEmpty && !uniqueNames.contains(name)) {
            uniqueNames.add(name);
            patients.add({
              'name': name,
              'age': int.tryParse(item['age']?.toString() ?? '') ?? 30,
              'gender': (item['gender'] ?? 'Male').toString(),
              'lastVisit': (item['time'] ?? '09:00 AM').toString(),
              'type': (item['type'] ?? 'Regular').toString(),
            });
          }
        }
      }
    }

    if (patients.isEmpty) {
      patients.addAll([
        {
          'name': 'Ramesh Kumar',
          'age': 45,
          'gender': 'Male',
          'lastVisit': '10:00 AM',
          'type': 'Follow Up',
        },
        {
          'name': 'Anita Sharma',
          'age': 38,
          'gender': 'Female',
          'lastVisit': '09:20 AM',
          'type': 'New Consultation',
        },
        {
          'name': 'Vikram Singh',
          'age': 52,
          'gender': 'Male',
          'lastVisit': '09:40 AM',
          'type': 'Follow Up',
        },
        {
          'name': 'Pooja Mehta',
          'age': 29,
          'gender': 'Female',
          'lastVisit': '11:00 AM',
          'type': 'New Consultation',
        },
      ]);
    }

    return Card(
      elevation: 0,
      color: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Consulted Patients",
              style: AppTextStyles.titleMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: patients.length,
              separatorBuilder: (context, idx) =>
                  Divider(color: borderColor, height: 1),
              itemBuilder: (context, idx) {
                final p = patients[idx];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: isDark
                        ? AppColors.surface10
                        : Colors.black12,
                    child: Icon(
                      p['gender'] == 'Male' ? Icons.male : Icons.female,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    p['name']!,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                  subtitle: Text(
                    "Age: ${p['age']} Ã¢â‚¬Â¢ ${p['gender']} Ã¢â‚¬Â¢ Last Visit: ${p['lastVisit']}",
                    style: TextStyle(color: labelColor, fontSize: 11.sp),
                  ),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      p['type']!,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildDocumentsTab(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.surface : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    final metadataDocs = null;
    final List<Map<String, dynamic>> documents = [];
    if (metadataDocs != null) {
      for (var item in metadataDocs) {
        if (item is Map) {
          documents.add({
            'name': (item['name'] ?? '').toString(),
            'issueDate': (item['issueDate'] ?? '').toString(),
            'status': (item['status'] ?? '').toString(),
          });
        }
      }
    }

    if (documents.isEmpty) {
      documents.addAll([
        {
          'name': 'Medical Registration Certificate',
          'issueDate': '12 Jan 2018',
          'status': 'Verified',
        },
        {
          'name': 'Specialization Degree (MD)',
          'issueDate': '24 Jun 2021',
          'status': 'Verified',
        },
        {
          'name': 'Board Certification in Medicine',
          'issueDate': '15 Aug 2022',
          'status': 'Verified',
        },
      ]);
    }

    return Card(
      elevation: 0,
      color: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Verification Documents",
                  style: AppTextStyles.titleMedium.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => showUploadDocumentDialog(context),
                  icon: const Icon(Icons.upload, size: 14),
                  label: const Text("Upload Doc"),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: documents.length,
              separatorBuilder: (context, idx) =>
                  Divider(color: borderColor, height: 1),
              itemBuilder: (context, idx) {
                final d = documents[idx];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.verified_user,
                    color: AppColors.success,
                    size: 24.sp,
                  ),
                  title: Text(
                    d['name']!,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                  subtitle: Text(
                    "Issued: ${d['issueDate']} Ã¢â‚¬Â¢ Status: ${d['status']}",
                    style: TextStyle(color: labelColor, fontSize: 11.sp),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: AppColors.primary,
                      size: 18.sp,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Viewing ${d['name']}...")),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static void showUploadDocumentDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Upload Verification Document"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Document Name",
              hintText: "e.g. Fellowship Certificate",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final docName = controller.text.trim();
                if (docName.isEmpty) return;
                Navigator.pop(ctx);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Document '$docName' uploaded successfully"),
                  ),
                );
              },
              child: const Text("Upload"),
            ),
          ],
        );
      },
    );
  }
}
