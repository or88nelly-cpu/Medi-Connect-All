import 'package:medi_connect/features/admin/home/domain/entities/admin_dashboard_module_entity.dart';

/// Data model for Admin Control Center modules with JSON conversion helpers.
class AdminDashboardModuleModel extends AdminDashboardModuleEntity {
  const AdminDashboardModuleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.countText,
    required super.iconKey,
    required super.colorHex,
    required super.accentColorHex,
    super.routeName,
  });

  factory AdminDashboardModuleModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardModuleModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      countText: json['count_text'] as String? ?? '',
      iconKey: json['icon_key'] as String? ?? 'hospital',
      colorHex: json['color_hex'] as int? ?? 0xFF3B5BFD,
      accentColorHex: json['accent_color_hex'] as int? ?? 0xFF2563EB,
      routeName: json['route_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'count_text': countText,
      'icon_key': iconKey,
      'color_hex': colorHex,
      'accent_color_hex': accentColorHex,
      'route_name': routeName,
    };
  }
}
