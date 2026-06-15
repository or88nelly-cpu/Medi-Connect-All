import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/domain/entities/lab_test_entity.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin/admin_labs_bloc.dart';

class AdminLabsPage extends StatefulWidget {
  const AdminLabsPage({super.key});

  @override
  State<AdminLabsPage> createState() => _AdminLabsPageState();
}

class _AdminLabsPageState extends State<AdminLabsPage> {
  String _selectedPriorityFilter = "All";

  @override
  void initState() {
    super.initState();
    context.read<AdminLabsBloc>().add(LoadLabTests());
  }

  void _showAddTestDialog() {
    final nameController = TextEditingController();
    final patientController = TextEditingController();
    String priority = "Normal";
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Request New Lab Test"),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: patientController,
                      decoration: const InputDecoration(
                        labelText: "Patient Name",
                        hintText: "e.g., Alice Smith",
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Required field"
                          : null,
                    ),
                    SizedBox(height: 12.h),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Test Name",
                        hintText: "e.g., CBC & Hemoglobin",
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Required field"
                          : null,
                    ),
                    SizedBox(height: 12.h),
                    DropdownButtonFormField<String>(
                      initialValue: priority,
                      decoration: const InputDecoration(labelText: "Priority"),
                      items: ["Normal", "High", "Critical"].map((p) {
                        return DropdownMenuItem(value: p, child: Text(p));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => priority = val);
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<AdminLabsBloc>().add(
                        AddLabTest({
                          'patient_name': patientController.text.trim(),
                          'test_name': nameController.text.trim(),
                          'priority': priority,
                          'status': 'Pending',
                        }),
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text("Create"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showStatusUpdateDialog(LabTestEntity test) {
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text("Update Status: ${test.testName}"),
          children: ["Pending", "In Progress", "Completed"].map((status) {
            return SimpleDialogOption(
              onPressed: () {
                context.read<AdminLabsBloc>().add(
                  UpdateLabTestStatus(test.id, status),
                );
                Navigator.pop(ctx);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  children: [
                    Icon(
                      status == "Completed"
                          ? Icons.check_circle_outline
                          : status == "In Progress"
                          ? Icons.hourglass_empty
                          : Icons.radio_button_unchecked,
                      color: status == "Completed"
                          ? AppColors.success
                          : status == "In Progress"
                          ? AppColors.warning
                          : AppColors.textSecondary,
                    ),
                    SizedBox(width: 12.w),
                    Text(status, style: AppTextStyles.bodyLarge),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      customAppbar: CommonAppBar(
        title: "Laboratory Tests",
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
            ),
            onPressed: _showAddTestDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter strip at the top
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            color: AppColors.background,
            child: Row(
              children: ["All", "Normal", "High", "Critical"].map((filter) {
                final isSelected = _selectedPriorityFilter == filter;
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) {
                        setState(() => _selectedPriorityFilter = filter);
                      }
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
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
              }).toList(),
            ),
          ),
          Expanded(
            child: BlocBuilder<AdminLabsBloc, AdminLabsState>(
              builder: (context, state) {
                if (state is AdminLabsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AdminLabsError) {
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
                              context.read<AdminLabsBloc>().add(LoadLabTests()),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }

                if (state is AdminLabsLoaded) {
                  var tests = state.tests;

                  if (_selectedPriorityFilter != "All") {
                    tests = tests
                        .where((t) => t.priority == _selectedPriorityFilter)
                        .toList();
                  }

                  if (tests.isEmpty) {
                    return const Center(child: Text("No lab tests found."));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(20.r),
                    itemCount: tests.length,
                    itemBuilder: (context, idx) {
                      final test = tests[idx];
                      Color priorityColor;
                      switch (test.priority) {
                        case 'Critical':
                          priorityColor = AppColors.error;
                          break;
                        case 'High':
                          priorityColor = AppColors.warning;
                          break;
                        default:
                          priorityColor = AppColors.primary;
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
                          onTap: () => _showStatusUpdateDialog(test),
                          child: Padding(
                            padding: EdgeInsets.all(16.r),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    color: priorityColor.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.science_outlined,
                                    color: priorityColor,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        test.testName,
                                        style: AppTextStyles.titleMedium
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.sp,
                                            ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text("Patient: ${test.patientName}"),
                                      Text("Test ID: ${test.id}"),
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
                                        color: test.status == 'Completed'
                                            ? AppColors.success.withValues(
                                                alpha: 0.1,
                                              )
                                            : test.status == 'In Progress'
                                            ? AppColors.warning.withValues(
                                                alpha: 0.1,
                                              )
                                            : AppColors.textSecondary
                                                  .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: Text(
                                        test.status,
                                        style: TextStyle(
                                          color: test.status == 'Completed'
                                              ? AppColors.success
                                              : test.status == 'In Progress'
                                              ? AppColors.warning
                                              : AppColors.textSecondary,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      "${test.priority} Priority",
                                      style: TextStyle(
                                        color: priorityColor,
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
          ),
        ],
      ),
    );
  }
}
