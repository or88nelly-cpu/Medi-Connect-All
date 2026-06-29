import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/domain/entities/department_entity.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/widgets/department_horizontal_list.dart';

/// Full department list page accessible from all roles.
/// Admin users see edit/delete actions per card and a floating "Create New" FAB.
/// All roles see horizontal-first view with a "View All" toggle to full grid.
class SectionListHome extends StatelessWidget {
  const SectionListHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DepartmentBloc, DepartmentState>(
      listener: (context, state) {
        if (state is DepartmentActionSuccess) {
          // Refresh list with updated data after any action.
          context.read<DepartmentBloc>().add(const LoadDepartments());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is DepartmentError) {
          showDialog(
            context: context,
            builder: (_) => ErrorDialog(message: state.failure.message),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final isAdmin =
              authState is Authenticated && authState.user.role == 'admin';
          return _sectionListContent(isAdmin: isAdmin);
        },
      ),
    );
  }

  Widget _sectionListContent({required bool isAdmin}) {
    return BlocBuilder<DepartmentBloc, DepartmentState>(
      builder: (context, state) {
        if (state is DepartmentLoading || state is DepartmentInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        List<DepartmentEntity> departments = [];
        if (state is DepartmentsLoaded) {
          departments = state.sections;
          log("sections $departments");
        } else if (state is DepartmentActionSuccess) {
          departments = state.updatedDepartments
              .where((e) => !e.consultation)
              .toList();
        }
        return DepartmentHorizontalList(
          departments: departments,
          title: AppStrings.sections,
          color: AppColors.surface,
        );
      },
    );
  }
}
