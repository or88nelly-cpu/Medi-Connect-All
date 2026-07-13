import 'dart:io';

void main() {
  final filePath =
      r'c:\Users\lnell\Documents\workspace\GitHub\medi_connect\lib\shared\dashboard\presentation\pages\admin\admin_patients_page.dart';
  final destPath =
      r'c:\Users\lnell\Documents\workspace\GitHub\medi_connect\lib\shared\dashboard\presentation\widgets\admin_patients\admin_patient_dialogs.dart';

  final file = File(filePath);
  final lines = file.readAsLinesSync();

  int startIdx = 0;
  int buildIdx = 0;

  for (int i = 0; i < lines.length; i++) {
    if (lines[i].contains('String _generateUUID()')) {
      startIdx = i;
      break;
    }
  }

  for (int i = startIdx; i < lines.length; i++) {
    if (lines[i].contains('Widget build(BuildContext context)')) {
      buildIdx = i;
      break;
    }
  }

  final extractedLines = lines.sublist(startIdx, buildIdx);

  String dialogContent =
      '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/features/management/patient_management/presentation/bloc/patient_bloc.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class AdminPatientDialogs {
''' +
      extractedLines.join('\n') +
      '''
}
''';

  dialogContent = dialogContent.replaceAll(
    'String _generateUUID()',
    'static String generateUUID()',
  );
  dialogContent = dialogContent.replaceAll(
    'int _calculateAge(',
    'static int calculateAge(',
  );
  dialogContent = dialogContent.replaceAll(
    'void _showAddPatientDialog(',
    'static void showAddPatientDialog(',
  );
  dialogContent = dialogContent.replaceAll(
    'void _showEditPatientDialog(',
    'static void showEditPatientDialog(',
  );
  dialogContent = dialogContent.replaceAll(
    'void _showPatientDetailSheet(',
    'static void showPatientDetailSheet(',
  );
  dialogContent = dialogContent.replaceAll(
    'void _showVitalsEntryDialog(',
    'static void showVitalsEntryDialog(',
  );

  dialogContent = dialogContent.replaceAll('_generateUUID()', 'generateUUID()');
  dialogContent = dialogContent.replaceAll('_calculateAge(', 'calculateAge(');
  dialogContent = dialogContent.replaceAll(
    '_showVitalsEntryDialog(',
    'showVitalsEntryDialog(',
  );

  File(destPath).writeAsStringSync(dialogContent);

  final newPageLines = [
    ...lines.sublist(0, startIdx),
    ...lines.sublist(buildIdx),
  ];
  String newPageContent = newPageLines.join('\n');
  newPageContent = newPageContent.replaceAll(
    '_showAddPatientDialog(',
    'AdminPatientDialogs.showAddPatientDialog(',
  );
  newPageContent = newPageContent.replaceAll(
    '_showEditPatientDialog(',
    'AdminPatientDialogs.showEditPatientDialog(',
  );
  newPageContent = newPageContent.replaceAll(
    '_showPatientDetailSheet(',
    'AdminPatientDialogs.showPatientDetailSheet(',
  );

  final importStmt =
      "import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_patients/admin_patient_dialogs.dart';\n";
  newPageContent = newPageContent.replaceAll(
    "import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_patients/patient_card.dart';",
    "import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_patients/patient_card.dart';\n" +
        importStmt,
  );

  file.writeAsStringSync(newPageContent);

  print('Successfully refactored admin_patients_page.dart!');
}
