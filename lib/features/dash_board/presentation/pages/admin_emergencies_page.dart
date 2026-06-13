import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/domain/entities/emergency_entity.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin_emergencies_bloc.dart';

class AdminEmergenciesPage extends StatefulWidget {
  const AdminEmergenciesPage({super.key});

  @override
  State<AdminEmergenciesPage> createState() => _AdminEmergenciesPageState();
}

class _AdminEmergenciesPageState extends State<AdminEmergenciesPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminEmergenciesBloc>().add(LoadEmergencies());
  }

  void _showTriggerEmergencyDialog() {
    final messageController = TextEditingController();
    String level = "Critical";
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Trigger Emergency Alert"),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: messageController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Emergency Message",
                        hintText: "e.g., Code Blue in Room 204",
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Required field" : null,
                    ),
                    SizedBox(height: 12.h),
                    DropdownButtonFormField<String>(
                      value: level,
                      decoration: const InputDecoration(labelText: "Emergency Level"),
                      items: ["Medium", "High", "Critical"].map((lvl) {
                        return DropdownMenuItem(value: lvl, child: Text(lvl));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => level = val);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<AdminEmergenciesBloc>().add(
                            TriggerEmergency({
                              'message': messageController.text.trim(),
                              'level': level,
                              'is_resolved': false,
                            }),
                          );
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text("Trigger"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showResolveConfirmDialog(EmergencyEntity emergency) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Resolve Emergency?"),
          content: Text("Are you sure you want to mark this emergency alert as resolved?\n\n\"${emergency.message}\""),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AdminEmergenciesBloc>().add(
                      ResolveEmergency(emergency.id),
                    );
                Navigator.pop(ctx);
              },
              child: const Text("Yes, Resolve"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      customAppbar: CommonAppBar(
        title: "Active Emergencies",
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert, color: AppColors.error),
            onPressed: _showTriggerEmergencyDialog,
          ),
        ],
      ),
      body: BlocBuilder<AdminEmergenciesBloc, AdminEmergenciesState>(
        builder: (context, state) {
          if (state is AdminEmergenciesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AdminEmergenciesError) {
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
                    onPressed: () =>
                        context.read<AdminEmergenciesBloc>().add(LoadEmergencies()),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (state is AdminEmergenciesLoaded) {
            final list = state.emergencies;
            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 64, color: AppColors.success),
                    SizedBox(height: 12.h),
                    const Text("All clear. No active emergencies!"),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(20.r),
              itemCount: list.length,
              itemBuilder: (context, idx) {
                final alert = list[idx];
                Color levelColor;
                switch (alert.level) {
                  case 'Critical':
                    levelColor = AppColors.error;
                    break;
                  case 'High':
                    levelColor = AppColors.warning;
                    break;
                  default:
                    levelColor = AppColors.primary;
                }

                // Format time difference
                final now = DateTime.now();
                final diff = now.difference(alert.createdAt);
                String timeAgo = "Just now";
                if (diff.inDays > 0) {
                  timeAgo = "${diff.inDays}d ago";
                } else if (diff.inHours > 0) {
                  timeAgo = "${diff.inHours}h ago";
                } else if (diff.inMinutes > 0) {
                  timeAgo = "${diff.inMinutes}m ago";
                }

                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () => _showResolveConfirmDialog(alert),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: levelColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.warning_amber_rounded, color: levelColor),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  alert.message,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text("Triggered: $timeAgo"),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: levelColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  alert.level,
                                  style: TextStyle(
                                    color: levelColor,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              const Icon(Icons.check, color: AppColors.success, size: 18),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
