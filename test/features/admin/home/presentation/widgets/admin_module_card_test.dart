import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medi_connect/features/admin/home/domain/entities/admin_dashboard_module_entity.dart';
import 'package:medi_connect/features/admin/home/presentation/widgets/admin_module_card.dart';

void main() {
  const testModule = AdminDashboardModuleEntity(
    id: 'departments',
    title: 'Departments',
    description: 'Manage all departments in your hospital',
    countText: '24 Departments',
    iconKey: 'departments',
    colorHex: 0xFF9333EA,
    accentColorHex: 0xFFA855F7,
  );

  Widget createWidgetUnderTest({required VoidCallback onTap}) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        home: Scaffold(
          body: AdminModuleCard(module: testModule, onTap: onTap),
        ),
      ),
    );
  }

  testWidgets(
    'AdminModuleCard renders title, description, and count text correctly',
    (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(onTap: () {}));

      expect(find.text('Departments'), findsOneWidget);
      expect(
        find.text('Manage all departments in your hospital'),
        findsOneWidget,
      );
      expect(find.text('24 Departments'), findsOneWidget);
    },
  );

  testWidgets('AdminModuleCard triggers onTap callback when tapped', (
    tester,
  ) async {
    bool tapped = false;

    await tester.pumpWidget(
      createWidgetUnderTest(
        onTap: () {
          tapped = true;
        },
      ),
    );

    await tester.tap(find.byType(AdminModuleCard));
    await tester.pumpAndSettle();

    expect(tapped, true);
  });
}
