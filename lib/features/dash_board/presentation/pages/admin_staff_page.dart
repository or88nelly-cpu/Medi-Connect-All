import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminStaffPage extends StatefulWidget {
  const AdminStaffPage({super.key});

  @override
  State<AdminStaffPage> createState() => _AdminStaffPageState();
}

class _AdminStaffPageState extends State<AdminStaffPage> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  late Future<List<UserModel>> _staffFuture;

  @override
  void initState() {
    super.initState();
    _refreshList();
    // Ensure departments/sections are loaded
    context.read<DepartmentBloc>().add(const LoadDepartments());
  }

  void _refreshList() {
    setState(() {
      _staffFuture = _fetchStaff();
    });
  }

  Future<List<UserModel>> _fetchStaff() async {
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('role', 'staff')
        .isFilter('deleted_at', null);

    return (response as List<dynamic>)
        .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
        .toList();
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
                      extra: {'role': 'staff', 'department': selectedDept},
                    )
                    .then((value) {
                      if (value == true) _refreshList();
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
    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Staff Directory"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSelectDepartmentAndCreate(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Staff", style: TextStyle(color: Colors.white)),
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
                hintText: "Search staff by name or role...",
                prefixIcon: const Icon(Icons.search),
                contentPadding: EdgeInsets.all(12.r),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Horizontal Combined Categories (Sections + Departments)
            Text(
              "Filter by Section / Department",
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),

            BlocBuilder<DepartmentBloc, DepartmentState>(
              builder: (context, state) {
                final List<String> categories = ['All'];
                if (state is DepartmentsLoaded) {
                  categories.addAll(state.sections.map((e) => e.name));
                  categories.addAll(state.departments.map((e) => e.name));
                } else if (state is DepartmentActionSuccess) {
                  categories.addAll(
                    state.updatedDepartments.map((e) => e.name),
                  );
                }

                return SizedBox(
                  height: 38.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, idx) {
                      final category = categories[idx];
                      final isSelected = _selectedFilter == category;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedFilter = category;
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

            // Staff List
            Expanded(
              child: FutureBuilder<List<UserModel>>(
                future: _staffFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No staff registered."));
                  }

                  final filtered = snapshot.data!.where((stf) {
                    final matchesSearch =
                        (stf.name ?? '').toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        (stf.staffRole ?? '').toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        );

                    final matchesFilter =
                        _selectedFilter == 'All' ||
                        (stf.department ?? '').toLowerCase() ==
                            _selectedFilter.toLowerCase();

                    return matchesSearch && matchesFilter;
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text("No matching staff found."),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      final stf = filtered[idx];
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
                            backgroundColor: AppColors.accent.withOpacity(0.1),
                            child: Icon(
                              Icons.badge_outlined,
                              color: AppColors.accent,
                            ),
                          ),
                          title: Text(
                            stf.name ?? '',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            "${stf.staffRole ?? 'Support Staff'} | Dept/Sec: ${stf.department ?? 'None'}",
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
                                    extra: stf,
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
                                    extra: stf,
                                  );
                                  if (res == true) _refreshList();
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
}
