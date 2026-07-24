import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/features/admin/home/presentation/widgets/admin_control_center_header.dart';
import 'package:medi_connect/features/admin/home/presentation/widgets/admin_modules_grid.dart';
import 'package:medi_connect/features/admin/home/presentation/widgets/admin_sidebar.dart';
import 'package:medi_connect/features/authentication/domain/entities/user_entity.dart';
import 'package:medi_connect/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/common/dashboard/presentation/widgets/admin_drawer.dart';

/// Scaffold body for the Admin Control Center, responsive to desktop/mobile layout.
class AdminHomeBody extends StatelessWidget {
  const AdminHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 950;
    final UserEntity? user = _resolveUser(context);

    return CustomScaffold(
      drawer: isDesktop ? null : const AdminDrawer(),
      appBarNeeded: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.controlCenterBlue,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: Row(
        children: [
          if (isDesktop)
            AdminSidebar(user: user, activeRoute: RouteNames.adminDashboard),
          Expanded(child: _AdminScrollContent(user: user)),
        ],
      ),
    );
  }

  UserEntity? _resolveUser(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    return authState is Authenticated ? authState.user : null;
  }
}

/// Scrollable content column: header + modules grid.
class _AdminScrollContent extends StatelessWidget {
  final UserEntity? user;

  const _AdminScrollContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        AppResponsive.isMobile(context)
            ? AppDimensions.paddingM
            : AppDimensions.paddingXL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminControlCenterHeader(user: user),
          SizedBox(height: AppDimensions.spaceXL),
          const AdminModulesGrid(),
        ],
      ),
    );
  }
}
