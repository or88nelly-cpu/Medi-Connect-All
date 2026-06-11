import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_state.dart';

class AdminDoctorsPage extends StatefulWidget {
  const AdminDoctorsPage({super.key});

  @override
  State<AdminDoctorsPage> createState() => _AdminDoctorsPageState();
}

class _AdminDoctorsPageState extends State<AdminDoctorsPage> {
  String _searchQuery = '';
  String _selectedSection = 'All';

  @override
  void initState() {
    super.initState();
    // Ensure departments/sections are loaded
    context.read<DepartmentBloc>().add(const LoadDepartments());
  }

  void _showSelectDepartmentAndCreate(BuildContext context) {
    final state = context.read<DepartmentBloc>().state;
    List<String> list = [];
    if (state is DepartmentsLoaded) {
      list.addAll(state.sections.map((e) => e.name));
      list.addAll(state.departments.map((e) => e.name));
    }

    if (list.isEmpty) {
      list = [
        'General Medicine',
        'Cardiology',
        'Neurology',
        'Pediatrics',
        'Emergency',
        'OPD',
      ];
    }

    String selectedDept = list.first;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text("Select Department"),
          content: DropdownButton<String>(
            value: selectedDept,
            isExpanded: true,
            items: list.map((d) {
              return DropdownMenuItem(value: d, child: Text(d));
            }).toList(),
            onChanged: (val) {
              if (val != null) setDialogState(() => selectedDept = val);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context
                    .push(
                      '/admin/doctor-staff/create',
                      extra: {'role': 'doctor', 'department': selectedDept},
                    )
                    .then((value) {
                      if (value == true && context.mounted) {
                        context.read<DoctorStaffBloc>().add(const LoadDoctorStaff('All'));
                      }
                    });
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<DoctorStaffBloc>()..add(const LoadDoctorStaff('All')),
      child: Builder(
        builder: (context) {
          return CustomScaffold(
            customAppbar: const CommonAppBar(title: "Doctors Directory"),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _showSelectDepartmentAndCreate(context),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add Doctor", style: TextStyle(color: Colors.white)),
              backgroundColor: AppColors.primary,
            ),
            body: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: "Search doctor by name or specialty...",
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: EdgeInsets.all(12.r),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Horizontal Sections
                  Text(
                    "Filter by Section",
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BlocBuilder<DepartmentBloc, DepartmentState>(
                    builder: (context, state) {
                      final List<String> sections = ['All'];
                      if (state is DepartmentsLoaded) {
                        sections.addAll(state.sections.map((e) => e.name));
                      } else if (state is DepartmentActionSuccess) {
                        sections.addAll(
                          state.updatedDepartments
                              .where((e) => !e.consultation)
                              .map((e) => e.name),
                        );
                      }

                      return SizedBox(
                        height: 38.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: sections.length,
                          itemBuilder: (context, idx) {
                            final section = sections[idx];
                            final isSelected = _selectedSection == section;
                            return Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: ChoiceChip(
                                label: Text(section),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedSection = section;
                                    });
                                  }
                                },
                                selectedColor: AppColors.primary.withOpacity(0.2),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 12.sp,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Doctors List
                  Expanded(
                    child: BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
                      builder: (context, state) {
                        if (state is DoctorStaffLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is DoctorStaffError) {
                          return Center(child: Text("Error: ${state.message}"));
                        }

                        List<UserModel> doctorsList = [];
                        if (state is DoctorStaffLoaded) {
                          doctorsList = state.doctors;
                        }

                        if (doctorsList.isEmpty) {
                          return const Center(child: Text("No doctors registered."));
                        }

                        final filtered = doctorsList.where((doc) {
                          final matchesSearch =
                              (doc.name ?? '').toLowerCase().contains(
                                    _searchQuery.toLowerCase(),
                                  ) ||
                              (doc.specialization ?? '').toLowerCase().contains(
                                    _searchQuery.toLowerCase(),
                                  );

                          final matchesSection =
                              _selectedSection == 'All' ||
                              (doc.department ?? '').toLowerCase() ==
                                  _selectedSection.toLowerCase();

                          return matchesSearch && matchesSection;
                        }).toList();

                        if (filtered.isEmpty) {
                          return const Center(
                            child: Text("No matching doctors found."),
                          );
                        }

                        return ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, idx) {
                            final doc = filtered[idx];
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
                                  backgroundColor: AppColors.secondary.withOpacity(
                                    0.1,
                                  ),
                                  child: Icon(
                                    Icons.local_hospital_outlined,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                title: Text(
                                  doc.name ?? '',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                subtitle: Text(
                                  "${doc.specialization ?? 'General Medicine'} | Section: ${doc.department ?? 'None'}",
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.visibility_outlined,
                                        color: AppColors.primary,
                                      ),
                                      onPressed: () {
                                        context.push(
                                          '/admin/doctor-staff/detail',
                                          extra: doc,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        color: AppColors.warning,
                                      ),
                                      onPressed: () async {
                                        final res = await context.push(
                                          '/admin/doctor-staff/edit',
                                          extra: doc,
                                        );
                                        if (res == true && context.mounted) {
                                          context.read<DoctorStaffBloc>().add(const LoadDoctorStaff('All'));
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

