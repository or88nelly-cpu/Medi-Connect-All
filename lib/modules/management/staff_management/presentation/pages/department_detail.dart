import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/management/staff_management/data/models/department_model.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_state.dart';

import 'package:medi_connect/modules/management/equipment_management/presentation/pages/biomedical_engineering_detail_page.dart';
import 'package:medi_connect/modules/management/queue_management/presentation/pages/casuality_detail_page.dart';
import 'package:medi_connect/modules/management/equipment_management/presentation/pages/cssd_detail_page.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/pages/customer_care_detail_page.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/pages/dyalisis_detail_page.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/pages/emrd_detail_page.dart';
import 'package:medi_connect/modules/management/billing_management/presentation/pages/finance_detail_page.dart';
import 'package:medi_connect/modules/management/settings_management/presentation/pages/fire_safety_detail_page.dart';
import 'package:medi_connect/modules/management/inventory_management/presentation/pages/general_store_detail_page.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/pages/human_resource_detail_page.dart';
import 'package:medi_connect/modules/management/ward_management/presentation/pages/icu_detail_page.dart';
import 'package:medi_connect/modules/management/settings_management/presentation/pages/information_technology_detail_page.dart';
import 'package:medi_connect/modules/management/laboratory_management/presentation/pages/laboratory_detail_page.dart';
import 'package:medi_connect/modules/management/report_management/presentation/pages/management_information_system_detail_page.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/pages/marketing_detail_page.dart';
import 'package:medi_connect/modules/management/equipment_management/presentation/pages/mep_engineer_detail_page.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/pages/nursing_detail_page.dart';
import 'package:medi_connect/modules/management/ward_management/presentation/pages/nutrition_and_diabetics_detail_page.dart';
import 'package:medi_connect/modules/management/room_management/presentation/pages/operation_theatre_detail_page.dart';
import 'package:medi_connect/modules/management/pharmacy_management/presentation/pages/pharmacy_detail_page.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/pages/physio_therapy_detail_page.dart';
import 'package:medi_connect/modules/management/inventory_management/presentation/pages/purchase_detail_page.dart';
import 'package:medi_connect/modules/management/laboratory_management/presentation/pages/radiology_detail_page.dart';
import 'package:medi_connect/modules/management/ward_management/presentation/pages/ward_detail_page.dart';

class DepartmentDetail extends StatefulWidget {
  const DepartmentDetail({super.key, required this.department});
  final DepartmentModel department;

  @override
  State<DepartmentDetail> createState() => _DepartmentDetailState();
}

class _DepartmentDetailState extends State<DepartmentDetail> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<DoctorStaffBloc>().add(
      LoadDoctorStaff(widget.department.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customPage = _getWidgetDetailPage(widget.department.name);
    if (customPage != null) {
      return customPage;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.surface;
    final borderColor = AppColors.border(context);
    final textColor = AppColors.textPrimary(context);
    final labelColor = AppColors.textSecondary(context);
    final fieldFillColor = isDark
        ? AppColors.terminalDarkFieldFill
        : AppColors.terminalLightFieldFill;

    return CustomScaffold(
      customAppbar: CommonAppBar(title: widget.department.name),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await context.push(
            '/admin/doctor-staff/create',
            extra: {'role': 'staff', 'department': widget.department.name},
          );
          if (res == true) {
            if (mounted) {
              context.read<DoctorStaffBloc>().add(
                LoadDoctorStaff(widget.department.name),
              );
            }
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Staff", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    color: textColor,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: fieldFillColor,
                    hintText: "Search staff in ${widget.department.name}...",
                    hintStyle: TextStyle(
                      color: isDark
                          ? AppColors.terminalDarkFieldHint
                          : AppColors.terminalLightFieldHint,
                    ),
                    prefixIcon: Icon(Icons.search, color: labelColor),
                    contentPadding: EdgeInsets.all(12.r),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
                builder: (context, state) {
                  if (state is DoctorStaffLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DoctorStaffError) {
                    return Center(
                      child: Text(
                        "Error: ${state.message}",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    );
                  } else if (state is DoctorStaffLoaded) {
                    final staff = state.staff;
                    if (staff.isEmpty) {
                      return Center(
                        child: Text(
                          "No staff members registered in this department.",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: labelColor,
                          ),
                        ),
                      );
                    }

                    final filtered = staff.where((stf) {
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
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: labelColor,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, idx) {
                        final stf = filtered[idx];
                        return Card(
                          color: cardBg,
                          margin: EdgeInsets.only(bottom: 12.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: BorderSide(color: borderColor),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(12.r),
                            leading: CircleAvatar(
                              backgroundColor: AppColors.accent.withValues(
                                alpha: 0.1,
                              ),
                              child: Icon(
                                Icons.badge_outlined,
                                color: AppColors.accent,
                              ),
                            ),
                            title: Text(
                              stf.name ?? '',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            subtitle: Text(
                              stf.staffRole ?? 'Support Staff',
                              style: TextStyle(color: labelColor),
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
                                    if (res == true) {
                                      if (mounted) {
                                        context.read<DoctorStaffBloc>().add(
                                          LoadDoctorStaff(
                                            widget.department.name,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
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
          ),
        ],
      ),
    );
  }

  Widget? _getWidgetDetailPage(String name) {
    switch (name.trim()) {
      case 'Biomedical Engineering':
        return const BiomedicalEngineeringDetailPage();
      case 'Casuality':
        return const CasualityDetailPage();
      case 'CSSD':
        return const CssdDetailPage();
      case 'Customer Care':
        return const CustomerCareDetailPage();
      case 'Dyalisis':
        return const DyalisisDetailPage();
      case 'EMRD':
        return const EmrdDetailPage();
      case 'Finance':
        return const FinanceDetailPage();
      case 'Fire Safety':
        return const FireSafetyDetailPage();
      case 'General Store':
        return const GeneralStoreDetailPage();
      case 'Human Resource':
        return const HumanResourceDetailPage();
      case 'ICU':
        return const IcuDetailPage();
      case 'Information Technology':
        return const InformationTechnologyDetailPage();
      case 'Laboratory':
        return const LaboratoryDetailPage();
      case 'Management Information System':
        return const ManagementInformationSystemDetailPage();
      case 'Marketing':
        return const MarketingDetailPage();
      case 'MEP Engineer':
        return const MepEngineerDetailPage();
      case 'Nursing':
        return const NursingDetailPage();
      case 'Nutrition and Diabetics':
        return const NutritionAndDiabeticsDetailPage();
      case 'Operation Theatre':
        return const OperationTheatreDetailPage();
      case 'Pharmacy':
        return const PharmacyDetailPage();
      case 'Physio Therapy':
        return const PhysioTherapyDetailPage();
      case 'Purchase':
        return const PurchaseDetailPage();
      case 'Radiology':
        return const RadiologyDetailPage();
      case 'Ward':
        return const WardDetailPage();
      default:
        return null;
    }
  }
}
