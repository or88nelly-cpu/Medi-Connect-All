import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/common/dashboard/domain/entities/activity_log_entity.dart';
import 'package:medi_connect/features/common/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/features/common/dashboard/domain/entities/attendance_entity.dart';
import 'package:medi_connect/features/common/dashboard/domain/entities/emergency_entity.dart';
import 'package:medi_connect/features/common/dashboard/domain/entities/invoice_entity.dart';
import 'package:medi_connect/features/common/dashboard/domain/entities/lab_test_entity.dart';
import 'package:medi_connect/features/common/dashboard/domain/entities/pharmacy_item_entity.dart';
import 'package:medi_connect/features/common/dashboard/domain/repositories/admin_operations_repository.dart';

// Pharmacy Use Cases
@lazySingleton
class GetPharmacyItemsUseCase {
  final AdminOperationsRepository repository;
  GetPharmacyItemsUseCase(this.repository);
  Future<Either<Failure, List<PharmacyItemEntity>>> call() =>
      repository.getPharmacyItems();
}

@lazySingleton
class AddPharmacyItemUseCase {
  final AdminOperationsRepository repository;
  AddPharmacyItemUseCase(this.repository);
  Future<Either<Failure, PharmacyItemEntity>> call(Map<String, dynamic> data) =>
      repository.addPharmacyItem(data);
}

@lazySingleton
class UpdatePharmacyItemUseCase {
  final AdminOperationsRepository repository;
  UpdatePharmacyItemUseCase(this.repository);
  Future<Either<Failure, void>> call(String id, Map<String, dynamic> data) =>
      repository.updatePharmacyItem(id, data);
}

@lazySingleton
class DeletePharmacyItemUseCase {
  final AdminOperationsRepository repository;
  DeletePharmacyItemUseCase(this.repository);
  Future<Either<Failure, void>> call(String id) =>
      repository.deletePharmacyItem(id);
}

// Labs Use Cases
@lazySingleton
class GetLabTestsUseCase {
  final AdminOperationsRepository repository;
  GetLabTestsUseCase(this.repository);
  Future<Either<Failure, List<LabTestEntity>>> call() =>
      repository.getLabTests();
}

@lazySingleton
class AddLabTestUseCase {
  final AdminOperationsRepository repository;
  AddLabTestUseCase(this.repository);
  Future<Either<Failure, LabTestEntity>> call(Map<String, dynamic> data) =>
      repository.addLabTest(data);
}

@lazySingleton
class UpdateLabTestStatusUseCase {
  final AdminOperationsRepository repository;
  UpdateLabTestStatusUseCase(this.repository);
  Future<Either<Failure, void>> call(String id, String status) =>
      repository.updateLabTestStatus(id, status);
}

// Attendance Use Cases
@lazySingleton
class GetStaffAttendanceUseCase {
  final AdminOperationsRepository repository;
  GetStaffAttendanceUseCase(this.repository);
  Future<Either<Failure, List<AttendanceEntity>>> call({DateTime? date}) =>
      repository.getStaffAttendance(date: date);
}

@lazySingleton
class UpdateAttendanceStatusUseCase {
  final AdminOperationsRepository repository;
  UpdateAttendanceStatusUseCase(this.repository);
  Future<Either<Failure, void>> call(String id, String status) =>
      repository.updateAttendanceStatus(id, status);
}

// Emergencies Use Cases
@lazySingleton
class GetEmergenciesUseCase {
  final AdminOperationsRepository repository;
  GetEmergenciesUseCase(this.repository);
  Future<Either<Failure, List<EmergencyEntity>>> call() =>
      repository.getEmergencies();
}

@lazySingleton
class TriggerEmergencyUseCase {
  final AdminOperationsRepository repository;
  TriggerEmergencyUseCase(this.repository);
  Future<Either<Failure, EmergencyEntity>> call(Map<String, dynamic> data) =>
      repository.triggerEmergency(data);
}

@lazySingleton
class ResolveEmergencyUseCase {
  final AdminOperationsRepository repository;
  ResolveEmergencyUseCase(this.repository);
  Future<Either<Failure, void>> call(String id) =>
      repository.resolveEmergency(id);
}

// Activity Logs Use Case
@lazySingleton
class GetActivityLogsUseCase {
  final AdminOperationsRepository repository;
  GetActivityLogsUseCase(this.repository);
  Future<Either<Failure, List<ActivityLogEntity>>> call() =>
      repository.getActivityLogs();
}

// Billing Use Cases
@lazySingleton
class GetInvoicesUseCase {
  final AdminOperationsRepository repository;
  GetInvoicesUseCase(this.repository);
  Future<Either<Failure, List<InvoiceEntity>>> call() =>
      repository.getInvoices();
}

@lazySingleton
class GetBillingSummaryUseCase {
  final AdminOperationsRepository repository;
  GetBillingSummaryUseCase(this.repository);
  Future<Either<Failure, Map<String, double>>> call() =>
      repository.getBillingSummary();
}

@lazySingleton
class CreateInvoiceUseCase {
  final AdminOperationsRepository repository;
  CreateInvoiceUseCase(this.repository);
  Future<Either<Failure, void>> call(Map<String, dynamic> data) =>
      repository.createInvoice(data);
}

// Settings Use Cases
@lazySingleton
class GetAdminSettingsUseCase {
  final AdminOperationsRepository repository;
  GetAdminSettingsUseCase(this.repository);
  Future<Either<Failure, Map<String, dynamic>>> call() =>
      repository.getAdminSettings();
}

@lazySingleton
class UpdateAdminSettingUseCase {
  final AdminOperationsRepository repository;
  UpdateAdminSettingUseCase(this.repository);
  Future<Either<Failure, void>> call(String key, dynamic value) =>
      repository.updateAdminSetting(key, value);
}

// Appointments Use Cases
@lazySingleton
class GetAppointmentsUseCase {
  final AdminOperationsRepository repository;
  GetAppointmentsUseCase(this.repository);
  Future<Either<Failure, List<AppointmentEntity>>> call() =>
      repository.getAppointments();
}

@lazySingleton
class CreateAppointmentUseCase {
  final AdminOperationsRepository repository;
  CreateAppointmentUseCase(this.repository);
  Future<Either<Failure, AppointmentEntity>> call(Map<String, dynamic> data) =>
      repository.createAppointment(data);
}

@lazySingleton
class UpdateAppointmentStatusUseCase {
  final AdminOperationsRepository repository;
  UpdateAppointmentStatusUseCase(this.repository);
  Future<Either<Failure, void>> call(String id, String status) =>
      repository.updateAppointmentStatus(id, status);
}

@lazySingleton
class UpdateAppointmentVitalsUseCase {
  final AdminOperationsRepository repository;
  UpdateAppointmentVitalsUseCase(this.repository);
  Future<Either<Failure, void>> call(String id, Map<String, dynamic> vitals) =>
      repository.updateAppointmentVitals(id, vitals);
}
