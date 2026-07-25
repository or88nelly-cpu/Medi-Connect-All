import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/widgets/error_state_widget.dart';
import 'package:medi_connect/core/widgets/no_data_widget.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/features/admin/department_details/presentation/widgets/department_grid_view.dart';
import 'package:medi_connect/features/admin/department_details/presentation/widgets/department_page_header.dart';
import 'package:medi_connect/features/admin/department_details/presentation/widgets/department_table_view.dart';
import 'package:medi_connect/features/admin/department_details/presentation/widgets/department_toolbar.dart';
import 'package:medi_connect/features/admin/department_details/presentation/widgets/department_view_toggle.dart';
import 'package:medi_connect/features/admin/staff_management/domain/entities/department_entity.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/bloc/department_bloc.dart';

/// Department Management page — grid/table view with search & filter toolbar.
class DepartmentDetailsPage extends StatefulWidget {
  const DepartmentDetailsPage({super.key});

  @override
  State<DepartmentDetailsPage> createState() => _DepartmentDetailsPageState();
}

class _DepartmentDetailsPageState extends State<DepartmentDetailsPage> {
  DepartmentViewMode _viewMode = DepartmentViewMode.grid;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepartmentBloc>().add(const LoadDepartments());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<DepartmentEntity> _filter(List<DepartmentEntity> list) {
    if (_query.isEmpty) return list;
    return list.where((d) => d.name.toLowerCase().contains(_query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DepartmentPageHeader(),
            SizedBox(height: 20.h),
            DepartmentToolbar(
              searchController: _searchCtrl,
              onSearchChanged: (v) =>
                  setState(() => _query = v.toLowerCase().trim()),
              viewMode: _viewMode,
              onViewModeChanged: (m) => setState(() => _viewMode = m),
            ),
            SizedBox(height: 20.h),
            _DepartmentContent(viewMode: _viewMode, filter: _filter),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content — BlocBuilder extracted to its own widget
// ---------------------------------------------------------------------------

class _DepartmentContent extends StatelessWidget {
  final DepartmentViewMode viewMode;
  final List<DepartmentEntity> Function(List<DepartmentEntity>) filter;

  const _DepartmentContent({required this.viewMode, required this.filter});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentBloc, DepartmentState>(
      builder: (context, state) {
        if (state is DepartmentLoading) {
          return viewMode == DepartmentViewMode.grid
              ? const DepartmentGridView(departments: [], isLoading: true)
              : const DepartmentTableView(departments: [], isLoading: true);
        }

        if (state is DepartmentError) {
          return ErrorStateWidget(message: state.failure.message);
        }

        final list = filter(_resolve(state));

        if (list.isEmpty) {
          return const NoDataWidget(message: AppStrings.noDepartmentsFound);
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: viewMode == DepartmentViewMode.grid
              ? DepartmentGridView(
                  key: const ValueKey('grid'),
                  departments: list,
                )
              : DepartmentTableView(
                  key: const ValueKey('table'),
                  departments: list,
                ),
        );
      },
    );
  }

  List<DepartmentEntity> _resolve(DepartmentState state) {
    if (state is DepartmentsLoaded) return state.departments;
    if (state is DepartmentActionSuccess) return state.updatedDepartments;
    return [];
  }
}
