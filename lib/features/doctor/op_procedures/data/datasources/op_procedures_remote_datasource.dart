import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/features/doctor/op_procedures/data/models/op_procedure_model.dart';

abstract class OpProceduresRemoteDataSource {
  Future<List<OpProcedureModel>> getOpProcedures();
}

@LazySingleton(as: OpProceduresRemoteDataSource)
class OpProceduresRemoteDataSourceImpl implements OpProceduresRemoteDataSource {
  final SupabaseService _supabaseService;

  OpProceduresRemoteDataSourceImpl(this._supabaseService);

  @override
  Future<List<OpProcedureModel>> getOpProcedures() async {
    return const [
      OpProcedureModel(
        tokenNumber: '101',
        patientName: 'Arjun Nambiar',
        patientId: 'OP2506271',
        age: '32',
        gender: 'Male',
        procedure: 'ECG',
        diagnosis: 'Chest Pain',
        time: '09:00 AM',
        date: '27 Jun, 2026',
        status: 'Completed',
        paymentAmount: 500,
        paymentStatus: 'Paid',
        priority: 'High',
        profilePhoto: 'assets/images/male_avatar.png',
      ),
      OpProcedureModel(
        tokenNumber: '102',
        patientName: 'Sneha Menon',
        patientId: 'OP2506272',
        age: '28',
        gender: 'Female',
        procedure: 'Spirometry',
        diagnosis: 'Asthma',
        time: '09:30 AM',
        date: '27 Jun, 2026',
        status: 'In Progress',
        paymentAmount: 800,
        paymentStatus: 'Pending',
        priority: 'Medium',
        profilePhoto: 'assets/images/female_avatar.png',
      ),
      OpProcedureModel(
        tokenNumber: '103',
        patientName: 'Vishnu Prasad',
        patientId: 'OP2506273',
        age: '45',
        gender: 'Male',
        procedure: 'X-Ray Chest',
        diagnosis: 'Chronic Cough',
        time: '10:00 AM',
        date: '27 Jun, 2026',
        status: 'Scheduled',
        paymentAmount: 600,
        paymentStatus: 'Pending',
        priority: 'Medium',
        profilePhoto: 'assets/images/male_avatar.png',
      ),
      OpProcedureModel(
        tokenNumber: '104',
        patientName: 'Anjali Raj',
        patientId: 'OP2506274',
        age: '24',
        gender: 'Female',
        procedure: 'Blood Test',
        diagnosis: 'Fatigue',
        time: '10:30 AM',
        date: '27 Jun, 2026',
        status: 'Completed',
        paymentAmount: 300,
        paymentStatus: 'Paid',
        priority: 'Low',
        profilePhoto: 'assets/images/female_avatar.png',
      ),
      OpProcedureModel(
        tokenNumber: '105',
        patientName: 'Ramesh Kumar',
        patientId: 'OP2506275',
        age: '56',
        gender: 'Male',
        procedure: 'USG Abdomen',
        diagnosis: 'Abdominal Pain',
        time: '11:00 AM',
        date: '27 Jun, 2026',
        status: 'Cancelled',
        paymentAmount: 900,
        paymentStatus: 'Refunded',
        priority: 'High',
        profilePhoto: 'assets/images/male_avatar.png',
      ),
    ];
  }
}
