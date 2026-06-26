import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_event.dart';

import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/apply_leave_bottom_sheet.dart';

class DoctorLeaveCard extends StatefulWidget {
  final UserModel user;
  const DoctorLeaveCard({super.key, required this.user});

  @override
  State<DoctorLeaveCard> createState() => _DoctorLeaveCardState();
}

class _DoctorLeaveCardState extends State<DoctorLeaveCard> {
  void _approveLeave(Map<String, String> targetLeave) {
    final updatedMetadata = Map<String, dynamic>.from(
      widget.user.metadata ?? {},
    );
    final currentLeaves = List<dynamic>.from(updatedMetadata['leaves'] ?? []);

    final updatedLeaves = currentLeaves.map((l) {
      final map = Map<String, dynamic>.from(l as Map);
      if (map['type'] == targetLeave['type'] &&
          map['range'] == targetLeave['range']) {
        map['status'] = 'Approved';
      }
      return map;
    }).toList();

    updatedMetadata['leaves'] = updatedLeaves;
    final updatedUser = widget.user.copyWith(metadata: updatedMetadata);

    context.read<DoctorStaffBloc>().add(UpdateDoctorStaffMember(updatedUser));

    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated && authState.user.id == widget.user.id) {
      context.read<AuthBloc>().add(UserUpdated(updatedUser));
    }
  }

  void _rejectLeave(Map<String, String> targetLeave) {
    final updatedMetadata = Map<String, dynamic>.from(
      widget.user.metadata ?? {},
    );
    final currentLeaves = List<dynamic>.from(updatedMetadata['leaves'] ?? []);

    final updatedLeaves = currentLeaves.where((l) {
      final map = l as Map;
      return !(map['type'] == targetLeave['type'] &&
          map['range'] == targetLeave['range']);
    }).toList();

    updatedMetadata['leaves'] = updatedLeaves;
    final updatedUser = widget.user.copyWith(metadata: updatedMetadata);

    context.read<DoctorStaffBloc>().add(UpdateDoctorStaffMember(updatedUser));

    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated && authState.user.id == widget.user.id) {
      context.read<AuthBloc>().add(UserUpdated(updatedUser));
    }
  }

  List<Map<String, String>> get _leaves {
    final metadataLeaves = widget.user.metadata?['leaves'] as List<dynamic>?;
    if (metadataLeaves != null) {
      return metadataLeaves.map((l) {
        final map = l as Map<dynamic, dynamic>;
        return {
          "type": (map["type"] ?? "").toString(),
          "range": (map["range"] ?? "").toString(),
          "status": (map["status"] ?? "").toString(),
        };
      }).toList();
    }
    return [
      {
        "type": "Annual Leave",
        "range": "20 May 2025 - 25 May 2025",
        "status": "Approved",
      },
      {"type": "Casual Leave", "range": "05 Jun 2025", "status": "Pending"},
    ];
  }

  void _showApplyLeaveDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ApplyLeaveBottomSheet(
        onLeaveApplied: (leave) {
          final updatedMetadata = Map<String, dynamic>.from(
            widget.user.metadata ?? {},
          );
          final currentLeaves = List<dynamic>.from(
            updatedMetadata['leaves'] ??
                [
                  {
                    "type": "Annual Leave",
                    "range": "20 May 2025 - 25 May 2025",
                    "status": "Approved",
                  },
                  {
                    "type": "Casual Leave",
                    "range": "05 Jun 2025",
                    "status": "Pending",
                  },
                ],
          );
          currentLeaves.add(leave);
          updatedMetadata['leaves'] = currentLeaves;
          final updatedUser = widget.user.copyWith(metadata: updatedMetadata);

          context.read<DoctorStaffBloc>().add(
            UpdateDoctorStaffMember(updatedUser),
          );

          final authState = context.read<AuthBloc>().state;
          if (authState is Authenticated &&
              authState.user.id == widget.user.id) {
            context.read<AuthBloc>().add(UserUpdated(updatedUser));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

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
          // Header with link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Leave Management",
                style: AppTextStyles.titleMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Showing all leaves...")),
                  );
                },
                child: Text(
                  "View All",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Leaves list
          ..._leaves.map((leave) {
            final isApproved = leave["status"] == "Approved";
            final isPending = leave["status"] == "Pending";
            final statusColor = isApproved
                ? const Color(0xFF0F9F58)
                : AppColors.warning;

            final authState = context.watch<AuthBloc>().state;
            final isAdmin =
                authState is Authenticated && authState.user.role == 'admin';

            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 0.5),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          leave["type"]!,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          leave["range"]!,
                          style: TextStyle(color: labelColor, fontSize: 11.sp),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: statusColor, width: 0.5),
                        ),
                        child: Text(
                          leave["status"]!,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isPending && isAdmin) ...[
                        SizedBox(width: 8.w),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.check_circle_outline,
                            color: const Color(0xFF0F9F58),
                            size: 20.sp,
                          ),
                          onPressed: () => _approveLeave(leave),
                          tooltip: 'Approve Leave',
                        ),
                        SizedBox(width: 6.w),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: AppColors.error,
                            size: 20.sp,
                          ),
                          onPressed: () => _rejectLeave(leave),
                          tooltip: 'Reject Leave',
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 4.h),
          // Apply Leave Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _showApplyLeaveDialog,
              icon: Icon(Icons.add, size: 14.sp, color: AppColors.primary),
              label: Text(
                "Apply Leave",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
