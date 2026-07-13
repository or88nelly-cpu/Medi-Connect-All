import 'dart:io';

void main() {
  final dir = Directory(
    'c:/Users/lnell/Documents/workspace/GitHub/medi_connect/lib',
  );
  for (var file in dir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      var content = file.readAsStringSync();
      var original = content;

      content = content.replaceAll(
        RegExp(
          r"\.role\s*==\s*['"
          '"'
          r"']doctor['"
          '"'
          r"']",
        ),
        '.role == UserRole.doctor',
      );
      content = content.replaceAll(
        RegExp(
          r"\.role\s*==\s*['"
          '"'
          r"']staff['"
          '"'
          r"']",
        ),
        '.role == UserRole.staff',
      );
      content = content.replaceAll(
        RegExp(
          r"\.role\s*==\s*['"
          '"'
          r"']admin['"
          '"'
          r"']",
        ),
        '.role == UserRole.admin',
      );
      content = content.replaceAll(
        RegExp(
          r"\.role\s*==\s*['"
          '"'
          r"']patient['"
          '"'
          r"']",
        ),
        '.role == UserRole.patient',
      );

      if (content != original) {
        // Also add import for UserRole if missing
        if (!content.contains('app_enum.dart')) {
          content =
              "import 'package:medi_connect/core/constants/app_enum.dart';\n$content";
        }
        file.writeAsStringSync(content);
        print('Updated \${file.path}');
      }
    }
  }
}
