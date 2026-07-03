import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';

class DoctorImageWidget extends StatelessWidget {
  final String? doctorId;
  final double size;

  const DoctorImageWidget({
    super.key,
    required this.doctorId,
    required this.size,
  });

  Future<String?> _getDoctorProfilePhoto() async {
    if (doctorId == null || doctorId!.isEmpty) return null;
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('profile_photo')
          .eq('id', doctorId!)
          .maybeSingle();
      return response?['profile_photo'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getDoctorProfilePhoto(),
      builder: (context, snapshot) {
        final photo = snapshot.data;
        return ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: CustomImageView(
            imagePath: photo ?? "",
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorWidget: Image.asset(
              AppAssets.maleAvatarPng,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
