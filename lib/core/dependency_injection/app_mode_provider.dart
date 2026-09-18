import 'package:medi_connect/core/constants/env_config.dart';

/// Provides the application mode (single doctor or hospital).
class AppModeProvider {
  final bool isSingleDoctor;

  AppModeProvider() : isSingleDoctor = EnvConfig.isSingleDoctor;
}

/// Provides the current doctor ID based on the mode.
class CurrentDoctorProvider {
  final String doctorId;

  CurrentDoctorProvider()
    : doctorId = EnvConfig.isSingleDoctor ? EnvConfig.singleDoctorId : '';
}
