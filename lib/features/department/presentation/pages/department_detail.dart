import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/department/data/models/department_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DepartmentDetail extends StatefulWidget {
  const DepartmentDetail({super.key, required this.department});
  final DepartmentModel department;

  @override
  State<DepartmentDetail> createState() => _DepartmentDetailState();
}

class _DepartmentDetailState extends State<DepartmentDetail> {
  String _searchQuery = '';
  late Future<List<UserModel>> _staffFuture;

  @override
  void initState() {
    super.initState();
    _refreshStaff();
  }

  void _refreshStaff() {
    setState(() {
      _staffFuture = _fetchDepartmentStaff();
    });
  }

  Future<List<UserModel>> _fetchDepartmentStaff() async {
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('role', 'staff')
        .eq('department', widget.department.name)
        .isFilter('deleted_at', null);

    return (response as List<dynamic>)
        .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      customAppbar: CommonAppBar(title: widget.department.name),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await context.push(
            '/admin/doctor-staff/create',
            extra: {'role': 'staff', 'department': widget.department.name},
          );
          if (res == true) _refreshStaff();
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Staff", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Department Banner Image (collapsible/static header)
          if (widget.department.imageUrl != null &&
              widget.department.imageUrl!.isNotEmpty)
            Center(
              child: CircleAvatar(
                backgroundColor: AppColors.infoIndigo.withAlpha(20),
                radius: 40.r,

                child: Center(
                  child: CustomImageView(
                    imagePath: widget.department.imageUrl!,
                    width: 50.r,
                    height: 50.r,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 120.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.local_hospital_outlined,
                  size: 60.r,
                  color: Colors.white,
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Department Staff",
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                // Search Bar
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: "Search staff in ${widget.department.name}...",
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: EdgeInsets.all(12.r),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Dynamic Staff List
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: FutureBuilder<List<UserModel>>(
                future: _staffFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No staff members registered in this department.",
                        style: AppTextStyles.bodyMedium,
                      ),
                    );
                  }

                  final filtered = snapshot.data!.where((stf) {
                    final matchesSearch =
                        (stf.name ?? '').toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        (stf.staffRole ?? '').toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        );
                    return matchesSearch;
                  }).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        "No matching staff members found.",
                        style: AppTextStyles.bodyMedium,
                      ),
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
                          subtitle: Text(stf.staffRole ?? 'Support Staff'),
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
                                  if (res == true) _refreshStaff();
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
          ),
        ],
      ),
    );
  }
}
