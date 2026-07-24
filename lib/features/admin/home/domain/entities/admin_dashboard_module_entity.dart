import 'package:equatable/equatable.dart';

/// Pure domain entity representing an Admin Control Center dashboard module card.
class AdminDashboardModuleEntity extends Equatable {
  /// Unique identifier for the module.
  final String id;

  /// Module display title (e.g., "Departments", "Doctors").
  final String title;

  /// Module descriptive subtitle explaining its function.
  final String description;

  /// Human-readable count string (e.g., "24 Departments", "86 Doctors").
  final String countText;

  /// Icon key or identifier for rendering 3D/glassmorphic icons.
  final String iconKey;

  /// Base primary hex color for background gradients & accent themes.
  final int colorHex;

  /// Secondary hex color for accent gradients & badges.
  final int accentColorHex;

  /// Optional route path triggered when tapping the card.
  final String? routeName;

  const AdminDashboardModuleEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.countText,
    required this.iconKey,
    required this.colorHex,
    required this.accentColorHex,
    this.routeName,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    countText,
    iconKey,
    colorHex,
    accentColorHex,
    routeName,
  ];
}
