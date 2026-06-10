import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminStaffPage extends StatefulWidget {
  const AdminStaffPage({super.key});

  @override
  State<AdminStaffPage> createState() => _AdminStaffPageState();
}

class _AdminStaffPageState extends State<AdminStaffPage> {
  String _searchQuery = '';
  late Future<List<UserModel>> _staffFuture;

  @override
  void initState() {
    super.initState();
    _refreshList();
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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Staff Directory"),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
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
                    final matchesSearch = (stf.name ?? '').toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        (stf.staffRole ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
                    return matchesSearch;
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text("No matching staff found."));
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
                            child: Icon(Icons.badge_outlined, color: AppColors.accent),
                          ),
                          title: Text(
                            stf.name ?? '',
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          subtitle: Text("${stf.staffRole ?? 'Support Staff'} | Shift: ${stf.availabilityStatus ?? 'Day'}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility_outlined, color: AppColors.primary),
                                onPressed: () {
                                  context.push('/admin/doctor-staff/detail', extra: stf);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppColors.warning),
                                onPressed: () async {
                                  final res = await context.push('/admin/doctor-staff/edit', extra: stf);
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
