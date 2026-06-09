import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/background_wrapper.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/department/presentation/widgets/department_card.dart';
import 'package:medi_connect/features/department/presentation/widgets/department_form_dialog.dart';
import 'package:medi_connect/features/department/presentation/widgets/department_horizontal_list.dart';

/// Full department list page accessible from all roles.
/// Admin users see edit/delete actions per card and a floating "Create New" FAB.
/// All roles see horizontal-first view with a "View All" toggle to full grid.
class DepartmentListHome extends StatelessWidget {
  const DepartmentListHome({super.key});

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
          return _departmentListContent(isAdmin: isAdmin);
        },
      ),
    );
  }

  Widget _departmentListContent({required bool isAdmin}) {
    return BlocBuilder<DepartmentBloc, DepartmentState>(
      builder: (context, state) {
        if (state is DepartmentLoading || state is DepartmentInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        List<DepartmentEntity> departments = [];
        if (state is DepartmentsLoaded) {
          departments = state.departments;
        } else if (state is DepartmentActionSuccess) {
          departments = state.updatedDepartments;
        }
        return DepartmentHorizontalList(departments: departments);
      },
    );
  }
}
