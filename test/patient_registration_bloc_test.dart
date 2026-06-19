import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/patient/domain/repositories/patient_repository.dart';
import 'package:medi_connect/modules/departments/customer_care/presentation/bloc/patient_registration_bloc.dart';
import 'package:medi_connect/modules/departments/customer_care/presentation/bloc/patient_registration_event.dart';
import 'package:medi_connect/modules/departments/customer_care/presentation/bloc/patient_registration_state.dart';

class FakePatientRepository implements PatientRepository {
  bool registerCalled = false;
  UserModel? registeredPatient;
  Map<String, dynamic>? sentMrdRecord;
  Either<Failure, void> registerResult = const Right(null);

  @override
  Future<Either<Failure, List<UserModel>>> getPatients() async => const Right([]);

  @override
  Future<Either<Failure, UserModel>> createPatient(UserModel patient) async => Right(patient);

  @override
  Future<Either<Failure, UserModel>> updatePatient(UserModel patient) async => Right(patient);

  @override
  Future<Either<Failure, void>> deletePatient(String patientId) async => const Right(null);

  @override
  Future<Either<Failure, void>> registerPatientAndSendToMRD(
    UserModel patient,
    Map<String, dynamic> mrdRecord,
  ) async {
    registerCalled = true;
    registeredPatient = patient;
    sentMrdRecord = mrdRecord;
    return registerResult;
  }
}

void main() {
  late FakePatientRepository fakeRepository;
  late PatientRegistrationBloc bloc;

  setUp(() {
    fakeRepository = FakePatientRepository();
    bloc = PatientRegistrationBloc(fakeRepository);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should contain auto-generated UHID starting with CCH25-', () {
    expect(bloc.state.generatedUHID, startsWith('CCH25-'));
    expect(bloc.state.status, PatientRegistrationStatus.initial);
  });

  test('UpdateFormFieldsEvent should update state fields accordingly', () async {
    bloc.add(const UpdateFormFieldsEvent(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@test.com',
      phone: '9876543210',
      dob: '01/01/1990',
      sex: 'Male',
      genderIdentity: 'Cisgender Male',
      bloodGroup: 'O+',
      place: 'MG Road',
      wardNum: '10',
      insuranceProvider: 'Star Health',
      insurancePolicyId: 'POL123',
      insuranceValidTill: '31/12/2026',
      smoking: 'No',
      alcohol: 'No',
      dietType: 'Veg',
      exercise: 'Daily',
      allergies: 'Peanuts',
      otherDetails: 'None',
      emergencyName: 'Jane Doe',
      emergencyRelationship: 'Spouse',
      emergencyPhone: '9876543211',
    ));

    await Future.delayed(Duration.zero);

    expect(bloc.state.firstName, 'John');
    expect(bloc.state.lastName, 'Doe');
    expect(bloc.state.email, 'john.doe@test.com');
    expect(bloc.state.phone, '9876543210');
    expect(bloc.state.dob, '01/01/1990');
    expect(bloc.state.sex, 'Male');
    expect(bloc.state.bloodGroup, 'O+');
    expect(bloc.state.place, 'MG Road');
    expect(bloc.state.wardNum, '10');
    expect(bloc.state.insuranceProvider, 'Star Health');
    expect(bloc.state.insurancePolicyId, 'POL123');
    expect(bloc.state.allergies, 'Peanuts');
    expect(bloc.state.emergencyName, 'Jane Doe');
    expect(bloc.state.emergencyPhone, '9876543211');
  });

  test('FetchAddressEvent should update place and address based on pincode', () async {
    bloc.add(const FetchAddressEvent('560001'));
    
    // Wait for the simulated delay in the BLoC (600ms + buffer)
    await Future.delayed(const Duration(milliseconds: 700));

    expect(bloc.state.place, 'MG Road');
    expect(bloc.state.pincodeFetchedAddress, '#45, MG Road, Bengaluru, Karnataka - 560001');
    expect(bloc.state.isFetchingAddress, false);
  });

  test('SubmitFormEvent should validate required fields and fail if invalid', () async {
    // Blank submit should trigger failure
    bloc.add(const SubmitFormEvent());
    
    await Future.delayed(const Duration(milliseconds: 100));
    expect(bloc.state.status, PatientRegistrationStatus.failure);
    expect(bloc.state.errorMessage, 'First name is required');
  });

  test('SubmitFormEvent should register patient and send to MRD when all fields are valid', () async {
    // 1. Fill fields
    bloc.add(const UpdateFormFieldsEvent(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@test.com',
      phone: '9876543210',
      dob: '01/01/1990',
      sex: 'Male',
      genderIdentity: 'Cisgender Male',
      bloodGroup: 'O+',
      place: 'MG Road',
      wardNum: '10',
      insuranceProvider: 'Star Health',
      insurancePolicyId: 'POL123',
      insuranceValidTill: '31/12/2026',
      smoking: 'No',
      alcohol: 'No',
      dietType: 'Veg',
      exercise: 'Daily',
      allergies: 'Peanuts',
      otherDetails: 'None',
      emergencyName: 'Jane Doe',
      emergencyRelationship: 'Spouse',
      emergencyPhone: '9876543211',
    ));

    // 2. Fetch Address to populate address info
    bloc.add(const FetchAddressEvent('560001'));
    await Future.delayed(const Duration(milliseconds: 700));

    // 3. Submit
    bloc.add(const SubmitFormEvent());
    await Future.delayed(const Duration(milliseconds: 100));

    expect(bloc.state.status, PatientRegistrationStatus.success);
    expect(fakeRepository.registerCalled, true);
    expect(fakeRepository.registeredPatient?.firstName, 'John');
    expect(fakeRepository.registeredPatient?.lastName, 'Doe');
    expect(fakeRepository.registeredPatient?.phoneNumber, '9876543210');
    expect(fakeRepository.registeredPatient?.patientId, bloc.state.generatedUHID);
    expect(fakeRepository.sentMrdRecord?['patient_name'], 'John Doe');
  });
}
