import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/auth/data/models/patient_model.dart';
import 'package:medi_connect/shared/auth/data/models/employee_model.dart';
import 'package:medi_connect/shared/auth/data/models/doctor_model.dart';
import 'package:medi_connect/shared/auth/domain/entities/app_user_entity.dart';

class AppUserModel extends AppUserEntity {
  const AppUserModel({
    required UserModel super.user,
    super.patient,
    super.employee,
    super.doctor,
  });

  factory AppUserModel.fromData({
    required UserModel user,
    PatientModel? patient,
    EmployeeModel? employee,
    DoctorModel? doctor,
  }) {
    return AppUserModel(
      user: user,
      patient: patient,
      employee: employee,
      doctor: doctor,
    );
  }
}
