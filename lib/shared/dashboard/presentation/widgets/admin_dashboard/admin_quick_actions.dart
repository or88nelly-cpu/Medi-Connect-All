import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/navigation/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/items/quick_action_item.dart';

import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/models/quick_action_data.dart';

class AdminQuickActionsGrid extends StatefulWidget {
  final bool isExpanded;
  const AdminQuickActionsGrid({super.key, this.isExpanded = false});

  @override
  State<AdminQuickActionsGrid> createState() => _AdminQuickActionsGridState();
}

class _AdminQuickActionsGridState extends State<AdminQuickActionsGrid> {
  final List<QuickActionData> quickActions = const [
    QuickActionData(
      title: "Register\nPatient",
      icon: Icons.person_add,
      color: Color(0xFF7928CA), // Purple
      route: RouteNames.patientRegistration,
    ),
    QuickActionData(
      title: "Add\nDoctor",
      icon: Icons.medical_services,
      color: Color(0xFF0F6FFF), // Blue
      route: '/admin/doctor-staff/create', // TODO: Pass correct params if needed, or route to staff page
    ),
    QuickActionData(
      title: "Add\nEmployee",
      icon: Icons.group_add,
      color: Color(0xFF22C55E), // Green
      route: '/admin/staff',
    ),
    QuickActionData(
      title: "New\nAppointment",
      icon: Icons.event_available,
      color: Color(0xFFFF8A26), // Orange
      route: RouteNames.patientSearch,
    ),
    QuickActionData(
      title: "Admit\nPatient",
      icon: Icons.bed,
      color: Color(0xFFEC4899), // Pink
      route: RouteNames.patientSearch,
    ),
    QuickActionData(
      title: "Generate\nBill",
      icon: Icons.receipt_long,
      color: Color(0xFF14B8A6), // Teal
      route: '/admin/dashboard', // Fallback
    ),
    QuickActionData(
      title: "Add\nMedicine",
      icon: Icons.medication,
      color: Color(0xFF8B5CF6), // Purple/Indigo
      route: '/admin/pharmacy',
    ),
    QuickActionData(
      title: "Reports",
      icon: Icons.assignment,
      color: Color(0xFFEAB308), // Yellow
      route: '/admin/reports', // Fallback
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt, color: AppColors.adminPrimary, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                "Quick Actions", // Fallback string
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.dashboardTextPrimary(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Builder(
            builder: (context) {
              Widget grid = GridView.builder(
                shrinkWrap: !widget.isExpanded,
                physics: widget.isExpanded ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.9, // Changed from 0.75 to 0.9 to make them shorter and prevent clipping
                ),
                itemCount: quickActions.length,
                itemBuilder: (context, index) {
                  final action = quickActions[index];

                  return QuickActionItem(
                    title: action.title,
                    iconData: action.icon,
                    color: action.color,
                    isDark: isDark,
                    onTap: () {
                      if (action.route.isNotEmpty) {
                        // For Add Doctor we need to pass extra params if we use pushNamed
                        if (action.route == '/admin/doctor-staff/create') {
                          context.pushNamed(
                            '/admin/doctor-staff/create',
                            extra: {'role': 'doctor', 'department': 'General'},
                          );
                        } else {
                          try {
                            context.push(action.route);
                          } catch (e) {
                            // Fallback if route fails
                          }
                        }
                      }
                    },
                  );
                },
              );
              
              Widget content = Column(
                children: [
                  if (widget.isExpanded) Expanded(child: grid) else grid,
                  SizedBox(height: 16.h),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.keyboard_arrow_down, size: 16.sp, color: AppColors.textSecondary(context)),
                          SizedBox(width: 4.w),
                          Text("More Actions", style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary(context))),
                          SizedBox(width: 4.w),
                          Icon(Icons.arrow_forward, size: 16.sp, color: AppColors.textSecondary(context)),
                        ],
                      ),
                    ),
                  ),
                ],
              );

              if (widget.isExpanded) {
                return Expanded(child: content);
              } else {
                return content;
              }
            }
          )
        ],
      ),
    );
  }
}
