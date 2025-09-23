import 'package:flutter/material.dart';

/// Model for bottom navigation items
class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationItem &&
          runtimeType == other.runtimeType &&
          icon == other.icon &&
          activeIcon == other.activeIcon &&
          label == other.label &&
          route == other.route;

  @override
  int get hashCode => 
      icon.hashCode ^ 
      activeIcon.hashCode ^ 
      label.hashCode ^ 
      route.hashCode;
}