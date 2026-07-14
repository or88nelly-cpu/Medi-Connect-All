import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/features/management/staff_management/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/management/staff_management/domain/entities/department_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_drawer.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';

class AdminDepartmentFormPage extends StatefulWidget {
  final String? departmentId;

  const AdminDepartmentFormPage({super.key, this.departmentId});

  @override
  State<AdminDepartmentFormPage> createState() =>
      _AdminDepartmentFormPageState();
}

class _AdminDepartmentFormPageState extends State<AdminDepartmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _consultation = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Load departments if not loaded to fetch editing data
    final state = context.read<DepartmentBloc>().state;
    if (state is! DepartmentsLoaded) {
      context.read<DepartmentBloc>().add(const LoadDepartments());
    } else {
      _initFields(state);
    }
  }

  void _initFields(DepartmentsLoaded state) {
    if (widget.departmentId != null && !_initialized) {
      final dept = _findDept(state, widget.departmentId!);
      if (dept != null) {
        _nameController.text = dept.name;
        _descriptionController.text = dept.description ?? '';
        _imageUrlController.text = dept.imageUrl ?? '';
        _consultation = dept.consultation;
        _initialized = true;
      }
    }
  }

  DepartmentEntity? _findDept(DepartmentsLoaded state, String id) {
    for (final d in state.departments) {
      if (d.id == id) return d;
    }
    for (final s in state.sections) {
      if (s.id == id) return s;
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.departmentId != null;

    return CustomScaffold(
      drawer: AdminDrawer(),
      appBarNeeded: AppResponsive.isMobile(context),
      body: BlocConsumer<DepartmentBloc, DepartmentState>(
        listener: (context, state) {
          if (state is DepartmentsLoaded) {
            _initFields(state);
          } else if (state is DepartmentActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          } else if (state is DepartmentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is DepartmentLoading;

          return SingleChildScrollView(
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
                      isEditing ? "Edit Department" : "Add Department",
                      style: AppTextStyles.headingMedium.copyWith(
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
                        Text(
                          "Department Name",
                          style: AppTextStyles.labelLarge,
                        ),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _nameController,
                          enabled: !isLoading,
                          decoration: const InputDecoration(
                            hintText: "Enter department name",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? "Name is required"
                              : null,
                        ),
                        SizedBox(height: 20.h),
                        Text("Description", style: AppTextStyles.labelLarge),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _descriptionController,
                          enabled: !isLoading,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Enter department description",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text("Image URL", style: AppTextStyles.labelLarge),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _imageUrlController,
                          enabled: !isLoading,
                          decoration: const InputDecoration(
                            hintText: "Enter department image URL",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Supports Consultation",
                              style: AppTextStyles.labelLarge,
                            ),
                            Switch(
                              value: _consultation,
                              onChanged: isLoading
                                  ? null
                                  : (value) =>
                                        setState(() => _consultation = value),
                              activeThumbColor: AppColors.primary,
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: isLoading ? null : () => context.pop(),
                              child: const Text("Cancel"),
                            ),
                            SizedBox(width: 16.w),
                            ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        if (isEditing) {
                                          context.read<DepartmentBloc>().add(
                                            UpdateDepartmentEvent(
                                              id: widget.departmentId!,
                                              name: _nameController.text.trim(),
                                              description:
                                                  _descriptionController.text
                                                      .trim(),
                                              imageUrl: _imageUrlController.text
                                                  .trim(),
                                            ),
                                          );
                                        } else {
                                          context.read<DepartmentBloc>().add(
                                            AddDepartmentEvent(
                                              name: _nameController.text.trim(),
                                              description:
                                                  _descriptionController.text
                                                      .trim(),
                                              imageUrl: _imageUrlController.text
                                                  .trim(),
                                            ),
                                          );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 12.h,
                                ),
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      width: 20.r,
                                      height: 20.r,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      isEditing
                                          ? "Save Changes"
                                          : "Create Department",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
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
          );
        },
      ),
    );
  }
}
