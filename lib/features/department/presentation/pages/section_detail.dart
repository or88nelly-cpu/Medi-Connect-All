import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/department/data/models/department_model.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_state.dart';

class SectionDetail extends StatefulWidget {
  const SectionDetail({super.key, required this.section});
  final DepartmentModel section;

  @override
  State<SectionDetail> createState() => _SectionDetailState();
}

class _SectionDetailState extends State<SectionDetail> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorStaffBloc>().add(LoadDoctorStaff(widget.section.name));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: CustomScaffold(
        customAppbar: AppBar(
          title: Text(widget.section.name),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "Doctors"),
              Tab(text: "Staff"),
            ],
          ),
        ),
        body: BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
          builder: (context, state) {
            if (state is DoctorStaffLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DoctorStaffError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                ),
              );
            } else if (state is DoctorStaffLoaded) {
              return TabBarView(
                children: [
                  _buildListTab(context, state.doctors, 'doctor'),
                  _buildListTab(context, state.staff, 'staff'),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildListTab(BuildContext context, List<UserModel> list, String role) {
    final isDoctor = role == 'doctor';
    final roleColor = isDoctor ? AppColors.secondary : AppColors.accent;

    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${isDoctor ? 'Doctors' : 'Staff'} Directory",
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.push(
                    '/admin/doctor-staff/create',
                    extra: {'role': role, 'department': widget.section.name},
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text("Add $role", style: const TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Text(
                      "No ${isDoctor ? 'doctors' : 'staff'} found under this department.",
                      style: AppTextStyles.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, idx) {
                      final user = list[idx];
                      return Card(
                        margin: EdgeInsets.only(bottom: 12.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12.r),
                          leading: CircleAvatar(
                            backgroundColor: roleColor.withOpacity(0.1),
                            child: Icon(
                              isDoctor ? Icons.local_hospital_outlined : Icons.badge_outlined,
                              color: roleColor,
                            ),
                          ),
                          title: Text(
                            user.name ?? "${user.firstName ?? ''} ${user.lastName ?? ''}".trim(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            isDoctor
                                ? (user.specialization ?? 'General practitioner')
                                : (user.staffRole ?? 'Support Staff'),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility_outlined, color: AppColors.primary),
                                onPressed: () {
                                  context.push('/admin/doctor-staff/detail', extra: user);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppColors.warning),
                                onPressed: () {
                                  context.push('/admin/doctor-staff/edit', extra: user);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                                onPressed: () => _confirmDelete(context, user),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: "Delete Profile",
        message: "Are you sure you want to delete ${user.name ?? 'this user'}? This action cannot be undone.",
        onConfirm: () {
          context.read<DoctorStaffBloc>().add(
                DeleteDoctorStaffMember(
                  userId: user.id,
                  departmentName: widget.section.name,
                ),
              );
        },
      ),
    );
  }
}
