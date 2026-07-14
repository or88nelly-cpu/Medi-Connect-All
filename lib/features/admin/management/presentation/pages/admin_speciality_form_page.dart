import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_drawer.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';

class AdminSpecialityFormPage extends StatefulWidget {
  final String? specialityId;

  const AdminSpecialityFormPage({super.key, this.specialityId});

  @override
  State<AdminSpecialityFormPage> createState() => _AdminSpecialityFormPageState();
}

class _AdminSpecialityFormPageState extends State<AdminSpecialityFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.specialityId != null) {
      // Mock data load
      _nameController.text = "Mock Speciality ${widget.specialityId}";
      _descriptionController.text = "This is a mock description.";
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.specialityId != null;

    return CustomScaffold(
      drawer: AdminDrawer(),
      appBarNeeded: AppResponsive.isMobile(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                SizedBox(width: 8.w),
                Text(
                  isEditing ? "Edit Speciality" : "Add Speciality",
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surface : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border(context)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Speciality Name", style: AppTextStyles.labelLarge),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: "Enter speciality name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? "Name is required" : null,
                    ),
                    SizedBox(height: 20.h),
                    Text("Description", style: AppTextStyles.labelLarge),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Enter speciality description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Active Status", style: AppTextStyles.labelLarge),
                        Switch(
                          value: _isActive,
                          onChanged: (value) => setState(() => _isActive = value),
                          activeColor: AppColors.primary,
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text("Cancel"),
                        ),
                        SizedBox(width: 16.w),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Save logic here
                              context.pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                          ),
                          child: Text(
                            isEditing ? "Save Changes" : "Create Speciality",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
