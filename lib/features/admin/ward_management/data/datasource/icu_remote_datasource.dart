import 'package:injectable/injectable.dart';

abstract class IcuRemoteDataSource {
  Future<Map<String, dynamic>> getIcuStats();
}

@LazySingleton(as: IcuRemoteDataSource)
class IcuRemoteDataSourceImpl implements IcuRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getIcuStats() async {
    return {
      'beds_total': 20,
      'beds_occupied': 16,
      'ventilators_in_use': 12,
      'oxygen_pressure_status': 'Normal',
      'nurse_to_patient_ratio': '1:1',
    };
  }
}
