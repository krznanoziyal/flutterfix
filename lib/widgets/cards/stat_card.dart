// lib/widgets/cards/stat_card.dart
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StatCard extends StatelessWidget {
  final String title;
  final int completed;
  final int total;
  final double percentage;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.completed,
    required this.total,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal:
                     8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$completed/$total',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearPercentIndicator(
              animation: true,
              lineHeight: 10.0,
              animationDuration: 1000,
              percent: percentage,
              barRadius: const Radius.circular(10),
              progressColor: color,
              backgroundColor: color.withOpacity(0.1),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}