import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/features/management/staff_management/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/management/staff_management/presentation/bloc/doctor_staff_event.dart';

class AdminDoctorDialogs {
  static void showSelectDepartmentAndCreate(BuildContext context) {
    final state = context.read<DepartmentBloc>().state;
    List<String> list = [];
    if (state is DepartmentsLoaded) {
      list.addAll(
        state.sections.map((e) => e.name).where((name) => name.isNotEmpty),
      );
      list.addAll(
        state.departments.map((e) => e.name).where((name) => name.isNotEmpty),
      );
      list = list.toSet().toList();
    }

    if (list.isEmpty) {
      list = [
        'General Medicine',
        'Cardiology',
        'Neurology',
        'Pediatrics',
        'Emergency',
        'OPD',
      ];
    }

    String selectedDept = list.first;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text("Select Department"),
          content: DropdownButton<String>(
            value: selectedDept,
            isExpanded: true,
            items: list.map((d) {
              return DropdownMenuItem(value: d, child: Text(d));
            }).toList(),
            onChanged: (val) {
              if (val != null) setDialogState(() => selectedDept = val);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context
                    .push(
                      '/admin/doctor-staff/create',
                      extra: {'role': 'doctor', 'department': selectedDept},
                    )
                    .then((value) {
                      if (value == true && context.mounted) {
                        context.read<DoctorStaffBloc>().add(
                          const LoadDoctorStaff('All'),
                        );
                      }
                    });
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
