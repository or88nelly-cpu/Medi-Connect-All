import 'dart:io';

void main() {
  final filePath =
      r'c:\Users\lnell\Documents\workspace\GitHub\medi_connect\lib\shared\dashboard\presentation\widgets\doctor_profile\doctor_profile_admin_view.dart';
  final destPath =
      r'c:\Users\lnell\Documents\workspace\GitHub\medi_connect\lib\shared\dashboard\presentation\widgets\doctor_profile\doctor_profile_tabs.dart';

  final file = File(filePath);
  final lines = file.readAsLinesSync();

  int startIdx = 0;

  for (int i = 0; i < lines.length; i++) {
    if (lines[i].contains('Widget _buildPatientsTab() {')) {
      startIdx = i;
      break;
    }
  }

  // The rest of the file until the last '}'
  final extractedLines = lines.sublist(startIdx, lines.length - 1);

  String tabContent =
      '''
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class DoctorProfileTabs {
''' +
      extractedLines.join('\n') +
      '''
}
''';

  tabContent = tabContent.replaceAll(
    'Widget _buildPatientsTab() {',
    'static Widget buildPatientsTab(BuildContext context) {',
  );
  tabContent = tabContent.replaceAll(
    'Widget _buildDocumentsTab() {',
    'static Widget buildDocumentsTab(BuildContext context) {',
  );
  tabContent = tabContent.replaceAll(
    'void _showUploadDocumentDialog() {',
    'static void showUploadDocumentDialog(BuildContext context) {',
  );
  tabContent = tabContent.replaceAll(
    '_showUploadDocumentDialog()',
    'showUploadDocumentDialog(context)',
  );

  File(destPath).writeAsStringSync(tabContent);

  final newPageLines = lines.sublist(0, startIdx);
  String newPageContent = newPageLines.join('\n') + '\n}\n';

  newPageContent = newPageContent.replaceAll(
    '_buildPatientsTab()',
    'DoctorProfileTabs.buildPatientsTab(context)',
  );
  newPageContent = newPageContent.replaceAll(
    '_buildDocumentsTab()',
    'DoctorProfileTabs.buildDocumentsTab(context)',
  );

  final importStmt =
      "import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/doctor_profile_tabs.dart';\n";
  newPageContent = newPageContent.replaceAll(
    "import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/quick_actions_row.dart';",
    "import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/quick_actions_row.dart';\n" +
        importStmt,
  );

  file.writeAsStringSync(newPageContent);

  print('Successfully refactored doctor_profile_admin_view.dart!');
}
