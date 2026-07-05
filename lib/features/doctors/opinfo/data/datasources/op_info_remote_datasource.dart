import 'package:medi_connect/features/doctors/opinfo/data/models/op_procedure_model.dart';
import 'package:medi_connect/features/doctors/opinfo/domain/entities/op_info_summary_entity.dart';

abstract class OpInfoRemoteDataSource {
  Future<OpInfoSummaryEntity> getOpInfo({
    required String doctorId,
    required DateTime date,
  });
}

class OpInfoRemoteDataSourceImpl implements OpInfoRemoteDataSource {
  static const _mockProcedures = [
    {
      'id': '1',
      'token_number': 101,
      'patient_id': 'OPD - LNA002',
      'patient_name': 'Arjun Nambiar',
      'age': '3 Years',
      'gender': 'Male',
      'appointment_time': '09:20 AM',
      'status': 'Pending',
      'profile_photo': null,
    },
    {
      'id': '2',
      'token_number': 102,
      'patient_id': 'OPD - LNA003',
      'patient_name': 'Meera Krishnan',
      'age': '28 Years',
      'gender': 'Female',
      'appointment_time': '09:45 AM',
      'status': 'Completed',
      'profile_photo': null,
    },
    {
      'id': '3',
      'token_number': 103,
      'patient_id': 'OPD - LNA004',
      'patient_name': 'Rahul Menon',
      'age': '45 Years',
      'gender': 'Male',
      'appointment_time': '10:10 AM',
      'status': 'Pending',
      'profile_photo': null,
    },
    {
      'id': '4',
      'token_number': 104,
      'patient_id': 'OPD - LNA005',
      'patient_name': 'Ananya Pillai',
      'age': '12 Years',
      'gender': 'Female',
      'appointment_time': '10:35 AM',
      'status': 'Completed',
      'profile_photo': null,
    },
    {
      'id': '5',
      'token_number': 105,
      'patient_id': 'OPD - LNA006',
      'patient_name': 'Vikram Das',
      'age': '56 Years',
      'gender': 'Male',
      'appointment_time': '11:00 AM',
      'status': 'Pending',
      'profile_photo': null,
    },
    {
      'id': '6',
      'token_number': 106,
      'patient_id': 'OPD - LNA007',
      'patient_name': 'Priya Thomas',
      'age': '34 Years',
      'gender': 'Female',
      'appointment_time': '11:25 AM',
      'status': 'Completed',
      'profile_photo': null,
    },
    {
      'id': '7',
      'token_number': 107,
      'patient_id': 'OPD - LNA008',
      'patient_name': 'Suresh Kumar',
      'age': '62 Years',
      'gender': 'Male',
      'appointment_time': '11:50 AM',
      'status': 'Cancelled',
      'profile_photo': null,
    },
    {
      'id': '8',
      'token_number': 108,
      'patient_id': 'OPD - LNA009',
      'patient_name': 'Deepa Nair',
      'age': '41 Years',
      'gender': 'Female',
      'appointment_time': '12:15 PM',
      'status': 'Pending',
      'profile_photo': null,
    },
    {
      'id': '9',
      'token_number': 109,
      'patient_id': 'OPD - LNA010',
      'patient_name': 'Kiran Raj',
      'age': '19 Years',
      'gender': 'Male',
      'appointment_time': '12:40 PM',
      'status': 'Completed',
      'profile_photo': null,
    },
    {
      'id': '10',
      'token_number': 110,
      'patient_id': 'OPD - LNA011',
      'patient_name': 'Lakshmi Iyer',
      'age': '52 Years',
      'gender': 'Female',
      'appointment_time': '01:05 PM',
      'status': 'Pending',
      'profile_photo': null,
    },
    {
      'id': '11',
      'token_number': 111,
      'patient_id': 'OPD - LNA012',
      'patient_name': 'Manoj Varma',
      'age': '38 Years',
      'gender': 'Male',
      'appointment_time': '01:30 PM',
      'status': 'Completed',
      'profile_photo': null,
    },
    {
      'id': '12',
      'token_number': 112,
      'patient_id': 'OPD - LNA013',
      'patient_name': 'Sneha Bose',
      'age': '25 Years',
      'gender': 'Female',
      'appointment_time': '02:00 PM',
      'status': 'Pending',
      'profile_photo': null,
    },
    {
      'id': '13',
      'token_number': 113,
      'patient_id': 'OPD - LNA014',
      'patient_name': 'Harish Chandran',
      'age': '48 Years',
      'gender': 'Male',
      'appointment_time': '02:25 PM',
      'status': 'Completed',
      'profile_photo': null,
    },
    {
      'id': '14',
      'token_number': 114,
      'patient_id': 'OPD - LNA015',
      'patient_name': 'Nisha George',
      'age': '31 Years',
      'gender': 'Female',
      'appointment_time': '02:50 PM',
      'status': 'Pending',
      'profile_photo': null,
    },
  ];

  @override
  Future<OpInfoSummaryEntity> getOpInfo({
    required String doctorId,
    required DateTime date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final procedures = _mockProcedures
        .map((json) => OpProcedureModel.fromJson(json))
        .toList();

    int pending = 0, completed = 0, cancelled = 0;
    for (final p in procedures) {
      switch (p.status.toLowerCase()) {
        case 'pending':
          pending++;
        case 'completed':
          completed++;
        case 'cancelled':
          cancelled++;
      }
    }

    return OpInfoSummaryEntity(
      total: procedures.length,
      pending: pending,
      completed: completed,
      cancelled: cancelled,
      procedures: procedures,
    );
  }
}
