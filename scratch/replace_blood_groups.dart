import 'dart:io';

import 'package:medi_connect/core/services/app_logger.dart';

void main() {
  final directory = Directory(
    r'c:\Users\lnell\Documents\workspace\GitHub\medi_connect\lib',
  );
  final importStmt =
      "import 'package:medi_connect/core/constants/app_constants.dart';\n";

  // Use raw triple quotes to avoid escape issues
  final bloodGroupsRegex1 = RegExp(
    r'''\[\s*["']A\+["']\s*,\s*["']A-["']\s*,\s*["']B\+["']\s*,\s*["']B-["']\s*,\s*["']O\+["']\s*,\s*["']O-["']\s*,\s*["']AB\+["']\s*,\s*["']AB-["']\s*\]''',
  );
  final bloodGroupsRegex2 = RegExp(
    r'''\[\s*["']A\+["']\s*,\s*["']A-["']\s*,\s*["']B\+["']\s*,\s*["']B-["']\s*,\s*["']AB\+["']\s*,\s*["']AB-["']\s*,\s*["']O\+["']\s*,\s*["']O-["']\s*\]''',
  );
  final defaultBloodGroupRegex = RegExp(r'''["']O\+["']''');

  for (final entity in directory.listSync(recursive: true)) {
    if (entity is File &&
        entity.path.endsWith('.dart') &&
        !entity.path.contains('app_constants.dart')) {
      final content = entity.readAsStringSync();
      final originalContent = content;

      String newContent = content;
      newContent = newContent.replaceAll(
        bloodGroupsRegex1,
        'AppConstants.bloodGroups',
      );
      newContent = newContent.replaceAll(
        bloodGroupsRegex2,
        'AppConstants.bloodGroups',
      );
      newContent = newContent.replaceAll(
        defaultBloodGroupRegex,
        'AppConstants.defaultBloodGroup',
      );

      if (newContent != originalContent) {
        if (!newContent.contains('app_constants.dart')) {
          final importRegex = RegExp(
            r'''^import\s+["'].*?["'];$''',
            multiLine: true,
          );
          final matches = importRegex.allMatches(newContent);
          if (matches.isNotEmpty) {
            final lastMatch = matches.last;
            newContent =
                '${newContent.substring(0, lastMatch.end)}\n$importStmt${newContent.substring(lastMatch.end)}';
          } else {
            newContent = '$importStmt\n$newContent';
          }
        }
        entity.writeAsStringSync(newContent);
        AppLogger.info('Updated: ${entity.path}');
      }
    }
  }
  AppLogger.info('Blood group replacements complete.');
}
