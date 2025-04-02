// lib/models/analytics_data.dart
import 'package:flutter/material.dart';
class BarChartData {
  final String category;
  final double value;
  final Color color;

  BarChartData({
    required this.category,
    required this.value,
    required this.color,
  });
}

class PieChartData {
  final String title;
  final double value;
  final Color color;

  PieChartData({
    required this.title,
    required this.value,
    required this.color,
  });
}

class LineChartData {
  final DateTime date;
  final double value;

  LineChartData({
    required this.date,
    required this.value,
  });
}

class TaskData {
  final String title;
  final int completed;
  final int total;
  final double percentage;
  final Color color;

  TaskData({
    required this.title,
    required this.completed,
    required this.total,
    required this.percentage,
    required this.color,
  });
}