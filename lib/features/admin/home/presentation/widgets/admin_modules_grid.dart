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

/// Responsive staggered grid of [AdminModuleCard] widgets.
class AdminModulesGrid extends StatelessWidget {
  const AdminModulesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminHomeBloc, AdminHomeState>(
      builder: (context, state) {
        if (state is AdminHomeLoading) return const _Loader();
        if (state is AdminHomeError)
          return ErrorStateWidget(message: state.message);
        if (state is AdminHomeLoaded) return _Grid(state: state);
        return const SizedBox.shrink();
      },
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(40),
      child: CircularProgressIndicator(),
    ),
  );
}

class _Grid extends StatelessWidget {
  final AdminHomeLoaded state;
  const _Grid({required this.state});

  @override
  Widget build(BuildContext context) {
    final modules = state.filteredModules;
    if (modules.isEmpty)
      return const NoDataWidget(message: AppStrings.noMatchingModules);

    return LayoutBuilder(
      builder: (context, box) {
        final cols = _cols(box.maxWidth);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: modules.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 14.w,
            mainAxisSpacing: 14.h,
            childAspectRatio: 0.75, // portrait — matches badge 55% / info 45%
          ),
          itemBuilder: (context, i) => AdminModuleCard(
            key: ValueKey(modules[i].id),
            module: modules[i],
            entranceDelay: Duration(milliseconds: i * 45),
            onTap: () {
              if (modules[i].routeName != null)
                context.push(modules[i].routeName!);
            },
          ),
        );
      },
    );
  }

  int _cols(double w) {
    if (w > 1100) return 4;
    if (w > 750) return 3;
    if (w > 500) return 2;
    return 1;
  }
}
