import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/widgets/error_state_widget.dart';
import 'package:medi_connect/core/widgets/no_data_widget.dart';
import 'package:medi_connect/features/admin/home/presentation/bloc/admin_home_bloc.dart';
import 'package:medi_connect/features/admin/home/presentation/bloc/admin_home_state.dart';
import 'package:medi_connect/features/admin/home/presentation/widgets/admin_module_card.dart';

/// Responsive grid of Admin Control Center module cards.
/// Consumes [AdminHomeBloc] to render loading, error, or loaded states.
class AdminModulesGrid extends StatelessWidget {
  const AdminModulesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminHomeBloc, AdminHomeState>(
      builder: (context, state) {
        if (state is AdminHomeLoading) {
          return const _LoadingIndicator();
        }
        if (state is AdminHomeError) {
          return ErrorStateWidget(message: state.message);
        }
        if (state is AdminHomeLoaded) {
          return _ModuleGridContent(state: state);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ModuleGridContent extends StatelessWidget {
  final AdminHomeLoaded state;

  const _ModuleGridContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final modules = state.filteredModules;

    if (modules.isEmpty) {
      return const NoDataWidget(message: AppStrings.noMatchingModules);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: modules.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _crossAxisCount(constraints.maxWidth),
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final module = modules[index];
            return AdminModuleCard(
              module: module,
              onTap: () {
                if (module.routeName != null) context.push(module.routeName!);
              },
            );
          },
        );
      },
    );
  }

  int _crossAxisCount(double width) {
    if (width > 1200) return 4;
    if (width > 850) return 3;
    if (width > 600) return 2;
    return 1;
  }
}
