import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/features/admin/home/presentation/widgets/admin_header_artwork.dart';
import 'package:medi_connect/features/admin/home/presentation/widgets/admin_header_search_bar.dart';
import 'package:medi_connect/features/admin/home/presentation/widgets/admin_notification_bell.dart';
import 'package:medi_connect/features/admin/home/presentation/widgets/admin_profile_chip.dart';
import 'package:medi_connect/features/authentication/domain/entities/user_entity.dart';

/// Header: top-bar + gradient title + subtitle + search + hospital artwork.
class AdminControlCenterHeader extends StatefulWidget {
  final UserEntity? user;
  const AdminControlCenterHeader({super.key, this.user});

  @override
  State<AdminControlCenterHeader> createState() =>
      _AdminControlCenterHeaderState();
}

class _AdminControlCenterHeaderState extends State<AdminControlCenterHeader> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Top bar ─────────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.welcomeBackAdmin,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
            Row(
              children: [
                AdminNotificationBell(isDark: isDark),
                SizedBox(width: 10.w),
                AdminProfileChip(
                  user: widget.user,
                  isDark: isDark,
                  showLabel: !isMobile,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // ── Hero banner ─────────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Two-line gradient title
                  Text(
                    'Hospital',
                    style: TextStyle(
                      fontSize: isMobile ? 28.sp : 36.sp,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      color: isDark ? Colors.white : AppColors.textDarkNavy,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [
                        AppColors.controlCenterBlue,
                        AppColors.controlCenterPurple,
                      ],
                    ).createShader(b),
                    child: Text(
                      'Control Center',
                      style: TextStyle(
                        fontSize: isMobile ? 28.sp : 36.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    AppStrings.controlCenterSubtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      height: 1.4,
                      color: isDark ? Colors.white54 : Colors.grey.shade500,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  AdminHeaderSearchBar(controller: _searchCtrl),
                ],
              ),
            ),
            if (!isMobile) ...[
              SizedBox(width: 16.w),
              const AdminHeaderArtwork(),
            ],
          ],
        ),
      ],
    );
  }
}
