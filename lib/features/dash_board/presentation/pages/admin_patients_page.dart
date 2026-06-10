import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AdminPatientsPage extends StatefulWidget {
  const AdminPatientsPage({super.key});

  @override
  State<AdminPatientsPage> createState() => _AdminPatientsPageState();
}

class _AdminPatientsPageState extends State<AdminPatientsPage> {
  final List<Map<String, String>> _patients = [
    {
      'id': 'PAT-001',
      'name': 'John Doe',
      'age': '45',
      'gender': 'Male',
      'blood': 'O+',
      'phone': '+91 98765 43210'
    },
    {
      'id': 'PAT-002',
      'name': 'Alice Smith',
      'age': '29',
      'gender': 'Female',
      'blood': 'A-',
      'phone': '+91 98765 43211'
    },
    {
      'id': 'PAT-003',
      'name': 'Robert Johnson',
      'age': '62',
      'gender': 'Male',
      'blood': 'B+',
      'phone': '+91 98765 43212'
    },
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredList = _patients.where((p) {
      return p['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p['phone']!.contains(_searchQuery);
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
                AppStrings.patients,
                style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddPatientDialog(context),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Add Patient", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: "Search patient by name or phone...",
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
                      final patient = filteredList[idx];
                      return Card(
                        margin: EdgeInsets.only(bottom: 12.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.r),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Icon(
                              patient['gender'] == 'Male' ? Icons.male : Icons.female,
                              color: AppColors.primary,
                            ),
                          ),
                          title: Text(
                            patient['name']!,
                            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4.h),
                              Text("ID: ${patient['id']!} | Age: ${patient['age']!} | Blood: ${patient['blood']!}"),
                              SizedBox(height: 2.h),
                              Text("Phone: ${patient['phone']!}"),
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

  void _showAddPatientDialog(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final phoneController = TextEditingController();
    String gender = 'Male';
    String blood = 'O+';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text("Add Patient", style: AppTextStyles.titleLarge),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Age"),
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    const Text("Gender: "),
                    SizedBox(width: 8.w),
                    DropdownButton<String>(
                      value: gender,
                      items: ['Male', 'Female', 'Other'].map((g) {
                        return DropdownMenuItem(value: g, child: Text(g));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => gender = val);
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Blood: "),
                    SizedBox(width: 8.w),
                    DropdownButton<String>(
                      value: blood,
                      items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'].map((b) {
                        return DropdownMenuItem(value: b, child: Text(b));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => blood = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _patients.insert(0, {
                      'id': 'PAT-${DateTime.now().millisecond}',
                      'name': nameController.text,
                      'age': ageController.text.isEmpty ? '30' : ageController.text,
                      'gender': gender,
                      'blood': blood,
                      'phone': phoneController.text.isEmpty ? '+91 99999 88888' : phoneController.text,
                    });
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Patient registered successfully.")),
                  );
                }
              },
              child: const Text(AppStrings.submit),
            ),
          ],
        ),
      ),
    );
  }
}
