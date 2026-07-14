import 'package:flutter/material.dart';

class QuickActionData {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  const QuickActionData({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });
}
