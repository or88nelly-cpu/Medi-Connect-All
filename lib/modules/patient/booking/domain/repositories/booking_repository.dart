import 'package:medi_connect/modules/patient/booking/domain/entities/doctor_booking_info.dart';
import 'package:medi_connect/shared/auth/data/models/doctor_model.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';

abstract class BookingRepository {
  Future<List<DoctorBookingInfo>> getDoctorsBySpecialty(String specialityId, String specialityName);
  Future<List<Map<String, dynamic>>> getDoctorAvailability(String doctorId);
  Future<void> saveDoctorAvailability(List<Map<String, dynamic>> availabilityList);
  Future<List<String>> getBookedSlots(String doctorId, String dateStr);
  Future<void> saveAppointment(Map<String, dynamic> data);
}
