import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AdminAppointmentsPage extends StatefulWidget {
  const AdminAppointmentsPage({super.key});

  @override
  State<AdminAppointmentsPage> createState() => _AdminAppointmentsPageState();
}

class _AdminAppointmentsPageState extends State<AdminAppointmentsPage> {
  final List<Map<String, String>> _appointments = [
    {
      'id': 'APT-001',
      'patient': 'John Doe',
      'doctor': 'Dr. Sarah Chen',
      'time': '10:30 AM',
      'status': 'Confirmed',
      'specialty': 'Cardiology',
    },
    {
      'id': 'APT-002',
      'patient': 'Alice Smith',
      'doctor': 'Dr. Michael Chen',
      'time': '11:15 AM',
      'status': 'Pending',
      'specialty': 'Neurology',
    },
    {
      'id': 'APT-003',
      'patient': 'Robert Johnson',
      'doctor': 'Dr. Sarah Chen',
      'time': '02:00 PM',
      'status': 'Completed',
      'specialty': 'Cardiology',
    },
    {
      'id': 'APT-004',
      'patient': 'Emily Davis',
      'doctor': 'Dr. James Wilson',
      'time': '03:30 PM',
      'status': 'Cancelled',
      'specialty': 'Pediatrics',
    },
  ];

  String _filterStatus = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredList = _appointments.where((apt) {
      final matchesStatus =
          _filterStatus == 'All' || apt['status'] == _filterStatus;
      final matchesSearch =
          apt['patient']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          apt['doctor']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.appointments,
                style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp),
              ),
              ElevatedButton.icon(
                onPressed: () => _showCreateAppointmentDialog(context),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Create",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Search & Filter
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: "Search patient or doctor...",
              prefixIcon: const Icon(Icons.search),
              contentPadding: EdgeInsets.all(12.r),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  ['All', 'Confirmed', 'Pending', 'Completed', 'Cancelled'].map(
                    (status) {
                      final isSelected = _filterStatus == status;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: ChoiceChip(
                          label: Text(status),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) setState(() => _filterStatus = status);
                          },
                          selectedColor: AppColors.primary.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ).toList(),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Text(
                      AppStrings.noRecords,
                      style: AppTextStyles.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, idx) {
                      final apt = filteredList[idx];
                      Color statusColor;
                      switch (apt['status']) {
                        case 'Confirmed':
                          statusColor = AppColors.success;
                          break;
                        case 'Pending':
                          statusColor = AppColors.warning;
                          break;
                        case 'Completed':
                          statusColor = AppColors.primary;
                          break;
                        default:
                          statusColor = AppColors.error;
                      }

                      return Card(
                        margin: EdgeInsets.only(bottom: 12.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.r),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                apt['patient']!,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  apt['status']!,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4.h),
                              Text(
                                "Doctor: ${apt['doctor']!} (${apt['specialty']!})",
                              ),
                              SizedBox(height: 2.h),
                              Text("Time: ${apt['time']!}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showCreateAppointmentDialog(BuildContext context) {
    final nameController = TextEditingController();
    final docController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Create Appointment", style: AppTextStyles.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Patient Name"),
            ),
            TextField(
              controller: docController,
              decoration: const InputDecoration(labelText: "Doctor Name"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  docController.text.isNotEmpty) {
                setState(() {
                  _appointments.insert(0, {
                    'id': 'APT-${DateTime.now().millisecond}',
                    'patient': nameController.text,
                    'doctor': docController.text,
                    'time': '09:00 AM',
                    'status': 'Pending',
                    'specialty': 'General Medicine',
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Appointment created successfully."),
                  ),
                );
              }
            },
            child: const Text(AppStrings.submit),
          ),
        ],
      ),
    );
  }
}
