import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/dependency_injection/injection.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/features/admin/home/presentation/bloc/admin_home_bloc.dart';
import 'package:medi_connect/features/admin/home/presentation/bloc/admin_home_event.dart';
import 'package:medi_connect/features/admin/home/presentation/widgets/admin_home_body.dart';
import 'package:medi_connect/features/authentication/presentation/bloc/auth_bloc.dart';

/// Admin Control Center Home Page — entry point only.
/// Provides [AdminHomeBloc] and listens for auth state changes.
class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminHomeBloc>(
      create: (_) =>
          getIt<AdminHomeBloc>()..add(const LoadAdminDashboardModules()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) context.go(RouteNames.login);
        },
        child: const AdminHomeBody(),
      ),
    );
  }
}
