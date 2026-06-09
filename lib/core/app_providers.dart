import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/dashboard_analytics_bloc.dart';

class AppProviders {
  static List<BlocProvider> getProviders() {
    final sl = GetIt.instance;
    return [
      BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
      BlocProvider<DashboardAnalyticsBloc>(
        create: (_) => sl<DashboardAnalyticsBloc>(),
      ),
    ];
  }
}
