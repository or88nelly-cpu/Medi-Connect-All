import os
import re

file_path = r'c:\Users\lnell\Documents\workspace\GitHub\medi_connect\lib\shared\dashboard\presentation\pages\admin\admin_patients_page.dart'
dest_path = r'c:\Users\lnell\Documents\workspace\GitHub\medi_connect\lib\shared\dashboard\presentation\widgets\admin_patients\admin_patient_dialogs.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

# find exact lines
# _generateUUID is at line 60
# _calculateAge is at line 72
# _showAddPatientDialog is at line 83
# build is at line 1335

start_idx = 0
build_idx = 0

for i, line in enumerate(lines):
    if 'String _generateUUID()' in line:
        start_idx = i
        break

for i in range(start_idx, len(lines)):
    if 'Widget build(BuildContext context)' in line:
        build_idx = i
        break

extracted_lines = lines[start_idx:build_idx]

# Create dialogs file
dialog_content = '''import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/features/management/patient_management/presentation/bloc/patient_bloc.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class AdminPatientDialogs {
''' + ''.join(extracted_lines) + '''
}
'''

# The extracted methods are private (e.g. `void _showAddPatientDialog`). We need to make them public and static.
dialog_content = dialog_content.replace('String _generateUUID()', 'static String generateUUID()')
dialog_content = dialog_content.replace('int _calculateAge(', 'static int calculateAge(')
dialog_content = dialog_content.replace('void _showAddPatientDialog(', 'static void showAddPatientDialog(')
dialog_content = dialog_content.replace('void _showEditPatientDialog(', 'static void showEditPatientDialog(')
dialog_content = dialog_content.replace('void _showPatientDetailSheet(', 'static void showPatientDetailSheet(')
dialog_content = dialog_content.replace('void _showVitalsEntryDialog(', 'static void showVitalsEntryDialog(')

# Update internal calls
dialog_content = dialog_content.replace('_generateUUID()', 'generateUUID()')
dialog_content = dialog_content.replace('_calculateAge(', 'calculateAge(')
dialog_content = dialog_content.replace('_showVitalsEntryDialog(', 'showVitalsEntryDialog(')

with open(dest_path, 'w', encoding='utf-8') as f:
    f.write(dialog_content)

# Update original file
new_page_lines = lines[:start_idx] + lines[build_idx:]
new_page_content = ''.join(new_page_lines)
new_page_content = new_page_content.replace('_showAddPatientDialog(', 'AdminPatientDialogs.showAddPatientDialog(')
new_page_content = new_page_content.replace('_showEditPatientDialog(', 'AdminPatientDialogs.showEditPatientDialog(')
new_page_content = new_page_content.replace('_showPatientDetailSheet(', 'AdminPatientDialogs.showPatientDetailSheet(')

# Add import
import_stmt = "import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_patients/admin_patient_dialogs.dart';\n"
new_page_content = new_page_content.replace("import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_patients/patient_card.dart';", "import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_patients/patient_card.dart';\n" + import_stmt)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(new_page_content)

print("Successfully refactored admin_patients_page.dart!")
