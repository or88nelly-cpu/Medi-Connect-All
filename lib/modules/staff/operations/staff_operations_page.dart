import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';

class StaffOperationsPage extends StatelessWidget {
  const StaffOperationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String departmentTitle = 'Staff';
        if (state is Authenticated) {
          final dept = state.user.department;
          if (dept != null && dept.isNotEmpty) {
            departmentTitle = dept;
          }
        }

        return Scaffold(
          backgroundColor: AppColors.scaffold(context),
          appBar: AppBar(
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary(context),
                size: 20.r,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  departmentTitle,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  'Operations',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1.h),
              child: Divider(
                height: 1,
                color: AppColors.border(context),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(title: 'Quick Actions'),
                SizedBox(height: 12.h),
                _OperationsQuickActionsGrid(isDark: isDark),
                SizedBox(height: 24.h),
                _SectionHeader(title: 'Department Overview'),
                SizedBox(height: 12.h),
                _DepartmentOverviewCard(isDark: isDark),
                SizedBox(height: 24.h),
                _SectionHeader(title: 'Recent Activities'),
                SizedBox(height: 12.h),
                _RecentActivitiesList(isDark: isDark),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary(context),
        fontSize: 16.sp,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick Actions Grid
// ─────────────────────────────────────────────────────────────────────────────
class _OperationsQuickActionsGrid extends StatelessWidget {
  final bool isDark;
  const _OperationsQuickActionsGrid({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickActionData(
        icon: Icons.assignment_outlined,
        label: 'Daily Reports',
        gradient: [const Color(0xFF4F2DFF), const Color(0xFF7B61FF)],
      ),
      _QuickActionData(
        icon: Icons.people_outline_rounded,
        label: 'Staff Roster',
        gradient: [const Color(0xFF00C2A8), const Color(0xFF14B8A6)],
      ),
      _QuickActionData(
        icon: Icons.inventory_2_outlined,
        label: 'Inventory',
        gradient: [const Color(0xFFFF8A26), const Color(0xFFFFB547)],
      ),
      _QuickActionData(
        icon: Icons.bar_chart_rounded,
        label: 'Analytics',
        gradient: [const Color(0xFFEC4899), const Color(0xFFFF0080)],
      ),
      _QuickActionData(
        icon: Icons.local_hospital_outlined,
        label: 'Patient Flow',
        gradient: [const Color(0xFF22C55E), const Color(0xFF16A34A)],
      ),
      _QuickActionData(
        icon: Icons.settings_outlined,
        label: 'Config',
        gradient: [const Color(0xFF3B82F6), const Color(0xFF0F6FFF)],
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1,
      ),
      itemCount: actions.length,
      itemBuilder: (context, i) => _QuickActionCard(data: actions[i], isDark: isDark),
    );
  }
}

class _QuickActionData {
  final IconData icon;
  final String label;
  final List<Color> gradient;

  const _QuickActionData({
    required this.icon,
    required this.label,
    required this.gradient,
  });
}

class _QuickActionCard extends StatelessWidget {
  final _QuickActionData data;
  final bool isDark;
  const _QuickActionCard({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.border(context)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow(context),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: data.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                data.icon,
                color: Colors.white,
                size: 22.r,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              data.label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
                fontSize: 11.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Department Overview Card
// ─────────────────────────────────────────────────────────────────────────────
class _DepartmentOverviewCard extends StatelessWidget {
  final bool isDark;
  const _DepartmentOverviewCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatItem(label: 'Active Staff', value: '12', color: AppColors.success),
      _StatItem(label: 'On Leave', value: '3', color: AppColors.warning),
      _StatItem(label: 'Pending Tasks', value: '8', color: AppColors.error),
      _StatItem(label: 'Completed', value: '24', color: AppColors.primary),
    ];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F2DFF), Color(0xFF7B61FF)],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.domain_outlined,
                  color: Colors.white,
                  size: 20.r,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Department Status',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  Text(
                    'Today\'s overview',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: stats
                .map(
                  (s) => Expanded(
                    child: _StatBox(item: s),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final Color color;
  const _StatItem({required this.label, required this.value, required this.color});
}

class _StatBox extends StatelessWidget {
  final _StatItem item;
  const _StatBox({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          item.value,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: item.color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          item.label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary(context),
            fontSize: 10.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Recent Activities List
// ─────────────────────────────────────────────────────────────────────────────
class _RecentActivitiesList extends StatelessWidget {
  final bool isDark;
  const _RecentActivitiesList({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final activities = [
      _ActivityItem(
        icon: Icons.check_circle_outline,
        title: 'Room 3 sanitized',
        subtitle: 'Completed · 10 min ago',
        color: AppColors.success,
      ),
      _ActivityItem(
        icon: Icons.assignment_late_outlined,
        title: 'Stock checklist overdue',
        subtitle: 'Pending · Block A',
        color: AppColors.warning,
      ),
      _ActivityItem(
        icon: Icons.person_add_alt_1_outlined,
        title: 'New patient admitted',
        subtitle: 'Ward 2B · 45 min ago',
        color: AppColors.primary,
      ),
      _ActivityItem(
        icon: Icons.local_pharmacy_outlined,
        title: 'Lab reagents received',
        subtitle: 'Confirmed · 1h ago',
        color: AppColors.teal,
      ),
      _ActivityItem(
        icon: Icons.warning_amber_outlined,
        title: 'Equipment maintenance alert',
        subtitle: 'ICU · Needs attention',
        color: AppColors.error,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: AppColors.border(context)),
        itemBuilder: (context, i) => _ActivityTile(item: activities[i]),
      ),
    );
  }
}

class _ActivityItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class _ActivityTile extends StatelessWidget {
  final _ActivityItem item;
  const _ActivityTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      leading: Container(
        width: 36.r,
        height: 36.r,
        decoration: BoxDecoration(
          color: item.color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(item.icon, color: item.color, size: 18.r),
      ),
      title: Text(
        item.title,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary(context),
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary(context),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary(context),
        size: 20.r,
      ),
    );
  }
}
