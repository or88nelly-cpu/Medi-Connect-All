/// Data model for activity log entries with JSON serialization.
import 'dart:developer';

import 'package:medi_connect/features/dash_board/domain/entities/activity_log_entity.dart';

class ActivityLogModel extends ActivityLogEntity {
  const ActivityLogModel({
    required super.id,
    required super.message,
    required super.category,
    required super.createdAt,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    log("json value $json");
    return ActivityLogModel(
      id: json['id']?.toString() ?? '',
      message: _generateMessage(json),
      category: _generateCategory(json),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  static String _generateMessage(Map<String, dynamic> json) {
    if (json.containsKey('message') && json['message'] != null && (json['message'] as String).isNotEmpty) {
      return json['message'] as String;
    }

    final rawAction = json['action_type'] as String? ?? '';
    final rawEntity = json['entity_name'] as String? ?? '';
    final oldValues = json['old_values'] as Map<String, dynamic>?;
    final newValues = json['new_values'] as Map<String, dynamic>?;

    if (rawAction.isEmpty) {
      return 'System event logged.';
    }

    // Format action type
    String action = 'Modified';
    if (rawAction == 'INSERT') action = 'Created';
    if (rawAction == 'DELETE') action = 'Deleted';
    if (rawAction == 'UPDATE') action = 'Updated';

    // Format entity name
    String entity = rawEntity;
    switch (rawEntity.toLowerCase()) {
      case 'users':
      case 'profiles':
        entity = 'User';
        break;
      case 'pharmacy_inventory':
        entity = 'Pharmacy Inventory';
        break;
      case 'lab_records':
        entity = 'Lab Record';
        break;
      case 'staff_attendance':
        entity = 'Staff Attendance';
        break;
      case 'emergency_alerts':
        entity = 'Emergency Alert';
        break;
      case 'invoices':
        entity = 'Invoice';
        break;
      case 'admin_settings':
        entity = 'Admin Settings';
        break;
    }

    // Identify target identifier (name of item/person)
    final values = (rawAction == 'DELETE') ? oldValues : newValues;
    String target = '';
    if (values != null) {
      target = values['name']?.toString() ?? 
               values['staff_name']?.toString() ?? 
               values['patient_name']?.toString() ?? 
               values['message']?.toString() ?? 
               values['key']?.toString() ?? 
               '';
    }

    String details = '';
    if (rawAction == 'UPDATE' && oldValues != null && newValues != null) {
      final List<String> changes = [];
      newValues.forEach((key, newValue) {
        final oldValue = oldValues[key];
        if (oldValue != newValue) {
          if (key == 'metadata') {
            final oldMeta = oldValue is Map ? oldValue : {};
            final newMeta = newValue is Map ? newValue : {};
            newMeta.forEach((mKey, mNewVal) {
              final mOldVal = oldMeta[mKey];
              if (mOldVal != mNewVal) {
                changes.add('${_formatFieldName(mKey)} to "$mNewVal"');
              }
            });
          } else if (key != 'updated_at' && key != 'created_at') {
            changes.add('${_formatFieldName(key)} to "$newValue"');
          }
        }
      });
      if (changes.isNotEmpty) {
        details = ': ' + changes.join(', ');
      }
    }

    if (target.isNotEmpty) {
      return '$action $entity "$target"$details';
    } else {
      return '$action $entity$details';
    }
  }

  static String _formatFieldName(String field) {
    if (field.isEmpty) return '';
    final words = field.split('_');
    return words.map((w) {
      if (w.isEmpty) return '';
      return w[0].toUpperCase() + w.substring(1);
    }).join(' ');
  }

  static String _generateCategory(Map<String, dynamic> json) {
    if (json.containsKey('category') && json['category'] != null && (json['category'] as String).isNotEmpty) {
      return json['category'] as String;
    }

    final entityName = json['entity_name'] as String? ?? '';
    switch (entityName.toLowerCase()) {
      case 'users':
      case 'profiles':
        return 'User';
      case 'pharmacy_inventory':
        return 'Pharmacy';
      case 'lab_records':
        return 'Lab';
      case 'staff_attendance':
        return 'Attendance';
      case 'emergency_alerts':
        return 'Emergency';
      case 'invoices':
        return 'Billing';
      case 'admin_settings':
        return 'System';
      default:
        return 'System';
    }
  }

  Map<String, dynamic> toJson() => {'message': message, 'category': category};
}
