import 'dart:io';

void main() {
  final filePath =
      r'c:\Users\lnell\Documents\workspace\GitHub\medi_connect\lib\shared\dashboard\presentation\pages\admin\admin_doctors_page.dart';
  final destPath =
      r'c:\Users\lnell\Documents\workspace\GitHub\medi_connect\lib\shared\dashboard\presentation\widgets\admin_doctors\admin_doctor_dialogs.dart';

  final file = File(filePath);
  final lines = file.readAsLinesSync();

  int startIdx = 0;
  int buildIdx = 0;

  for (int i = 0; i < lines.length; i++) {
    if (lines[i].contains(
      'void _showSelectDepartmentAndCreate(BuildContext context) {',
    )) {
      startIdx = i;
      break;
    }
  }

  for (int i = startIdx; i < lines.length; i++) {
    if (lines[i].contains('@override')) {
      // the override before build
      if (lines[i + 1].contains('Widget build(BuildContext context)')) {
        buildIdx = i;
        break;
      }
    }
  }

  final extractedLines = lines.sublist(startIdx, buildIdx);

  String dialogContent =
      '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/features/management/staff_management/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/management/staff_management/presentation/bloc/doctor_staff_event.dart';

class AdminDoctorDialogs {
''' +
      extractedLines.join('\n') +
      '''
}
''';

  dialogContent = dialogContent.replaceAll(
    'void _showSelectDepartmentAndCreate(',
    'static void showSelectDepartmentAndCreate(',
  );

  File(destPath).writeAsStringSync(dialogContent);

  final newPageLines = [
    ...lines.sublist(0, startIdx),
    ...lines.sublist(buildIdx),
  ];
  String newPageContent = newPageLines.join('\n');
  newPageContent = newPageContent.replaceAll(
    '_showSelectDepartmentAndCreate(context)',
    'AdminDoctorDialogs.showSelectDepartmentAndCreate(context)',
  );

  final importStmt =
      "import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_doctors/admin_doctor_dialogs.dart';\n";
  newPageContent = newPageContent.replaceAll(
    "import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_doctors/doctor_card.dart';",
    "import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_doctors/doctor_card.dart';\n" +
        importStmt,
  );

  file.writeAsStringSync(newPageContent);

  print('Successfully refactored admin_doctors_page.dart!');
}
