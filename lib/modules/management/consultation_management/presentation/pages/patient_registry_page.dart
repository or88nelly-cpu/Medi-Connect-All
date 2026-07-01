import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/widgets/emrd_list_item_card.dart';
import 'package:medi_connect/modules/management/patient_management/presentation/bloc/patient_bloc.dart';

class PatientRegistryPage extends StatefulWidget {
  const PatientRegistryPage({super.key});

  @override
  State<PatientRegistryPage> createState() => _PatientRegistryPageState();
}

class _PatientRegistryPageState extends State<PatientRegistryPage> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _queryNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _filterNotifier = ValueNotifier<String>('Name');

  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(LoadPatients());
    context.read<EmrdBloc>().add(LoadEmrdStats());
    _searchController.addListener(() {
      _queryNotifier.value = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _queryNotifier.dispose();
    _filterNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = AppColors.border(context);
    final textColor = AppColors.textPrimary(context);
    final fieldFillColor = isDark
        ? AppColors.terminalDarkFieldFill
        : AppColors.terminalLightFieldFill;

    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, patientState) {
        return BlocBuilder<EmrdBloc, EmrdState>(
          builder: (context, emrdState) {
            if (patientState is PatientLoading || emrdState is EmrdLoading) {
              return const CustomScaffold(
                customAppbar: CommonAppBar(
                  title: "Patient Registry & Identification",
                ),
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (patientState is PatientError) {
              return CustomScaffold(
                customAppbar: const CommonAppBar(
                  title: "Patient Registry & Identification",
                ),
                body: Center(
                  child: Text(
                    patientState.message,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              );
            } else if (emrdState is EmrdError) {
              return CustomScaffold(
                customAppbar: const CommonAppBar(
                  title: "Patient Registry & Identification",
                ),
                body: Center(
                  child: Text(
                    emrdState.message,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              );
            } else if (patientState is PatientLoaded &&
                emrdState is EmrdLoaded) {
              final patientsList = patientState.patients;
              final emrRecords = emrdState.emrRecords;

              return CustomScaffold(
                customAppbar: const CommonAppBar(
                  title: "Patient Registry & Identification",
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.badge_outlined,
                            color: AppColors.primary,
                            size: 22.r,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Patient Registry Records",
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          const Spacer(),
                          ValueListenableBuilder<String>(
                            valueListenable: _queryNotifier,
                            builder: (context, query, _) {
                              return ValueListenableBuilder<String>(
                                valueListenable: _filterNotifier,
                                builder: (context, filter, _) {
                                  final queryLower = query.toLowerCase().trim();
                                  final count = patientsList.where((p) {
                                    if (queryLower.isEmpty) return true;
                                    final name = (p.fullName).toLowerCase();
                                    final uhid = (p.id).toLowerCase();
                                    final phone = (p.phone ?? '').toLowerCase();

                                    if (filter == 'UHID') {
                                      return uhid.contains(queryLower);
                                    } else if (filter == 'Phone') {
                                      return phone.contains(queryLower);
                                    } else {
                                      return name.contains(queryLower);
                                    }
                                  }).length;

                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      "$count Records",
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: ValueListenableBuilder<String>(
                              valueListenable: _filterNotifier,
                              builder: (context, filter, _) {
                                return TextField(
                                  controller: _searchController,
                                  style: TextStyle(color: textColor),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: fieldFillColor,
                                    hintText:
                                        "Search patient by ${filter.toLowerCase()}...",
                                    hintStyle: TextStyle(
                                      color: isDark
                                          ? AppColors.terminalDarkFieldHint
                                          : AppColors.terminalLightFieldHint,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: AppColors.textSecondary(context),
                                    ),
                                    contentPadding: EdgeInsets.all(12.r),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: BorderSide(
                                        color: borderColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: BorderSide(
                                        color: borderColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 8.w),
                          ValueListenableBuilder<String>(
                            valueListenable: _filterNotifier,
                            builder: (context, filter, _) {
                              return DropdownButton<String>(
                                value: filter,
                                dropdownColor: isDark
                                    ? AppColors.terminalDarkCard
                                    : Colors.white,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                underline: const SizedBox(),
                                items: ['Name', 'UHID', 'Phone'].map((
                                  String val,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    _filterNotifier.value = val;
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      ValueListenableBuilder<String>(
                        valueListenable: _queryNotifier,
                        builder: (context, query, _) {
                          return ValueListenableBuilder<String>(
                            valueListenable: _filterNotifier,
                            builder: (context, filter, _) {
                              final queryLower = query.toLowerCase().trim();
                              final filteredPatients = patientsList.where((p) {
                                if (queryLower.isEmpty) return true;
                                final name = (p.fullName ?? '').toLowerCase();
                                final uhid = (p.id ?? '').toLowerCase();
                                final phone = (p.phone ?? '').toLowerCase();

                                if (filter == 'UHID') {
                                  return uhid.contains(queryLower);
                                } else if (filter == 'Phone') {
                                  return phone.contains(queryLower);
                                } else {
                                  return name.contains(queryLower);
                                }
                              }).toList();

    
                              if (filteredPatients.isEmpty) {
                                return Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    side: BorderSide(
                                      color: AppColors.border(context),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 32.h,
                                      horizontal: 16.w,
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.badge_outlined,
                                            size: 48.r,
                                            color: AppColors.textSecondary(
                                              context,
                                            ).withValues(alpha: 0.4),
                                          ),
                                          SizedBox(height: 12.h),
                                          Text(
                                            "No Patients Found",
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            "Registered patients will be recorded and listed here.",
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.bodySmall
                                                .copyWith(
                                                  color:
                                                      AppColors.textSecondary(
                                                        context,
                                                      ),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredPatients.length,
                                itemBuilder: (context, index) {
                                  final patient = filteredPatients[index];

                                  // Locate the customer care registration EMR record, or construct a dynamic fallback
                                  final patientRecord = emrRecords.firstWhere(
                                    (r) =>
                                        r['patient_id'] == patient.id &&
                                        r['specialty'] == 'Customer Care',
                                    orElse: () => {
                                      'patient_id': patient.id,
                                      'patient_name':
                                          patient.fullName ?? 'Unnamed Patient',
                                      'specialty': 'Customer Care',
                                      'doctor_name': 'Customer Care Department',
                                      'invoice_number':
                                          'REG-${patient.id.split('-').last ?? ""}',
                                      'registration_fee': 200,
                                      'registration_payment_status':
                                          patient.status == 'Active'
                                          ? 'Paid'
                                          : 'Pending',
                                      'prescription_notes':
                                          'Initial patient registration from Customer Care. UHID: ${patient.id ?? ""}.',
                                      'recorded_at': DateTime.now()
                                          .toIso8601String(),
                                    },
                                  );

                                  return EmrdListItemCard(
                                    record: patientRecord,
                                    onTap: () {
                                      context.push(
                                        RouteNames
                                            .patientRegistrationRecordDetail,
                                        extra: patientRecord,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            return const CustomScaffold(
              customAppbar: CommonAppBar(
                title: "Patient Registry & Identification",
              ),
              body: SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
