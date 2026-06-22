import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:intl/intl.dart';

class AttendanceProximityDialog extends StatefulWidget {
  final UserModel user;
  final VoidCallback onAttendanceMarked;

  const AttendanceProximityDialog({
    super.key,
    required this.user,
    required this.onAttendanceMarked,
  });

  @override
  State<AttendanceProximityDialog> createState() => _AttendanceProximityDialogState();
}

class _AttendanceProximityDialogState extends State<AttendanceProximityDialog>
    with SingleTickerProviderStateMixin {
  bool _isInsideHospital = true;
  bool _isSubmitting = false;
  late AnimationController _pulseController;

  // Hospital Geolocation
  static const double hospitalLat = 12.9716;
  static const double hospitalLng = 77.5946;

  // Mocked Staff Locations
  // Inside: 45 meters away
  static const double insideLat = 12.9719;
  static const double insideLng = 77.5941;
  // Outside: 5.2 km away
  static const double outsideLat = 13.0210;
  static const double outsideLng = 77.5620;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _submitAttendance() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final supabase = GetIt.I<SupabaseService>();
      final now = DateTime.now();
      final timeStr = DateFormat('hh:mm a').format(now);
      final dateStr = now.toIso8601String().split('T').first;

      final staffName = widget.user.name ??
          "${widget.user.firstName ?? ''} ${widget.user.lastName ?? ''}".trim();

      await supabase.from('staff_attendance').insert({
        'staff_id': widget.user.id,
        'staff_name': staffName.isNotEmpty ? staffName : 'Staff Member',
        'role': widget.user.staffRole ?? widget.user.department ?? 'Staff',
        'status': 'Present',
        'check_in_time': timeStr,
        'date': dateStr,
      });

      if (mounted) {
        Navigator.of(context).pop();
        widget.onAttendanceMarked();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 8.w),
                const Text("Attendance marked successfully!"),
              ],
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to mark attendance: $e"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    final currentLat = _isInsideHospital ? insideLat : outsideLat;
    final currentLng = _isInsideHospital ? insideLng : outsideLng;
    final distance = _isInsideHospital ? "45 meters" : "5.2 km";
    final isAllowed = _isInsideHospital;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      backgroundColor: cardBg,
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Proximity Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.location_on_rounded, color: AppColors.primary, size: 24.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    "Check Attendance",
                    style: AppTextStyles.titleLarge.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Radar Scan Proximity Circle Animation
            Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Radial pulses
                      Container(
                        width: 80.r + (24.r * _pulseController.value),
                        height: 80.r + (24.r * _pulseController.value),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (isAllowed ? AppColors.success : AppColors.error).withValues(
                            alpha: 0.15 * (1.0 - _pulseController.value),
                          ),
                        ),
                      ),
                      Container(
                        width: 60.r + (16.r * _pulseController.value),
                        height: 60.r + (16.r * _pulseController.value),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (isAllowed ? AppColors.success : AppColors.error).withValues(
                            alpha: 0.25 * (1.0 - _pulseController.value),
                          ),
                        ),
                      ),
                      // Core Icon Indicator
                      CircleAvatar(
                        radius: 26.r,
                        backgroundColor: (isAllowed ? AppColors.success : AppColors.error).withValues(
                          alpha: 0.15,
                        ),
                        child: Icon(
                          isAllowed ? Icons.verified_user_rounded : Icons.gpp_bad_rounded,
                          color: isAllowed ? AppColors.success : AppColors.error,
                          size: 28.r,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),

            // Mock Coordinates Info Box
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Hospital Location:", style: TextStyle(color: labelColor, fontSize: 11.sp)),
                      Text(
                        "$hospitalLat, $hospitalLng",
                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Your Mock Location:", style: TextStyle(color: labelColor, fontSize: 11.sp)),
                      Text(
                        "$currentLat, $currentLng",
                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11.sp),
                      ),
                    ],
                  ),
                  Divider(color: borderColor, height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Proximity Distance:", style: TextStyle(color: labelColor, fontSize: 11.sp)),
                      Text(
                        distance,
                        style: TextStyle(
                          color: isAllowed ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Simulation Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Location Simulation:",
                  style: AppTextStyles.bodyMedium.copyWith(color: textColor, fontWeight: FontWeight.w600),
                ),
                Switch(
                  value: _isInsideHospital,
                  onChanged: (val) {
                    setState(() {
                      _isInsideHospital = val;
                    });
                  },
                  activeThumbColor: AppColors.success,
                ),
              ],
            ),
            Text(
              _isInsideHospital
                  ? "Simulating coordinates inside Medicare Hospital (Match)."
                  : "Simulating coordinates outside the hospital (No Match).",
              style: TextStyle(color: labelColor, fontSize: 10.sp),
            ),
            SizedBox(height: 20.h),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: TextStyle(color: labelColor)),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: (!isAllowed || _isSubmitting) ? null : _submitAttendance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.grey.shade400,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          width: 16.r,
                          height: 16.r,
                          child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text("Check In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
