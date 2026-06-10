import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _darkMode = false;
  bool _pushNotifications = true;
  bool _smsAlerts = false;
  bool _emailReports = true;
  bool _biometricLogin = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Settings",
            style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp),
          ),
          SizedBox(height: 20.h),
          _buildCategoryHeader("General Preferences"),
          _buildSwitchTile(
            title: "Dark Mode",
            subtitle: "Enable dark theme across the application",
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
            icon: Icons.dark_mode_outlined,
          ),
          _buildSwitchTile(
            title: "Push Notifications",
            subtitle: "Receive alerts for appointments and events",
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
            icon: Icons.notifications_active_outlined,
          ),
          SizedBox(height: 16.h),
          _buildCategoryHeader("Security & Login"),
          _buildSwitchTile(
            title: "Biometric Login",
            subtitle: "Use Face ID / Fingerprint to sign in",
            value: _biometricLogin,
            onChanged: (val) => setState(() => _biometricLogin = val),
            icon: Icons.fingerprint_outlined,
          ),
          SizedBox(height: 16.h),
          _buildCategoryHeader("Communication channels"),
          _buildSwitchTile(
            title: "SMS Alerts",
            subtitle: "Send booking updates via SMS",
            value: _smsAlerts,
            onChanged: (val) => setState(() => _smsAlerts = val),
            icon: Icons.sms_outlined,
          ),
          _buildSwitchTile(
            title: "Email Reports",
            subtitle: "Receive daily pharmacy and revenue reports",
            value: _emailReports,
            onChanged: (val) => setState(() => _emailReports = val),
            icon: Icons.email_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AppColors.border),
      ),
      child: SwitchListTile(
        activeColor: AppColors.primary,
        secondary: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20.r),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
