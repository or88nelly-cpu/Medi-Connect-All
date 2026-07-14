import 'package:equatable/equatable.dart';

class DashboardWidgetModel extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final String icon;
  final String colorCode;
  final String route;
  final String widgetType;
  final bool isActive;
  final int orderIndex;

  const DashboardWidgetModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.colorCode,
    required this.route,
    required this.widgetType,
    required this.isActive,
    required this.orderIndex,
  });

  factory DashboardWidgetModel.fromJson(Map<String, dynamic> json) {
    return DashboardWidgetModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      icon: json['icon'] as String? ?? 'widgets',
      colorCode: json['color_code'] as String? ?? '#000000',
      route: json['route'] as String? ?? '/',
      widgetType: json['widget_type'] as String? ?? 'MANAGEMENT_CARD',
      isActive: json['is_active'] as bool? ?? true,
      orderIndex: json['order_index'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'icon': icon,
      'color_code': colorCode,
      'route': route,
      'widget_type': widgetType,
      'is_active': isActive,
      'order_index': orderIndex,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    icon,
    colorCode,
    route,
    widgetType,
    isActive,
    orderIndex,
  ];
}
