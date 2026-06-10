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

class AdminDoctorsPage extends StatefulWidget {
  const AdminDoctorsPage({super.key});

  @override
  State<AdminDoctorsPage> createState() => _AdminDoctorsPageState();
}

class _AdminDoctorsPageState extends State<AdminDoctorsPage> {
  String _searchQuery = '';
  String _selectedSection = 'All';
  late Future<List<UserModel>> _doctorsFuture;

  @override
  void initState() {
    super.initState();
    _refreshList();
    // Ensure departments/sections are loaded
    context.read<DepartmentBloc>().add(const LoadDepartments());
  }

  void _refreshList() {
    setState(() {
      _doctorsFuture = _fetchDoctors();
    });
  }

  Future<List<UserModel>> _fetchDoctors() async {
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('role', 'doctor')
        .isFilter('deleted_at', null);

    return (response as List<dynamic>)
        .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Doctors Directory"),
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
                  sections.addAll(state.updatedDepartments
                      .where((e) => !e.consultation)
                      .map((e) => e.name));
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
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
              child: FutureBuilder<List<UserModel>>(
                future: _doctorsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No doctors registered."));
                  }

                  final filtered = snapshot.data!.where((doc) {
                    final matchesSearch = (doc.name ?? '').toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        (doc.specialization ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
                    
                    final matchesSection = _selectedSection == 'All' || 
                        (doc.department ?? '').toLowerCase() == _selectedSection.toLowerCase();

                    return matchesSearch && matchesSection;
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text("No matching doctors found."));
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
                            backgroundColor: AppColors.secondary.withOpacity(0.1),
                            child: Icon(Icons.local_hospital_outlined, color: AppColors.secondary),
                          ),
                          title: Text(
                            doc.name ?? '',
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          subtitle: Text("${doc.specialization ?? 'General Medicine'} | Section: ${doc.department ?? 'None'}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility_outlined, color: AppColors.primary),
                                onPressed: () {
                                  context.push('/admin/doctor-staff/detail', extra: doc);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppColors.warning),
                                onPressed: () async {
                                  final res = await context.push('/admin/doctor-staff/edit', extra: doc);
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
