import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/role_drawers.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'package:medi_connect/modules/staff/operations/staff_operations_page.dart';

class StaffDashboardPage extends StatefulWidget {
  const StaffDashboardPage({super.key});

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) context.go(RouteNames.login);
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffold(context),
        drawer: const StaffDrawer(),
        body: const _StaffDashboardBody(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dashboard Body
// ─────────────────────────────────────────────────────────────────────────────
class _StaffDashboardBody extends StatelessWidget {
  const _StaffDashboardBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = 'Staff Member';
        String? profileImage;
        String roleLabel = 'Medical Support';
        final String greeting = _getGreeting();

        if (state is Authenticated) {
          final user = state.user;
          name = user.name ??
              "${user.firstName ?? ''} ${user.lastName ?? ''}".trim();
          if (name.isEmpty) name = 'Staff Member';
          profileImage = user.profileImage;
          roleLabel = user.staffRole ?? user.department ?? 'Medical Support';
        }

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TopBar(
                  name: name,
                  profileImage: profileImage,
                  roleLabel: roleLabel,
                  greeting: greeting,
                  state: state,
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2x2 grid for 4 main cards
                      Row(
                        children: [
                          Expanded(
                            child: _DashCard(
                              icon: Icons.assignment_outlined,
                              title: 'Operations',
                              subtitle:
                                  'Access all department\noperations and activities',
                              gradientColors: const [
                                Color(0xFF3B5BFF),
                                Color(0xFF6A7FFF),
                              ],
                              bgColorLight: const Color(0xFFF0F3FF),
                              bgColorDark: const Color(0xFF0D1A38),
                              accentColor: const Color(0xFF4F2DFF),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<AuthBloc>(),
                                      child: const StaffOperationsPage(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _DashCard(
                              icon: Icons.task_alt_rounded,
                              title: 'Tasks',
                              subtitle:
                                  'View and manage your\nassigned tasks',
                              gradientColors: const [
                                Color(0xFFFF7043),
                                Color(0xFFFFB74D),
                              ],
                              bgColorLight: const Color(0xFFFFF4EE),
                              bgColorDark: const Color(0xFF2E1208),
                              accentColor: const Color(0xFFFF7043),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: _DashCard(
                              icon: Icons.event_available_outlined,
                              title: 'Leave Management',
                              subtitle:
                                  'Apply for leave and\ncheck leave status',
                              gradientColors: const [
                                Color(0xFF00C07A),
                                Color(0xFF00E096),
                              ],
                              bgColorLight: const Color(0xFFEFFFF8),
                              bgColorDark: const Color(0xFF062616),
                              accentColor: const Color(0xFF00C07A),
                              onTap: () {},
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _DashCard(
                              icon: Icons.notifications_outlined,
                              title: 'Notifications',
                              subtitle:
                                  'View announcements\nand important alerts',
                              gradientColors: const [
                                Color(0xFF9B59B6),
                                Color(0xFFBB8FDB),
                              ],
                              bgColorLight: const Color(0xFFF9F0FF),
                              bgColorDark: const Color(0xFF1C0A2E),
                              accentColor: const Color(0xFF9B59B6),
                              notificationCount: 3,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // Full-width settings card
                      const _SettingsDashCard(),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top Banner (Header)
// ─────────────────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final String name;
  final String? profileImage;
  final String roleLabel;
  final String greeting;
  final AuthState state;

  const _TopBar({
    required this.name,
    required this.profileImage,
    required this.roleLabel,
    required this.greeting,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    final monthName = months[now.month - 1];
    final dayName = days[now.weekday - 1];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF060D1F), const Color(0xFF0D1E45)]
              : [const Color(0xFFEAEEFF), const Color(0xFFF5F7FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Decorative plus icons
          Positioned(
            top: 20.h,
            right: 120.w,
            child: Icon(
              Icons.add,
              color: isDark
                  ? Colors.blueAccent.withValues(alpha: 0.2)
                  : Colors.blue.withValues(alpha: 0.15),
              size: 18.r,
            ),
          ),
          Positioned(
            top: 60.h,
            right: 80.w,
            child: Icon(
              Icons.add,
              color: isDark
                  ? Colors.purpleAccent.withValues(alpha: 0.15)
                  : Colors.purple.withValues(alpha: 0.1),
              size: 12.r,
            ),
          ),
          Column(
            children: [
              // AppBar row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    Builder(
                      builder: (ctx) => GestureDetector(
                        onTap: () => Scaffold.of(ctx).openDrawer(),
                        child: Icon(
                          Icons.menu_rounded,
                          color: AppColors.textPrimary(context),
                          size: 26.r,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Logo & branding
                    Row(
                      children: [
                        Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.local_hospital_rounded,
                            color: Colors.white,
                            size: 18.r,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Medi',
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                  fontSize: 18.sp,
                                ),
                              ),
                              TextSpan(
                                text: 'Connect',
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Notification bell with badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.textPrimary(context),
                          size: 26.r,
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            width: 16.r,
                            height: 16.r,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    // Avatar
                    Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.success, width: 2),
                      ),
                      child: ClipOval(
                        child: CustomImageView(
                          imagePath: ProfileImageHelper.resolveImagePath(
                            profileImage,
                            'staff',
                            state is Authenticated ? (state as Authenticated).user.gender : null,
                          ),
                          borderRadius: 18.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Welcome content + date card
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Left: greeting content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  style: AppTextStyles.headingMedium.copyWith(
                                    color: AppColors.textPrimary(context),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text('👋', style: TextStyle(fontSize: 22.sp)),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          // Role badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.person_outline_rounded,
                                  size: 14.r,
                                  color: isDark
                                      ? Colors.white70
                                      : AppColors.primary,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  roleLabel,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : AppColors.primary,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Welcome back! Have a\nproductive day ahead.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary(context),
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),

                    // Right: Date card
                    _DateCard(
                      day: now.day,
                      monthName: monthName,
                      year: now.year,
                      dayName: dayName,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              // Heartbeat line decoration
              _HeartbeatLine(isDark: isDark),
              SizedBox(height: 8.h),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Date Card
// ─────────────────────────────────────────────────────────────────────────────
class _DateCard extends StatelessWidget {
  final int day;
  final String monthName;
  final int year;
  final String dayName;
  final bool isDark;

  const _DateCard({
    required this.day,
    required this.monthName,
    required this.year,
    required this.dayName,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1E3A) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? const Color(0xFF1A3160)
              : const Color(0xFFDDE5F8),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.blue.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_month_rounded,
            color: AppColors.primary,
            size: 20.r,
          ),
          SizedBox(height: 6.h),
          Text(
            '$day',
            style: TextStyle(
              fontSize: 34.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
              height: 1,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '$monthName $year',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            dayName,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Heartbeat Decoration Line
// ─────────────────────────────────────────────────────────────────────────────
class _HeartbeatLine extends StatelessWidget {
  final bool isDark;
  const _HeartbeatLine({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.h,
      width: double.infinity,
      child: CustomPaint(
        painter: _HeartbeatPainter(
          color: isDark
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class _HeartbeatPainter extends CustomPainter {
  final Color color;
  _HeartbeatPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final w = size.width;
    final h = size.height;
    final mid = h / 2;

    path.moveTo(0, mid);
    path.lineTo(w * 0.15, mid);
    path.lineTo(w * 0.2, mid - h * 0.3);
    path.lineTo(w * 0.25, mid + h * 0.4);
    path.lineTo(w * 0.3, mid - h * 0.5);
    path.lineTo(w * 0.35, mid + h * 0.3);
    path.lineTo(w * 0.4, mid);
    path.lineTo(w * 0.55, mid);
    path.lineTo(w * 0.6, mid - h * 0.2);
    path.lineTo(w * 0.65, mid + h * 0.25);
    path.lineTo(w * 0.68, mid - h * 0.3);
    path.lineTo(w * 0.72, mid);
    path.lineTo(w, mid);

    canvas.drawPath(path, paint);

    // Dot at center
    canvas.drawCircle(Offset(w * 0.45, mid), 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Dashboard Card (for 2x2 grid)
// ─────────────────────────────────────────────────────────────────────────────
class _DashCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final Color bgColorLight;
  final Color bgColorDark;
  final Color accentColor;
  final int notificationCount;
  final VoidCallback onTap;

  const _DashCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.bgColorLight,
    required this.bgColorDark,
    required this.accentColor,
    required this.onTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final bg = isDark ? bgColorDark : bgColorLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isDark
                ? accentColor.withValues(alpha: 0.15)
                : accentColor.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon with optional badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 52.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(icon, color: Colors.white, size: 26.r),
                ),
                if (notificationCount > 0)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$notificationCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : accentColor,
              ),
            ),
            SizedBox(height: 4.h),
            // Subtitle
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary(context),
                height: 1.4,
                fontSize: 11.sp,
              ),
            ),
            SizedBox(height: 10.h),
            // Arrow button
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  color: accentColor.withValues(alpha: 0.08),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 14.r,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Settings Full-Width Card
// ─────────────────────────────────────────────────────────────────────────────
class _SettingsDashCard extends StatelessWidget {
  const _SettingsDashCard();

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return GestureDetector(
      onTap: () => context.go(RouteNames.staffSettings),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0D1A38) : const Color(0xFFF0F3FF),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isDark
                ? AppColors.primary.withValues(alpha: 0.15)
                : AppColors.primary.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isDark ? 0.1 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52.r,
              height: 52.r,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F2DFF), Color(0xFF7B61FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.settings_outlined,
                color: Colors.white,
                size: 26.r,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Manage your profile and application preferences',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary(context),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 28.r,
              height: 28.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 14.r,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
