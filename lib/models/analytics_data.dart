// File: models/analytics_data.dart

import 'package:flutter/material.dart';

/// Main container class for all analytics data
class AnalyticsData {
  final List<MonthlyRevenue> revenueData;
  final List<UserMetric> userData;
  final List<TrafficSource> trafficSources;
  final ConversionMetrics conversionMetrics;
  final PerformanceMetrics performanceMetrics;
  final List<TaskMetric> taskMetrics;

  AnalyticsData({
    required this.revenueData,
    required this.userData,
    required this.trafficSources,
    required this.conversionMetrics,
    required this.performanceMetrics,
    required this.taskMetrics,
  });
}

/// Revenue data for a specific month
class MonthlyRevenue {
  final DateTime month;
  final double revenue;
  final double expenses;
  double profit; // Calculated as revenue - expenses

  MonthlyRevenue({
    required this.month,
    required this.revenue,
    required this.expenses,
    this.profit = 0,
  });
}

/// User metrics for a specific time period
class UserMetric {
  final DateTime date;
  final int newUsers;
  final int activeUsers;
  final double churnRate;

  UserMetric({
    required this.date,
    required this.newUsers,
    required this.activeUsers,
    required this.churnRate,
  });
}

/// Traffic source with percentage distribution
class TrafficSource {
  final String source;
  final double percentage;

  TrafficSource({required this.source, required this.percentage});
}

/// Conversion metrics for visitors to users/customers
class ConversionMetrics {
  final int visitCount;
  final int signupCount;
  double conversionRate; // Calculated as (signupCount / visitCount) * 100
  final double averageOrderValue;

  ConversionMetrics({
    required this.visitCount,
    required this.signupCount,
    this.conversionRate = 0,
    required this.averageOrderValue,
  });
}

/// Performance metrics for system health monitoring
class PerformanceMetrics {
  final double loadTime;
  final double errorRate;
  final double uptimePercentage;
  final int apiCalls;

  PerformanceMetrics({
    required this.loadTime,
    required this.errorRate,
    required this.uptimePercentage,
    required this.apiCalls,
  });
}

/// Task metrics for tracking task completion
class TaskMetric {
  final DateTime date;
  final int completed;
  final int created;
  final int overdue;

  TaskMetric({
    required this.date,
    required this.completed,
    required this.created,
    required this.overdue,
  });
}
