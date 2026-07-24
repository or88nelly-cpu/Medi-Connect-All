import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/widgets/error_state_widget.dart';
import 'package:medi_connect/core/widgets/no_data_widget.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/features/admin/department_details/presentation/widgets/department_details_header.dart';
import 'package:medi_connect/features/admin/department_details/presentation/widgets/department_grid_view.dart';
import 'package:medi_connect/features/admin/department_details/presentation/widgets/department_search_bar.dart';
import 'package:medi_connect/features/admin/department_details/presentation/widgets/department_table_view.dart';
import 'package:medi_connect/features/admin/department_details/presentation/widgets/department_view_toggle.dart';
import 'package:medi_connect/features/admin/staff_management/domain/entities/department_entity.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/bloc/department_bloc.dart';

/// Department Details page with dynamic Grid View vs Table View toggle.
class DepartmentDetailsPage extends StatefulWidget {
  const DepartmentDetailsPage({super.key});

  @override
  State<DepartmentDetailsPage> createState() => _DepartmentDetailsPageState();
}

class _DepartmentDetailsPageState extends State<DepartmentDetailsPage> {
  DepartmentViewMode _viewMode = DepartmentViewMode.grid;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepartmentBloc>().add(const LoadDepartments());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DepartmentEntity> _applyFilter(List<DepartmentEntity> list) {
    if (_searchQuery.isEmpty) return list;
    return list.where((dept) {
      return dept.name.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DepartmentDetailsHeader(),
            SizedBox(height: AppDimensions.spaceXL),
            _buildToolbar(),
            SizedBox(height: AppDimensions.spaceL),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Row(
      children: [
        Expanded(
          child: DepartmentSearchBar(
            controller: _searchController,
            onChanged: (val) =>
                setState(() => _searchQuery = val.toLowerCase().trim()),
          ),
        ),
        SizedBox(width: AppDimensions.spaceM),
        DepartmentViewToggle(
          currentMode: _viewMode,
          onChanged: (mode) => setState(() => _viewMode = mode),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return BlocBuilder<DepartmentBloc, DepartmentState>(
      builder: (context, state) {
        if (state is DepartmentLoading) {
          return _viewMode == DepartmentViewMode.grid
              ? const DepartmentGridView(departments: [], isLoading: true)
              : const DepartmentTableView(departments: [], isLoading: true);
        }

        if (state is DepartmentError) {
          return ErrorStateWidget(message: state.failure.message);
        }

        final rawList = _resolveList(state);
        final filtered = _applyFilter(rawList);

        if (filtered.isEmpty) {
          return const NoDataWidget(message: AppStrings.noDepartmentsFound);
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _viewMode == DepartmentViewMode.grid
              ? DepartmentGridView(
                  key: const ValueKey('grid'),
                  departments: filtered,
                )
              : DepartmentTableView(
                  key: const ValueKey('table'),
                  departments: filtered,
                ),
        );
      },
    );
  }

  List<DepartmentEntity> _resolveList(DepartmentState state) {
    if (state is DepartmentsLoaded) return state.departments;
    if (state is DepartmentActionSuccess) return state.updatedDepartments;
    return [];
  }
}
