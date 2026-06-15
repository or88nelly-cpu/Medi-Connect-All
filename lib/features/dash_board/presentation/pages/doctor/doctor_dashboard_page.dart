import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/common/dashboard_tab_cubit.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/doctor/doctor_appointments_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/navigation/doctor_bottom_nav_bar.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/role_drawers.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/create_appointment_wizard_dialog.dart';
import 'package:medi_connect/features/patient/presentation/bloc/patient_bloc.dart';

// Extracted Doctor widgets
import 'package:medi_connect/features/dash_board/presentation/widgets/doctor_dashboard/doctor_home_tab.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/doctor_dashboard/doctor_schedule_tab.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/doctor_dashboard/doctor_patients_tab.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/doctor_dashboard/doctor_consults_tab.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/doctor_dashboard/doctor_profile_tab.dart';

class DoctorDashboardPage extends StatefulWidget {
  const DoctorDashboardPage({super.key});

  @override
  State<DoctorDashboardPage> createState() => _DoctorDashboardPageState();
}

class _DoctorDashboardPageState extends State<DoctorDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckRequested());
    context.read<DoctorAppointmentsBloc>().add(LoadDoctorAppointments());
    context.read<PatientBloc>().add(LoadPatients());
  }

  void _showCreateAppointmentWizard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CreateAppointmentWizardBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardTabCubit(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) context.go(RouteNames.login);
        },
        child: BlocBuilder<DashboardTabCubit, int>(
          builder: (context, currentIndex) {
            return CustomScaffold(
              appBarNeeded: currentIndex == 0,
              customAppbar: currentIndex == 0
                  ? AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.doctorDashboardTitle,
                            style: AppTextStyles.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Your practice at a glance",
                            style: AppTextStyles.bodySmall.copyWith(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white30
                                  : Colors.grey[600],
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(
                            Icons.refresh,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.grey[700],
                            size: 20.r,
                          ),
                          onPressed: () {
                            context.read<DoctorAppointmentsBloc>().add(
                              LoadDoctorAppointments(),
                            );
                            context.read<PatientBloc>().add(LoadPatients());
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Refreshing dashboard..."),
                              ),
                            );
                          },
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.notifications_outlined,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white70
                                    : Colors.grey[700],
                                size: 22.r,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("No new notifications"),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE11D48),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  "6",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, authState) {
                            String? profileImage;
                            String? gender;
                            if (authState is Authenticated) {
                              profileImage = authState.user.profileImage;
                              gender = authState.user.gender;
                            }
                            return Padding(
                              padding: EdgeInsets.only(
                                right: 16.w,
                                left: 8.w,
                                top: 8.h,
                                bottom: 8.h,
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 36.r,
                                    height: 36.r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white24
                                            : Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: CustomImageView(
                                        imagePath:
                                            ProfileImageHelper.resolveImagePath(
                                              profileImage,
                                              'doctor',
                                              gender,
                                            ),
                                        width: 36.r,
                                        height: 36.r,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 10.r,
                                      height: 10.r,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF22C55E),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : null,
              drawer: const DoctorDrawer(),
              body: IndexedStack(
                index: currentIndex,
                children: const [
                  DoctorHomeTab(),
                  DoctorScheduleTab(),
                  DoctorPatientsTab(),
                  DoctorConsultsTab(),
                  DoctorProfileTab(),
                ],
              ),
              bottomNavigationBar: DoctorBottomNavBar(
                currentIndex: currentIndex,
                onTap: (i) => context.read<DashboardTabCubit>().setTab(i),
              ),
              floatingActionButton: currentIndex == 1
                  ? FloatingActionButton(
                      onPressed: () => _showCreateAppointmentWizard(context),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        width: 56.r,
                        height: 56.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF0F6FFF), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    )
                  : null,
            );
          },
        ),
      ),
    );
  }
}
