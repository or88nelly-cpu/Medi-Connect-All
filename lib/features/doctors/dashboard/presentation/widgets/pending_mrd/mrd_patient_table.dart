import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/models/mrd_record_display_model.dart';

class MrdPatientTable extends StatelessWidget {
  final List<MrdRecordDisplayModel> records;
  final bool isDark;
  final Color cardBg;
  final Color borderCol;

  const MrdPatientTable({
    super.key,
    required this.records,
    required this.isDark,
    required this.cardBg,
    required this.borderCol,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 32.h),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderCol),
        ),
        child: Column(
          children: [
            Icon(Icons.folder_off_outlined, size: 40.r, color: Colors.grey),
            SizedBox(height: 8.h),
            Text("No pending medical records found matching filters.", style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderCol),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: records.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = records[index];
          return _buildTableRowItem(context, item);
        },
      ),
    );
  }

  Widget _buildTableRowItem(BuildContext context, MrdRecordDisplayModel item) {
    final textCol = isDark ? Colors.white : AppColors.textDarkNavy;
    final secondaryTextCol = isDark ? Colors.white38 : Colors.grey[500];

    // Priority configurations
    Color priorityBg = const Color(0xFFFEF2F2);
    Color priorityText = const Color(0xFFB91C1C);
    IconData priorityIcon = Icons.arrow_upward;
    if (item.priority.toLowerCase() == 'medium') {
      priorityBg = const Color(0xFFFFF7ED);
      priorityText = const Color(0xFFC2410C);
      priorityIcon = Icons.remove;
    } else if (item.priority.toLowerCase() == 'low') {
      priorityBg = const Color(0xFFF0FDF4);
      priorityText = const Color(0xFF15803D);
      priorityIcon = Icons.arrow_downward;
    }

    // Status configurations
    final String displayStatus = item.record.status.toLowerCase() == 'pending' && item.priority.toLowerCase() == 'high'
        ? 'Overdue'
        : 'Pending';

    Color statusBg = const Color(0xFFFFF7ED);
    Color statusText = const Color(0xFFC2410C);
    if (displayStatus.toLowerCase() == 'overdue') {
      statusBg = const Color(0xFFFEF2F2);
      statusText = const Color(0xFFB91C1C);
    } else if (displayStatus.toLowerCase() == 'returned') {
      statusBg = const Color(0xFFEFF6FF);
      statusText = const Color(0xFF1D4ED8);
    }

    final mrdNo = 'MRD${126578 + item.record.id}';

    return Padding(
      padding: EdgeInsets.all(12.r),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                backgroundImage: ProfileImageHelper.getAvatarImage(
                  item.patientPhoto,
                  'patient',
                  item.patientGender,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.patientName,
                      style: TextStyle(color: textCol, fontSize: 11.5.sp, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${item.patientAge} Years • ${item.patientGender}",
                      style: TextStyle(color: secondaryTextCol, fontSize: 9.sp),
                    ),
                    Text(
                      item.ipdLocation,
                      style: TextStyle(color: secondaryTextCol, fontSize: 9.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  mrdNo,
                  style: TextStyle(color: const Color(0xFF0F6FFF), fontSize: 11.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.record.recordType,
                      style: TextStyle(color: textCol, fontSize: 10.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.ipdLocation,
                      style: TextStyle(color: secondaryTextCol, fontSize: 8.5.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: priorityBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  children: [
                    Icon(priorityIcon, size: 10.r, color: priorityText),
                    SizedBox(width: 2.w),
                    Text(
                      item.priority,
                      style: TextStyle(color: priorityText, fontSize: 9.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.pendingSince,
                    style: TextStyle(color: textCol, fontSize: 9.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "27 Jun, 2026",
                    style: TextStyle(color: secondaryTextCol, fontSize: 8.sp),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  displayStatus,
                  style: TextStyle(color: statusText, fontSize: 9.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Loading MRD document: $mrdNo"),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility, size: 12),
                    label: const Text("View"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0F6FFF),
                      side: const BorderSide(color: Color(0xFF0F6FFF)),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, size: 16),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
