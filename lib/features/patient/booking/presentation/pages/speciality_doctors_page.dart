import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/widgets/errors/custom_error_widget.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_status.dart';
import 'package:medi_connect/features/patient/speciality/domain/entities/speciality_entity.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_bloc.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_state.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/doctor_shimmer_loader.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/speciality_doctors_widgets.dart';

class SpecialityDoctorsPage extends StatelessWidget {
  final SpecialityEntity speciality;

  const SpecialityDoctorsPage({super.key, required this.speciality});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpecialityBookingBloc()
        ..add(
          LoadDoctors(
            specialityId: speciality.id,
            specialityName: speciality.name,
          ),
        ),
      child: Builder(
        builder: (context) {
          return CustomScaffold(
            appBarNeeded: true,
            body: BlocBuilder<SpecialityBookingBloc, SpecialityBookingState>(
              builder: (context, state) {
                if (state.status == SpecialityBookingStatus.loading) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: DoctorShimmerLoader(),
                  );
                }

                if (state.status == SpecialityBookingStatus.failure) {
                  return CustomErrorWidget(
                    message: state.errorMessage ?? "Failed to load doctors",
                    onRetry: () => context.read<SpecialityBookingBloc>().add(
                      LoadDoctors(
                        specialityId: speciality.id,
                        specialityName: speciality.name,
                      ),
                    ),
                  );
                }

                final docCount = state.doctors.length;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpecialityHeaderBanner(speciality: speciality),
                      SpecialityStatsRow(docCount: docCount),
                      SizedBox(height: 24.h),
                      const SpecialityShortcutsRow(),
                      SizedBox(height: 24.h),
                      SpecialityDoctorsSection(
                        speciality: speciality,
                        state: state,
                      ),
                      SizedBox(height: 24.h),
                      SpecialityServicesSection(
                        specialityName: speciality.name,
                      ),
                      SizedBox(height: 24.h),
                      SpecialityAboutSection(speciality: speciality),
                      SizedBox(height: 24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: const SpecialitySupportCard(),
                      ),
                      SizedBox(height: 48.h),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
