import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/services/secure_storage_service.dart';
import 'package:medi_connect/core/theme/theme_cubit.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_settings_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/pages/admin/admin_settings_page.dart';

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

class FakeAdminSettingsBloc extends Bloc<AdminSettingsEvent, AdminSettingsState>
    implements AdminSettingsBloc {
  FakeAdminSettingsBloc()
    : super(
        AdminSettingsLoaded(const {
          'push_notifications': true,
          'sms_alerts': false,
          'email_reports': true,
          'biometric_login': false,
        }),
      ) {
    on<LoadAdminSettings>((event, emit) {
      emit(
        AdminSettingsLoaded(const {
          'push_notifications': true,
          'sms_alerts': false,
          'email_reports': true,
          'biometric_login': false,
        }),
      );
    });
    on<UpdateAdminSetting>((event, emit) {
      if (state is AdminSettingsLoaded) {
        final currentSettings = Map<String, dynamic>.from(
          (state as AdminSettingsLoaded).settings,
        );
        currentSettings[event.key] = event.value;
        emit(AdminSettingsLoaded(currentSettings));
      }
    });
  }
}

class FakeAuthBloc extends Bloc<AuthEvent, AuthState> implements AuthBloc {
  FakeAuthBloc() : super(Unauthenticated());
}

void main() {
  late FakeSecureStorageService fakeSecureStorage;
  late ThemeCubit themeCubit;
  late FakeAdminSettingsBloc fakeAdminSettingsBloc;

  setUp(() {
    fakeSecureStorage = FakeSecureStorageService();
    themeCubit = ThemeCubit(fakeSecureStorage);
    fakeAdminSettingsBloc = FakeAdminSettingsBloc();

    GetIt.I.registerSingleton<SecureStorageService>(fakeSecureStorage);
    GetIt.I.registerSingleton<ThemeCubit>(themeCubit);
    GetIt.I.registerSingleton<AdminSettingsBloc>(fakeAdminSettingsBloc);
    GetIt.I.registerSingleton<AuthBloc>(FakeAuthBloc());
  });

  tearDown(() async {
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
            BlocProvider<ThemeCubit>(create: (_) => GetIt.I<ThemeCubit>()),
            BlocProvider<AdminSettingsBloc>(create: (_) => GetIt.I<AdminSettingsBloc>()),
            BlocProvider<AuthBloc>(create: (_) => GetIt.I<AuthBloc>()),
          ],
          child: child,
        ),
      ),
    );
  }

  testWidgets(
    'renders AdminSettingsPage in standalone mode with AppBar and Settings content',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestableWidget(const AdminSettingsPage(isStandalone: true)),
      );

      // Initial load
      await tester.pumpAndSettle();

      // Check custom AppBar with title "Settings" is present
      expect(find.text('Settings'), findsOneWidget);

      // Check switches render
      expect(find.text('GENERAL PREFERENCES'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Push Notifications'), findsOneWidget);
      expect(find.text('SECURITY & LOGIN'), findsOneWidget);
      expect(find.text('Biometric Login'), findsOneWidget);
      expect(find.text('COMMUNICATION CHANNELS'), findsOneWidget);
      expect(find.text('SMS Alerts'), findsOneWidget);
      expect(find.text('Email Reports'), findsOneWidget);
    },
  );

  testWidgets('renders AdminSettingsPage in tab mode without separate AppBar', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      buildTestableWidget(const AdminSettingsPage(isStandalone: false)),
    );

    await tester.pumpAndSettle();

    // In tab mode (isStandalone: false), the "Settings" text is in the body, not the AppBar.
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('GENERAL PREFERENCES'), findsOneWidget);
  });
}
