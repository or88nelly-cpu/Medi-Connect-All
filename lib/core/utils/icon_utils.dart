import 'package:flutter/material.dart';

class IconUtils {
  static IconData fromString(String iconName) {
    switch (iconName) {
      // Management Cards
      case 'group':
        return Icons.group;
      case 'person':
        return Icons.person;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'medication':
        return Icons.medication;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'settings':
        return Icons.settings;

      // Quick Actions
      case 'person_add':
        return Icons.person_add;
      case 'medical_services':
        return Icons.medical_services;
      case 'badge':
        return Icons.badge;
      case 'event':
        return Icons.event;
      case 'science':
        return Icons.science;
      case 'inventory':
        return Icons.inventory;

      // Fallback
      default:
        return Icons.widgets;
    }
  }
}
