import 'package:equatable/equatable.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/auth/data/models/doctor_model.dart';

class DoctorBookingInfo extends Equatable {
  final UserModel user;
  final DoctorModel? doctorInfo;

  const DoctorBookingInfo({required this.user, this.doctorInfo});

  @override
  List<Object?> get props => [user, doctorInfo];
}
