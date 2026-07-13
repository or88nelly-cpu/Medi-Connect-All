import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/textfields/text_fields.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/doctor_image_widget.dart';
import 'package:medi_connect/features/patient/booking/presentation/pages/patient_appointment_detail_page.dart';
import 'package:intl/intl.dart';

class PatientAllAppointmentsPage extends StatefulWidget {
  const PatientAllAppointmentsPage({super.key});

  @override
  State<PatientAllAppointmentsPage> createState() =>
      _PatientAllAppointmentsPageState();
}

class _PatientAllAppointmentsPageState
    extends State<PatientAllAppointmentsPage> {
  final ValueNotifier<String> _searchQueryNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _activeFilterNotifier = ValueNotifier<String>(
    'All',
  );
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AdminAppointmentsBloc>().add(LoadAppointments());
    _searchController.addListener(() {
      _searchQueryNotifier.value = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchQueryNotifier.dispose();
    _activeFilterNotifier.dispose();
    super.dispose();
  }

  bool _isFutureAppointment(DateTime date, String timeStr) {
    try {
      final format = DateFormat('hh:mm a');
      final parsedTime = format.parse(timeStr.trim());
      final combined = DateTime(
        date.year,
        date.month,
        date.day,
        parsedTime.hour,
        parsedTime.minute,
      );
      return combined.isAfter(DateTime.now());
    } catch (_) {
      final now = DateTime.now();
      final todayDateOnly = DateTime(now.year, now.month, now.day);
      return date.isAfter(todayDateOnly) ||
          date.isAtSameMomentAs(todayDateOnly);
    }
  }

  String _formatDateTime(DateTime date, String timeStr) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[date.month - 1]} ${date.day}, $timeStr";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! Authenticated) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = UserModel.fromEntity(authState.user);

        return CustomScaffold(
          customAppbar: const CommonAppBar(title: "My Appointments"),
          body: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                // Search Input Field
                AppTextField(
                  controller: _searchController,
                  labelText: "Search Doctor or Specialty",
                  hintText: "Type doctor name or medical department...",
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.primary,
                    size: 20.r,
                  ),
                ),
                SizedBox(height: 14.h),

                // Horizontal Filters List
                ValueListenableBuilder<String>(
                  valueListenable: _activeFilterNotifier,
                  builder: (context, activeFilter, _) {
                    final filters = const [
                      'All',
                      'Upcoming',
                      'Pending',
                      'Completed',
                      'Cancelled',
                    ];
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: filters.map((filter) {
                          final isSelected = activeFilter == filter;
                          return GestureDetector(
                            onTap: () => _activeFilterNotifier.value = filter,
                            child: Container(
                              margin: EdgeInsets.only(right: 8.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF3B5BFD)
                                    : cardBg,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF3B5BFD)
                                      : AppColors.border(context),
                                ),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade600,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),

                // Appointments list builder
                Expanded(
                  child:
                      BlocBuilder<
                        AdminAppointmentsBloc,
                        AdminAppointmentsState
                      >(
                        builder: (context, aptState) {
                          if (aptState is AdminAppointmentsLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          List<AppointmentEntity> appointments = [];
                          if (aptState is AdminAppointmentsLoaded) {
                            appointments = aptState.appointments
                                .where((apt) => apt.patientId == user.id)
                                .toList();
                          }

                          return ValueListenableBuilder2<String, String>(
                            first: _searchQueryNotifier,
                            second: _activeFilterNotifier,
                            builder: (context, query, filter, _) {
                              // Apply Filters
                              var filteredList = appointments.where((apt) {
                                // Search match
                                final matchQuery =
                                    apt.doctorName.toLowerCase().contains(
                                      query.toLowerCase(),
                                    ) ||
                                    apt.specialty.toLowerCase().contains(
                                      query.toLowerCase(),
                                    );
                                if (!matchQuery) return false;

                                // Filter match
                                var displayStatus = apt.status;
                                final isPast = !_isFutureAppointment(
                                  apt.appointmentDate,
                                  apt.appointmentTime,
                                );
                                if (apt.status.toLowerCase() == 'pending' &&
                                    isPast) {
                                  displayStatus = 'Cancelled';
                                }

                                if (filter == 'All') return true;
                                if (filter == 'Upcoming') {
                                  return (displayStatus.toLowerCase() ==
                                              'confirmed' ||
                                          displayStatus.toLowerCase() ==
                                              'pending') &&
                                      !isPast;
                                }
                                return displayStatus.toLowerCase() ==
                                    filter.toLowerCase();
                              }).toList();

                              if (filteredList.isEmpty) {
                                return Center(
                                  child: Text(
                                    "No appointments found.",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                itemCount: filteredList.length,
                                itemBuilder: (context, idx) {
                                  final apt = filteredList[idx];
                                  final doctorName = apt.doctorName;
                                  final specialty = apt.specialty;
                                  final type = apt.type;
                                  final time = _formatDateTime(
                                    apt.appointmentDate,
                                    apt.appointmentTime,
                                  );

                                  var displayStatus = apt.status;
                                  final isPast = !_isFutureAppointment(
                                    apt.appointmentDate,
                                    apt.appointmentTime,
                                  );
                                  if (apt.status.toLowerCase() == 'pending' &&
                                      isPast) {
                                    displayStatus = 'Cancelled';
                                  } else if (apt.status.toLowerCase() !=
                                          'completed' &&
                                      apt.status.toLowerCase() != 'cancelled' &&
                                      isPast) {
                                    displayStatus = 'Pending Updation';
                                  }

                                  Color statusColor = const Color(
                                    0xFF10B981,
                                  ); // Green Confirmed
                                  if (displayStatus.toLowerCase() ==
                                      'pending') {
                                    statusColor = const Color(0xFFF59E0B);
                                  } else if (displayStatus ==
                                      'Pending Updation') {
                                    statusColor = const Color(0xFFD97706);
                                  } else if (displayStatus.toLowerCase() ==
                                      'cancelled') {
                                    statusColor = const Color(0xFFEF4444);
                                  } else if (displayStatus.toLowerCase() ==
                                      'completed') {
                                    statusColor = const Color(0xFF3B82F6);
                                  }

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              PatientAppointmentDetailPage(
                                                appointment: apt,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 12.h),
                                      padding: EdgeInsets.all(14.r),
                                      decoration: BoxDecoration(
                                        color: cardBg,
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        border: Border.all(
                                          color: AppColors.border(context),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          DoctorImageWidget(
                                            doctorId: apt.doctorId,
                                            size: 44.r,
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  doctorName,
                                                  style: AppTextStyles
                                                      .bodyMedium
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: textColor,
                                                      ),
                                                ),
                                                SizedBox(height: 2.h),
                                                Text(
                                                  "$specialty | $type",
                                                  style: TextStyle(
                                                    fontSize: 9.5.sp,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 4.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: statusColor.withValues(
                                                    alpha: 0.1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        8.r,
                                                      ),
                                                  border: Border.all(
                                                    color: statusColor
                                                        .withValues(alpha: 0.2),
                                                  ),
                                                ),
                                                child: Text(
                                                  displayStatus,
                                                  style: TextStyle(
                                                    color: statusColor,
                                                    fontSize: 8.5.sp,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 6.h),
                                              Text(
                                                time,
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 8.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// â”€â”€ ValueListenableBuilder helper â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueNotifier<A> first;
  final ValueNotifier<B> second;
  final Widget Function(BuildContext context, A a, B b, Widget? child) builder;
  final Widget? child;

  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, a, _) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, _) {
            return builder(context, a, b, child);
          },
        );
      },
    );
  }
}
