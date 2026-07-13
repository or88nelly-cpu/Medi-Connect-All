import 'dart:io';

void main() {
  final dir = Directory(
    'c:/Users/lnell/Documents/workspace/GitHub/medi_connect/lib',
  );
  for (var file in dir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      var content = file.readAsStringSync();
      var original = content;

      // Fix consultation_complete_sheet.dart
      if (file.path.contains('consultation_complete_sheet.dart')) {
        content = content.replaceAll(
          "savedToSupabase = true;\n\n      // Deduct stock\n      final pharmacyState = context.read",
          "savedToSupabase = true;\n\n      if (!context.mounted) return;\n      // Deduct stock\n      final pharmacyState = context.read",
        );
        content = content.replaceAll(
          "await Future.delayed(const Duration(seconds: 1));\n\n      ScaffoldMessenger.of(context).showSnackBar",
          "await Future.delayed(const Duration(seconds: 1));\n\n      if (!context.mounted) return;\n      ScaffoldMessenger.of(context).showSnackBar",
        );
        content = content.replaceAll(
          "await Future.delayed(const Duration(seconds: 1));\n      context.pop();",
          "await Future.delayed(const Duration(seconds: 1));\n      if (!context.mounted) return;\n      context.pop();",
        );
      }

      if (file.path.contains('doctor_profile_admin_view.dart')) {
        content = content.replaceAll(
          "if (res == true) {\n                context.read",
          "if (res == true && context.mounted) {\n                context.read",
        );
        content = content.replaceAll(
          "if (res == true) {\n                          context.read",
          "if (res == true && context.mounted) {\n                          context.read",
        );
      }

      if (file.path.contains('human_resource_detail_page.dart')) {
        content = content.replaceAll(
          "if (res == true) {\n            if (context.mounted) {",
          "if (res == true) {\n            if (context.mounted) {",
        );
      }

      if (file.path.contains('slot_management_grid.dart')) {
        content = content.replaceAll(
          "if (res == true) {\n            context.read",
          "if (res == true && context.mounted) {\n            context.read",
        );
        content = content.replaceAll(
          "await Future.delayed(const Duration(milliseconds: 500));\n                context.read",
          "await Future.delayed(const Duration(milliseconds: 500));\n                if (!context.mounted) return;\n                context.read",
        );
      }

      if (file.path.contains('attendance_proximity_dialog.dart')) {
        content = content.replaceAll(
          "ScaffoldMessenger.of(context).showSnackBar",
          "if (context.mounted) ScaffoldMessenger.of(context).showSnackBar",
        );
        content = content.replaceAll(
          "Navigator.pop(context);",
          "if (context.mounted) Navigator.pop(context);",
        );
      }

      if (file.path.contains('health_page.dart')) {
        content = content.replaceAll(
          "ScaffoldMessenger.of(context).showSnackBar",
          "if (context.mounted) ScaffoldMessenger.of(context).showSnackBar",
        );
      }

      if (content != original) {
        file.writeAsStringSync(content);
        print('Updated \${file.path}');
      }
    }
  }
}
