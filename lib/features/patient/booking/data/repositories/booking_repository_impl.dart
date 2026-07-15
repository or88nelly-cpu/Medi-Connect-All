import 'package:injectable/injectable.dart';
import 'package:medi_connect/features/authentication/data/models/doctor_model.dart';
import 'package:medi_connect/features/authentication/data/models/user_model.dart';
import 'package:medi_connect/features/patient/booking/data/datasources/booking_remote_datasource.dart';
import 'package:medi_connect/features/patient/booking/domain/entities/doctor_booking_info.dart';
import 'package:medi_connect/features/patient/booking/domain/repositories/booking_repository.dart';

@LazySingleton(as: BookingRepository)
class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;

  BookingRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<DoctorBookingInfo>> getDoctorsBySpecialty(
    String specialityId,
    String specialityName,
  ) async {
    final list = await _remoteDataSource.getDoctorsBySpecialty(
      specialityId,
      specialityName,
    );
    final doctorsList = <DoctorBookingInfo>[];

    for (final item in list) {
      final map = Map<String, dynamic>.from(item as Map);

      final empJson = map.remove('employees');
      Map<String, dynamic>? rawEmpMap;
      if (empJson is List && empJson.isNotEmpty) {
        rawEmpMap = Map<String, dynamic>.from(empJson.first as Map);
      } else if (empJson is Map<String, dynamic>) {
        rawEmpMap = Map<String, dynamic>.from(empJson);
      }

      dynamic docListJson;
      if (rawEmpMap != null) {
        docListJson = rawEmpMap.remove('doctors');
        map.addAll(rawEmpMap);
      }

      if (docListJson == null && map.containsKey('doctors')) {
        docListJson = map.remove('doctors');
      }

      DoctorModel? doctorModel;
      Map<String, dynamic>? rawDocMap;

      if (docListJson is List && docListJson.isNotEmpty) {
        rawDocMap = Map<String, dynamic>.from(docListJson.first as Map);
        rawDocMap['user_id'] ??= map['id'];
        rawDocMap['employee_id'] ??=
            rawEmpMap?['id'] ?? 'EMP-${map['id'].hashCode.abs()}';
        doctorModel = DoctorModel.fromJson(rawDocMap);
      } else if (docListJson is Map<String, dynamic>) {
        rawDocMap = Map<String, dynamic>.from(docListJson);
        rawDocMap['user_id'] ??= map['id'];
        rawDocMap['employee_id'] ??=
            rawEmpMap?['id'] ?? 'EMP-${map['id'].hashCode.abs()}';
        doctorModel = DoctorModel.fromJson(rawDocMap);
      }

      final userModel = UserModel.fromJson(map);

      bool isMatch = false;

      // 1. Match by speciality_id
      final specIdMatch =
          doctorModel != null && doctorModel.specialityId == specialityId;
      if (specIdMatch) isMatch = true;

      // 2. Match by specialization in doctors table
      final specialization = rawDocMap?['specialization'] as String?;
      final specNameMatch =
          specialization != null &&
          specialization.toLowerCase() == specialityName.toLowerCase();
      if (specNameMatch) isMatch = true;

      // 3. Match by sub_speciality in doctors table
      final subSpec = rawDocMap?['sub_speciality'] as String?;
      final subSpecMatch =
          subSpec != null &&
          subSpec.toLowerCase() == specialityName.toLowerCase();
      if (subSpecMatch) isMatch = true;

      // 4. Match by department in users table
      final dept = map['department'] as String?;
      final deptMatch =
          dept != null && dept.toLowerCase() == specialityName.toLowerCase();
      if (deptMatch) isMatch = true;

      if (isMatch) {
        doctorsList.add(
          DoctorBookingInfo(user: userModel, doctorInfo: doctorModel),
        );
      }
    }

    return doctorsList;
  }

  @override
  Future<List<Map<String, dynamic>>> getDoctorAvailability(
    String doctorId,
  ) async {
    final list = await _remoteDataSource.getDoctorAvailability(doctorId);
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  @override
  Future<void> saveDoctorAvailability(
    List<Map<String, dynamic>> availabilityList,
  ) async {
    await _remoteDataSource.saveDoctorAvailability(availabilityList);
  }

  @override
  Future<List<String>> getBookedSlots(String doctorId, String dateStr) async {
    final list = await _remoteDataSource.getBookedAppointments(
      doctorId,
      dateStr,
    );
    return list
        .map((item) => (item['appointment_time'] ?? '').toString())
        .where((t) => t.isNotEmpty)
        .toList();
  }

  @override
  Future<void> saveAppointment(Map<String, dynamic> data) async {
    await _remoteDataSource.saveAppointment(data);
  }
}
