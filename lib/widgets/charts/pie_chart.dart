// lib/widgets/charts/pie_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:csxi_app/models/analytics_data.dart';

class CustomPieChart extends StatefulWidget {
  final List<PieChartData> data;
  final String title;

  const CustomPieChart({super.key, required this.data, required this.title});

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  int touchedIndex = -1;

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
            Text(
              widget.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (
                            FlTouchEvent event,
                            pieTouchResponse,
                          ) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex =
                                  pieTouchResponse
                                      .touchedSection!
                                      .touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: _buildSections(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: _buildLegend(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return widget.data
        .asMap()
        .map<int, PieChartSectionData>((index, data) {
          final isTouched = index == touchedIndex;
          final fontSize = isTouched ? 16.0 : 14.0;
          final radius = isTouched ? 60.0 : 50.0;

          return MapEntry(
            index,
            PieChartSectionData(
              color: data.color,
              value: data.value,
              title: '${data.value.toStringAsFixed(1)}%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        })
        .values
        .toList();
  }

  List<Widget> _buildLegend() {
    return widget.data.map((data) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: data.color,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                data.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
