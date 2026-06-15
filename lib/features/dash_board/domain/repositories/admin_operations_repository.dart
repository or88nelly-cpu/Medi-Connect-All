import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/dash_board/domain/entities/pharmacy_item_entity.dart';
import 'package:medi_connect/features/dash_board/domain/entities/lab_test_entity.dart';
import 'package:medi_connect/features/dash_board/domain/entities/attendance_entity.dart';
import 'package:medi_connect/features/dash_board/domain/entities/emergency_entity.dart';
import 'package:medi_connect/features/dash_board/domain/entities/activity_log_entity.dart';
import 'package:medi_connect/features/dash_board/domain/entities/invoice_entity.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';

abstract class AdminOperationsRepository {
  // Pharmacy
  Future<Either<Failure, List<PharmacyItemEntity>>> getPharmacyItems();
  Future<Either<Failure, PharmacyItemEntity>> addPharmacyItem(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, void>> updatePharmacyItem(
    String id,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, void>> deletePharmacyItem(String id);

  // Labs
  Future<Either<Failure, List<LabTestEntity>>> getLabTests();
  Future<Either<Failure, LabTestEntity>> addLabTest(Map<String, dynamic> data);
  Future<Either<Failure, void>> updateLabTestStatus(String id, String status);

  // Attendance
  Future<Either<Failure, List<AttendanceEntity>>> getStaffAttendance({
    DateTime? date,
  });
  Future<Either<Failure, void>> updateAttendanceStatus(
    String id,
    String status,
  );

  // Emergencies
  Future<Either<Failure, List<EmergencyEntity>>> getEmergencies();
  Future<Either<Failure, EmergencyEntity>> triggerEmergency(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, void>> resolveEmergency(String id);

  // Activity Logs
  Future<Either<Failure, List<ActivityLogEntity>>> getActivityLogs();

  // Billing / Invoices
  Future<Either<Failure, List<InvoiceEntity>>> getInvoices();
  Future<Either<Failure, Map<String, double>>> getBillingSummary();
  Future<Either<Failure, void>> createInvoice(Map<String, dynamic> data);

  // Settings
  Future<Either<Failure, Map<String, dynamic>>> getAdminSettings();
  Future<Either<Failure, void>> updateAdminSetting(String key, dynamic value);

  // Appointments
  Future<Either<Failure, List<AppointmentEntity>>> getAppointments();
  Future<Either<Failure, AppointmentEntity>> createAppointment(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, void>> updateAppointmentStatus(
    String id,
    String status,
  );
  Future<Either<Failure, void>> updateAppointmentVitals(
    String id,
    Map<String, dynamic> vitals,
  );
}
