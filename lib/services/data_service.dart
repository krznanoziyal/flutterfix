// lib/services/data_service.dart
import 'package:flutter/material.dart';
import 'package:csxi_app/models/menu_item.dart';
import 'package:csxi_app/models/analytics_data.dart';
import 'package:csxi_app/models/user_model.dart';
import 'package:csxi_app/config/routes.dart';
import 'dart:math';

class DataService {
  static final Random _random = Random();

  // Generate menu items
  static List<MenuItem> getMenuItems() {
    return [
      MenuItem(
        title: 'Dashboard',
        icon: Icons.dashboard,
        route: AppRoutes.dashboard,
      ),
      MenuItem(
        title: 'Analytics',
        icon: Icons.bar_chart,
        route: AppRoutes.analytics,
      ),
      MenuItem(
        title: 'Projects',
        icon: Icons.folder,
        route: AppRoutes.projects,
      ),
      MenuItem(
        title: 'Tasks',
        icon: Icons.check_circle_outline,
        route: AppRoutes.tasks,
      ),
      MenuItem(
        title: 'Messages',
        icon: Icons.message,
        route: AppRoutes.messages,
      ),
      MenuItem(
        title: 'Calendar',
        icon: Icons.calendar_today,
        route: AppRoutes.calendar,
      ),
      MenuItem(
        title: 'Settings',
        icon: Icons.settings,
        route: AppRoutes.settings,
      ),
      MenuItem(title: 'Profile', icon: Icons.person, route: AppRoutes.profile),
    ];
  }

  // Get user data
  static User getUser() {
    return User(
      name: 'Alex Johnson',
      email: 'alex.johnson@example.com',
      avatarUrl:
          'https://randomuser.me/api/portraits/men/32.jpg', // Replace with asset in production
      role: 'Product Manager',
    );
  }

  // Generate random bar chart data
  static List<BarChartData> getBarChartData() {
    final List<String> categories = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    final List<Color> colors = [
      Colors.blue.shade300,
      Colors.blue.shade400,
      Colors.blue.shade500,
      Colors.blue.shade600,
      Colors.blue.shade700,
      Colors.blue.shade800,
    ];

    return List.generate(
      categories.length,
      (index) => BarChartData(
        category: categories[index],
        value: 50 + _random.nextDouble() * 50,
        color: colors[index],
      ),
    );
  }

  // Generate random pie chart data
  static List<PieChartData> getPieChartData() {
    final List<String> titles = [
      'Product A',
      'Product B',
      'Product C',
      'Product D',
    ];
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];

    return List.generate(
      titles.length,
      (index) => PieChartData(
        title: titles[index],
        value: 15 + _random.nextDouble() * 35,
        color: colors[index],
      ),
    );
  }

  // Generate random line chart data
  static List<LineChartData> getLineChartData() {
    final now = DateTime.now();

    return List.generate(
      30,
      (index) => LineChartData(
        date: DateTime(now.year, now.month, now.day - (29 - index)),
        value: 100 + sin(index * 0.2) * 50 + _random.nextDouble() * 10,
      ),
    );
  }

  // Generate task data
  static List<TaskData> getTaskData() {
    final List<String> titles = ['UI Design', 'Frontend', 'Backend', 'Testing'];
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];

    return List.generate(titles.length, (index) {
      final total = 5 + _random.nextInt(10);
      final completed = _random.nextInt(total);
      return TaskData(
        title: titles[index],
        completed: completed,
        total: total,
        percentage: completed / total,
        color: colors[index],
      );
    });
  }

  // Get recent activity data
  static List<Map<String, dynamic>> getRecentActivities() {
    final List<Map<String, dynamic>> activities = [
      {
        'type': 'task_completed',
        'title': 'Dashboard design completed',
        'time': '2 hours ago',
        'icon': Icons.task_alt,
        'color': Colors.green,
      },
      {
        'type': 'comment',
        'title': 'New comment on project',
        'time': '4 hours ago',
        'icon': Icons.comment,
        'color': Colors.blue,
      },
      {
        'type': 'file',
        'title': 'New files uploaded',
        'time': 'Yesterday',
        'icon': Icons.file_present,
        'color': Colors.orange,
      },
      {
        'type': 'meeting',
        'title': 'Meeting with client',
        'time': 'Yesterday',
        'icon': Icons.video_call,
        'color': Colors.purple,
      },
    ];

    return activities;
  }
}
