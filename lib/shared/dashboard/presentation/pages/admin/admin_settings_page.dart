import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/theme/theme_cubit.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_settings_bloc.dart';

class AdminSettingsPage extends StatefulWidget {
  final bool isStandalone;
  const AdminSettingsPage({super.key, this.isStandalone = false});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminSettingsBloc>().add(LoadAdminSettings());
  }

  @override
  Widget build(BuildContext context) {
    final Widget settingsBody =
        BlocBuilder<AdminSettingsBloc, AdminSettingsState>(
          builder: (context, state) {
            if (state is AdminSettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AdminSettingsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(color: AppColors.error),
                    ),
                    SizedBox(height: 12.h),
                    ElevatedButton(
                      onPressed: () => context.read<AdminSettingsBloc>().add(
                        LoadAdminSettings(),
                      ),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            if (state is AdminSettingsLoaded) {
              final settings = state.settings;
              final pushNotifications =
                  settings['push_notifications'] as bool? ?? false;
              final smsAlerts = settings['sms_alerts'] as bool? ?? false;
              final emailReports = settings['email_reports'] as bool? ?? false;
              final biometricLogin =
                  settings['biometric_login'] as bool? ?? false;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!widget.isStandalone) ...[
                      Text(
                        "Settings",
                        style: AppTextStyles.headingMedium.copyWith(
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                    _buildCategoryHeader("General Preferences"),
                    BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, themeMode) {
                        final isDark = themeMode == ThemeMode.dark;
                        return _buildSwitchTile(
                          title: "Dark Mode",
                          subtitle: "Enable dark theme across the application",
                          value: isDark,
                          onChanged: (val) {
                            context.read<ThemeCubit>().setThemeMode(
                              val ? ThemeMode.dark : ThemeMode.light,
                            );
                          },
                          icon: Icons.dark_mode_outlined,
                        );
                      },
                    ),
                    _buildSwitchTile(
                      title: "Push Notifications",
                      subtitle: "Receive alerts for appointments and events",
                      value: pushNotifications,
                      onChanged: (val) {
                        context.read<AdminSettingsBloc>().add(
                          UpdateAdminSetting('push_notifications', val),
                        );
                      },
                      icon: Icons.notifications_active_outlined,
                    ),
                    SizedBox(height: 16.h),
                    _buildCategoryHeader("Security & Login"),
                    _buildSwitchTile(
                      title: "Biometric Login",
                      subtitle: "Use Face ID / Fingerprint to sign in",
                      value: biometricLogin,
                      onChanged: (val) {
                        context.read<AdminSettingsBloc>().add(
                          UpdateAdminSetting('biometric_login', val),
                        );
                      },
                      icon: Icons.fingerprint_outlined,
                    ),
                    SizedBox(height: 16.h),
                    _buildCategoryHeader("Communication channels"),
                    _buildSwitchTile(
                      title: "SMS Alerts",
                      subtitle: "Send booking updates via SMS",
                      value: smsAlerts,
                      onChanged: (val) {
                        context.read<AdminSettingsBloc>().add(
                          UpdateAdminSetting('sms_alerts', val),
                        );
                      },
                      icon: Icons.sms_outlined,
                    ),
                    _buildSwitchTile(
                      title: "Email Reports",
                      subtitle: "Receive daily pharmacy and revenue reports",
                      value: emailReports,
                      onChanged: (val) {
                        context.read<AdminSettingsBloc>().add(
                          UpdateAdminSetting('email_reports', val),
                        );
                      },
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(height: 24.h),
                    _buildCategoryHeader("Account"),
                    _buildLogoutTile(context),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        );

    if (widget.isStandalone) {
      return CustomScaffold(
        customAppbar: const CommonAppBar(title: "Settings"),
        body: settingsBody,
      );
    }
    return settingsBody;
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
        side: BorderSide(color: AppColors.border(context)),
      ),
      child: SwitchListTile(
        activeThumbColor: AppColors.primary,
        secondary: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20.r),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go(RouteNames.login);
        }
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.logout_rounded,
              color: AppColors.error,
              size: 20.r,
            ),
          ),
          title: Text(
            "Log Out",
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          subtitle: Text(
            "Sign out of your account",
            style: AppTextStyles.bodySmall,
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: AppColors.error.withValues(alpha: 0.6),
          ),
          onTap: () => _showLogoutConfirmation(context),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.error, size: 24.r),
            SizedBox(width: 10.w),
            Text(
              "Log Out",
              style: AppTextStyles.headingMedium.copyWith(fontSize: 18.sp),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to log out? You will need to sign in again to access your account.",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              "Cancel",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: Text(
              "Log Out",
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
