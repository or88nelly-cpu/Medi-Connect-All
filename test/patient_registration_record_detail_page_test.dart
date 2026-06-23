import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/services/secure_storage_service.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/pages/patient_registration_record_detail_page.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/widgets/registration/id_card_preview.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';

class FakeSecureStorageService extends SecureStorageService {
  final Map<String, String> _data = {};

  @override
  Future<void> write(String key, String value) async {
    _data[key] = value;
  }

  @override
  Future<String?> read(String key) async {
    return _data[key];
  }
}

class FakeEmrdBloc extends Bloc<EmrdEvent, EmrdState> implements EmrdBloc {
  FakeEmrdBloc() : super(EmrdInitial()) {
    on<LoadEmrdStats>((event, emit) {
      emit(const EmrdLoaded({}, emrRecords: []));
    });
  }
}

class FakeAuthBloc extends Bloc<AuthEvent, AuthState> implements AuthBloc {
  FakeAuthBloc() : super(Unauthenticated());
}

void main() {
  setUpAll(() {
    GetIt.I.registerSingleton<SecureStorageService>(FakeSecureStorageService());
    GetIt.I.registerSingleton<EmrdBloc>(FakeEmrdBloc());
    GetIt.I.registerSingleton<AuthBloc>(FakeAuthBloc());
  });

  tearDownAll(() async {
    await GetIt.I.reset();
  });

  Widget buildTestableWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(1200, 1000),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<EmrdBloc>(create: (_) => GetIt.I<EmrdBloc>()),
            BlocProvider<AuthBloc>(create: (_) => GetIt.I<AuthBloc>()),
          ],
          child: child,
        ),
      ),
    );
  }

  final mockRecordPending = {
    'patient_id': 'df5239fb-30cf-4f26-bad7-787bc63487ff',
    'patient_name': 'Sarah Jenkins',
    'specialty': 'Customer Care',
    'registration_payment_status': 'Pending',
    'payment_method': 'Cash',
    'invoice_number': 'REG-123456',
    'prescription_notes':
        'UHID: CCH25-1234567\nAddress: 123 Main St, Place - 560001\nEmergency Contact: Jane Jenkins (Spouse) - 9876543210\nLifestyle:\nSmoking (No)\nAlcohol (No)\nDiet (Veg)\nExercise (Daily)\nAllergies: None\nOther: Remarks here.',
  };

  final mockRecordPaid = {
    'patient_id': 'df5239fb-30cf-4f26-bad7-787bc63487ff',
    'patient_name': 'Sarah Jenkins',
    'specialty': 'Customer Care',
    'registration_payment_status': 'Paid',
    'payment_method': 'UPI/QR',
    'invoice_number': 'REG-123456',
    'prescription_notes':
        'UHID: CCH25-1234567\nAddress: 123 Main St, Place - 560001\nEmergency Contact: Jane Jenkins (Spouse) - 9876543210\nLifestyle:\nSmoking (No)\nAlcohol (No)\nDiet (Veg)\nExercise (Daily)\nAllergies: None\nOther: Remarks here.',
  };

  testWidgets('renders detail sections correctly in Pending status', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      buildTestableWidget(
        PatientRegistrationRecordDetailPage(
          record: mockRecordPending,
          onFetchPatientDetails: (uuid) async => null,
          onConfirmPayment: (rec, pay) async {},
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Check Hero Header details
    expect(find.text('Sarah Jenkins'), findsOneWidget);
    expect(find.text('PENDING FEE'), findsOneWidget);

    // Check personal info cards built
    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Address Information'), findsOneWidget);
    expect(find.text('Lifestyle Details'), findsOneWidget);

    // Check billing section is visible
    expect(find.text('Registration Fee Details'), findsOneWidget);
    expect(find.text('Select Payment Mode'), findsOneWidget);
    expect(find.text('Confirm Payment'), findsOneWidget);
  });

  testWidgets(
    'renders ID Card preview and print/download buttons in Paid status',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestableWidget(
          PatientRegistrationRecordDetailPage(
            record: mockRecordPaid,
            onFetchPatientDetails: (uuid) async => null,
            onConfirmPayment: (rec, pay) async {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('PAID'), findsOneWidget);
      expect(find.text('Patient ID Card Preview'), findsOneWidget);

      // Check ID Card preview is present
      expect(find.byType(IdCardPreview), findsOneWidget);

      // Check Print and Download buttons
      expect(find.text('Print Card'), findsOneWidget);
      expect(find.text('Download Card'), findsOneWidget);
    },
  );
}
