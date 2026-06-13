import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/features/dash_board/data/data_source/admin_operations_remote_datasource.dart';
import 'package:medi_connect/features/dash_board/domain/entities/activity_log_entity.dart';
import 'package:medi_connect/features/dash_board/domain/entities/attendance_entity.dart';
import 'package:medi_connect/features/dash_board/domain/entities/emergency_entity.dart';
import 'package:medi_connect/features/dash_board/domain/entities/invoice_entity.dart';
import 'package:medi_connect/features/dash_board/domain/entities/lab_test_entity.dart';
import 'package:medi_connect/features/dash_board/domain/entities/pharmacy_item_entity.dart';
import 'package:medi_connect/features/dash_board/domain/repositories/admin_operations_repository.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';


class AdminOperationsRepositoryImpl implements AdminOperationsRepository {
  final AdminOperationsRemoteDataSource _remoteDataSource;

  AdminOperationsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<PharmacyItemEntity>>> getPharmacyItems() async {
    try {
      final items = await _remoteDataSource.getPharmacyItems();
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PharmacyItemEntity>> addPharmacyItem(Map<String, dynamic> data) async {
    try {
      final item = await _remoteDataSource.addPharmacyItem(data);
      return Right(item);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePharmacyItem(String id, Map<String, dynamic> data) async {
    try {
      await _remoteDataSource.updatePharmacyItem(id, data);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePharmacyItem(String id) async {
    try {
      await _remoteDataSource.deletePharmacyItem(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LabTestEntity>>> getLabTests() async {
    try {
      final tests = await _remoteDataSource.getLabTests();
      return Right(tests);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LabTestEntity>> addLabTest(Map<String, dynamic> data) async {
    try {
      final test = await _remoteDataSource.addLabTest(data);
      return Right(test);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateLabTestStatus(String id, String status) async {
    try {
      await _remoteDataSource.updateLabTestStatus(id, status);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceEntity>>> getStaffAttendance({DateTime? date}) async {
    try {
      final attendance = await _remoteDataSource.getStaffAttendance(date: date);
      return Right(attendance);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateAttendanceStatus(String id, String status) async {
    try {
      await _remoteDataSource.updateAttendanceStatus(id, status);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EmergencyEntity>>> getEmergencies() async {
    try {
      final emergencies = await _remoteDataSource.getEmergencies();
      return Right(emergencies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmergencyEntity>> triggerEmergency(Map<String, dynamic> data) async {
    try {
      final emergency = await _remoteDataSource.triggerEmergency(data);
      return Right(emergency);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resolveEmergency(String id) async {
    try {
      await _remoteDataSource.resolveEmergency(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ActivityLogEntity>>> getActivityLogs() async {
    try {
      final logs = await _remoteDataSource.getActivityLogs();
      return Right(logs);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InvoiceEntity>>> getInvoices() async {
    try {
      final invoices = await _remoteDataSource.getInvoices();
      return Right(invoices);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getBillingSummary() async {
    try {
      final summary = await _remoteDataSource.getBillingSummary();
      return Right(summary);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAdminSettings() async {
    try {
      final settings = await _remoteDataSource.getAdminSettings();
      return Right(settings);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateAdminSetting(String key, dynamic value) async {
    try {
      await _remoteDataSource.updateAdminSetting(key, value);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointments() async {
    try {
      final list = await _remoteDataSource.getAppointments();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(Map<String, dynamic> data) async {
    try {
      final result = await _remoteDataSource.createAppointment(data);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateAppointmentStatus(String id, String status) async {
    try {
      await _remoteDataSource.updateAppointmentStatus(id, status);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
