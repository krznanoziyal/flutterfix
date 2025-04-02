// lib/config/routes.dart
import 'package:flutter/material.dart';
import 'package:csxi_app/screens/dashboard_screen.dart';
import 'package:csxi_app/screens/profile_screen.dart';
import 'package:csxi_app/screens/analytics_screen.dart';
import 'package:csxi_app/screens/projects_screen.dart';
import 'package:csxi_app/screens/messages_screen.dart';
import 'package:csxi_app/screens/calendar_screen.dart';
import 'package:csxi_app/screens/settings_screen.dart';
import 'package:csxi_app/screens/tasks_screen.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String profile = '/profile';
  static const String analytics = '/analytics';
  static const String projects = '/projects';
  static const String messages = '/messages';
  static const String calendar = '/calendar';
  static const String settings = '/settings';
  static const String tasks = '/tasks';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case analytics:
        return MaterialPageRoute(builder: (_) => const AnalyticsScreen());
      case projects:
        return MaterialPageRoute(builder: (_) => const ProjectsScreen());
      case messages:
        return MaterialPageRoute(builder: (_) => const MessagesScreen());
      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case tasks:
        return MaterialPageRoute(builder: (_) => const TasksScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
