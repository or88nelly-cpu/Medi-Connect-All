import 'package:flutter/material.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/constants/app_enum.dart';

class ProfileImageHelper {
  static String resolveImagePath(
    String? profileImage,
    String role,
    String? gender,
  ) {
    if (profileImage != null && profileImage.isNotEmpty) {
      return profileImage;
    }

    final isFemale = gender?.toLowerCase() == 'female';
    if (role == UserRole.doctor.name) {
      return isFemale
          ? AppAssets.femaleDoctorAvatarPng
          : AppAssets.maleDoctorAvatarPng;
    } else if (role == UserRole.staff.name) {
      return isFemale
          ? AppAssets.femaleStaffAvatarPng
          : AppAssets.maleStaffAvatarPng;
    } else if (role == UserRole.admin.name) {
      return isFemale
          ? AppAssets.femaleAdminAvatarPng
          : AppAssets.maleAdminAvatarPng;
    } else if (role == 'patient') {
      return isFemale
          ? AppAssets.babyGirlAvatarPng
          : AppAssets.babyBoyAvatarPng;
    } else {
      return isFemale ? AppAssets.femaleAvatarPng : AppAssets.maleAvatarPng;
    }
  }

  static ImageProvider getAvatarImage(
    String? profileImage,
    String role,
    String? gender,
  ) {
    final path = resolveImagePath(profileImage, role, gender);
    if (path.startsWith('http://') ||
        path.startsWith('https://') ||
        path.startsWith('http') ||
        path.startsWith('https')) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }
}
