import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/modules/management/patient_management/presentation/bloc/patient_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_state.dart';

class AdmitPatientDialog extends StatefulWidget {
  const AdmitPatientDialog({super.key});

  @override
  State<AdmitPatientDialog> createState() => _AdmitPatientDialogState();
}

class _AdmitPatientDialogState extends State<AdmitPatientDialog> {
  final _formKey = GlobalKey<FormState>();
  UserModel? _selectedPatient;
  UserModel? _selectedDoctor;
  String _selectedWard = 'General Ward';
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _bedController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _patientSearchController =
      TextEditingController();

  final List<String> _wards = [
    'General Ward',
    'Semi-Private Room',
    'Private Suite',
    'Intensive Care Unit (ICU)',
    'Emergency Observation',
  ];

  @override
  void initState() {
    super.initState();
    // Load patients and doctors if not already loaded
    context.read<PatientBloc>().add(LoadPatients());
    context.read<DoctorStaffBloc>().add(const LoadDoctorStaff('All'));
  }

  @override
  void dispose() {
    _roomController.dispose();
    _bedController.dispose();
    _notesController.dispose();
    _patientSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.terminalDarkCard : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: EdgeInsets.all(20.r),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Patient Admission Session",
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Assign wards, rooms, and admitting doctors",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(height: 12.h),

              // Form Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Patient Selection
                      Text(
                        "Select Patient",
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      BlocBuilder<PatientBloc, PatientState>(
                        builder: (context, state) {
                          if (state is PatientLoading) {
                            return const Center(
                              child: LinearProgressIndicator(),
                            );
                          } else if (state is PatientLoaded) {
                            final patients = state.patients
                                .where((p) => p.role == 'patient')
                                .toList();

                            return Autocomplete<UserModel>(
                              displayStringForOption: (UserModel p) =>
                                  "${p.fullName} (${p.email})",
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return patients;
                                    }
                                    return patients.where((UserModel p) {
                                      final name = p.fullName.toLowerCase();
                                      final email = (p.email ?? '').toLowerCase();
                                      final search = textEditingValue.text
                                          .toLowerCase();
                                      return name.contains(search) ||
                                          email.contains(search);
                                    });
                                  },
                              fieldViewBuilder:
                                  (
                                    context,
                                    controller,
                                    focusNode,
                                    onFieldSubmitted,
                                  ) {
                                    return TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                      decoration: InputDecoration(
                                        hintText:
                                            "Type patient name or email...",
                                        hintStyle: TextStyle(
                                          color: isDark
                                              ? Colors.white38
                                              : Colors.black38,
                                          fontSize: 13.sp,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.person_search,
                                        ),
                                        filled: true,
                                        fillColor: isDark
                                            ? AppColors.terminalDarkFieldFill
                                            : AppColors.terminalLightFieldFill,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          borderSide: BorderSide(
                                            color: isDark
                                                ? Colors.white24
                                                : Colors.black12,
                                          ),
                                        ),
                                      ),
                                      validator: (val) {
                                        if (_selectedPatient == null) {
                                          return "Please select a registered patient";
                                        }
                                        return null;
                                      },
                                    );
                                  },
                              onSelected: (UserModel selection) {
                                setState(() {
                                  _selectedPatient = selection;
                                });
                              },
                            );
                          }
                          return Text(
                            "Failed to load patients list",
                            style: TextStyle(color: AppColors.error),
                          );
                        },
                      ),
                      if (_selectedPatient != null) ...[
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                                size: 16.r,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  "Selected: ${_selectedPatient!.fullName} | Blood: ${_selectedPatient!.bloodGroup ?? 'O+'}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 16.h),

                      // 2. Ward and Bed Details
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ward Type",
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedWard,
                                  dropdownColor: isDark
                                      ? AppColors.terminalDarkCard
                                      : Colors.white,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: isDark
                                        ? AppColors.terminalDarkFieldFill
                                        : AppColors.terminalLightFieldFill,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: BorderSide(
                                        color: isDark
                                            ? Colors.white24
                                            : Colors.black12,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                  ),
                                  items: _wards.map((w) {
                                    return DropdownMenuItem(
                                      value: w,
                                      child: Text(
                                        w,
                                        style: TextStyle(fontSize: 13.sp),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        _selectedWard = val;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _roomController,
                              label: "Room Number",
                              hint: "e.g. 304-A",
                              icon: Icons.meeting_room_outlined,
                              isDark: isDark,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Required";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildTextField(
                              controller: _bedController,
                              label: "Bed Number",
                              hint: "e.g. Bed 2",
                              icon: Icons.bed_outlined,
                              isDark: isDark,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Required";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // 3. Admitting Doctor Selection
                      Text(
                        "Admitting Doctor",
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
                        builder: (context, state) {
                          List<UserModel> doctors = [];
                          if (state is DoctorStaffLoaded) {
                            doctors = state.doctors
                                .where((u) => u.role == 'doctor')
                                .toList();
                          }

                          if (doctors.isEmpty) {
                            doctors = const [
                              UserModel(
                                id: 'doc-1',
                                email: 'sarah.j@mediconnect.com',
                                firstName: 'Dr. Sarah',
                                lastName: 'Johnson',
                                role: UserRole.doctor,
                              ),
                              UserModel(
                                id: 'doc-2',
                                email: 'michael.c@mediconnect.com',
                                firstName: 'Dr. Michael',
                                lastName: 'Chen',
                                role: UserRole.doctor,
                              ),
                              UserModel(
                                id: 'doc-3',
                                email: 'james.w@mediconnect.com',
                                firstName: 'Dr. James',
                                lastName: 'Wilson',
                                role: UserRole.doctor,
                              ),
                            ];
                          }

                          return DropdownButtonFormField<UserModel>(
                            initialValue: _selectedDoctor,
                            hint: Text(
                              "Choose a doctor",
                              style: TextStyle(
                                color: isDark ? Colors.white38 : Colors.black38,
                                fontSize: 13.sp,
                              ),
                            ),
                            dropdownColor: isDark
                                ? AppColors.terminalDarkCard
                                : Colors.white,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark
                                  ? AppColors.terminalDarkFieldFill
                                  : AppColors.terminalLightFieldFill,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(
                                  color: isDark
                                      ? Colors.white24
                                      : Colors.black12,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                              ),
                            ),
                            items: doctors.map((d) {
                              return DropdownMenuItem(
                                value: d,
                                child: Text(
                                  "${d.fullName} (General Medicine)",
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedDoctor = val;
                              });
                            },
                            validator: (val) {
                              if (val == null) {
                                return "Please select admitting doctor";
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      SizedBox(height: 16.h),

                      // 4. Notes
                      _buildTextField(
                        controller: _notesController,
                        label: "Admission Reason & Notes",
                        hint:
                            "Enter clinical indication, symptoms, or emergency remarks...",
                        icon: Icons.notes,
                        isDark: isDark,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: _admitPatient,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: const Text(
                      "Admit Patient",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _admitPatient() {
    if (_formKey.currentState!.validate() &&
        _selectedPatient != null &&
        _selectedDoctor != null) {
      // Update patient status to 'Admitted'
      final updatedPatient = _selectedPatient!.copyWith(
        status: 'Admitted',
      );

      context.read<PatientBloc>().add(UpdatePatient(updatedPatient));

      Navigator.pop(context); // Close dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${_selectedPatient!.fullName} admitted successfully to $_selectedWard.",
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    final borderColor = isDark ? Colors.white24 : Colors.black12;
    final fillCol = isDark
        ? AppColors.terminalDarkFieldFill
        : AppColors.terminalLightFieldFill;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark
                  ? AppColors.terminalDarkFooterText.withValues(alpha: 0.5)
                  : Colors.black38,
              fontSize: 13.sp,
            ),
            prefixIcon: Icon(
              icon,
              size: 20.r,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
            filled: true,
            fillColor: fillCol,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
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
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
