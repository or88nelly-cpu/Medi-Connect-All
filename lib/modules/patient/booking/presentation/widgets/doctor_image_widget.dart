import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/modules/patient/booking/domain/usecases/get_doctor_image_usecase.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/doctor_image/doctor_image_bloc.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/doctor_image/doctor_image_event.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/doctor_image/doctor_image_state.dart';

class DoctorImageWidget extends StatelessWidget {
  final String? doctorId;
  final double size;

  const DoctorImageWidget({
    super.key,
    required this.doctorId,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorImageBloc(
        getDoctorImage: GetIt.instance<GetDoctorImageUseCase>(),
      )..add(LoadDoctorImage(doctorId ?? "")),
      child: BlocBuilder<DoctorImageBloc, DoctorImageState>(
        builder: (context, state) {
          String? photo;
          String? gender;
          if (state is DoctorImageLoaded) {
            photo = state.imageUrl;
            gender = state.gender;
          }
          final isFemale = gender != null &&
              (gender.toLowerCase().contains('female') ||
                  gender.toLowerCase().contains('woman'));
          final fallbackAvatar = isFemale ? AppAssets.femaleAvatarPng : AppAssets.maleAvatarPng;

          return ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: CustomImageView(
              imagePath: photo ?? "",
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorWidget: Image.asset(
                fallbackAvatar,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
