import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import '../models/analytics_data.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/charts/bar_chart.dart';
import '../widgets/charts/pie_chart.dart';
import '../widgets/charts/line_chart.dart';
import '../widgets/cards/stat_card.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedTimeframe = 'This Month';
  final List<String> _timeframes = ['Today', 'This Week', 'This Month', 'This Quarter', 'This Year'];
  String _selectedDataType = 'Performance';
  final List<String> _dataTypes = ['Performance', 'Revenue', 'Users', 'Tasks'];
  
  // Mock analytics data
  late AnalyticsData _analyticsData;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  void _loadAnalyticsData() {
    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 800), () {
      // Generate mock analytics data
      _analyticsData = _generateMockData();
      setState(() {
        _isLoading = false;
      });
    });
  }
  
  AnalyticsData _generateMockData() {
    final random = Random();
    
    // Generate revenue data for the last 12 months
    final List<MonthlyRevenue> revenueData = List.generate(12, (i) {
      final month = DateTime.now().subtract(Duration(days: 30 * (11 - i)));
      return MonthlyRevenue(
        month: month,
        revenue: 50000 + random.nextDouble() * 30000,
        expenses: 25000 + random.nextDouble() * 15000,
        profit: 0, // Will be calculated
      );
    });
    
    // Calculate profit
    for (var data in revenueData) {
      data.profit = data.revenue - data.expenses;
    }
    
    // Generate user data
    final List<UserMetric> userData = List.generate(12, (i) {
      final month = DateTime.now().subtract(Duration(days: 30 * (11 - i)));
      return UserMetric(
        date: month,
        newUsers: 100 + random.nextInt(200),
        activeUsers: 500 + random.nextInt(1000),
        churnRate: random.nextDouble() * 5,
      );
    });
    
    // Generate traffic sources
    final List<TrafficSource> trafficSources = [
      TrafficSource(source: 'Direct', percentage: 25 + random.nextDouble() * 10),
      TrafficSource(source: 'Social Media', percentage: 20 + random.nextDouble() * 10),
      TrafficSource(source: 'Referral', percentage: 15 + random.nextDouble() * 10),
      TrafficSource(source: 'Organic Search', percentage: 30 + random.nextDouble() * 10),
      TrafficSource(source: 'Paid Ads', percentage: 10 + random.nextDouble() * 5),
    ];
    
    // Generate conversion metrics
    final ConversionMetrics conversionMetrics = ConversionMetrics(
      visitCount: 15000 + random.nextInt(5000),
      signupCount: 1200 + random.nextInt(800),
      conversionRate: 0, // Will be calculated
      averageOrderValue: 55 + random.nextDouble() * 15,
    );
    conversionMetrics.conversionRate = (conversionMetrics.signupCount / conversionMetrics.visitCount) * 100;
    
    // Generate performance metrics
    final PerformanceMetrics performanceMetrics = PerformanceMetrics(
      loadTime: 1.2 + random.nextDouble() * 0.8,
      errorRate: random.nextDouble() * 3,
      uptimePercentage: 99.5 + random.nextDouble() * 0.5,
      apiCalls: 250000 + random.nextInt(100000),
    );
    
    // Generate daily tasks data
    final List<TaskMetric> taskData = List.generate(30, (i) {
      final day = DateTime.now().subtract(Duration(days: 29 - i));
      return TaskMetric(
        date: day,
        completed: 5 + random.nextInt(15),
        created: 8 + random.nextInt(12),
        overdue: random.nextInt(5),
      );
    });
    
    return AnalyticsData(
      revenueData: revenueData,
      userData: userData,
      trafficSources: trafficSources,
      conversionMetrics: conversionMetrics,
      performanceMetrics: performanceMetrics,
      taskMetrics: taskData,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: CustomAppBar(title: 'Analytics'),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderControls(),
                const SizedBox(height: 16),
                _buildSummaryCards(),
                const SizedBox(height: 24),
                Text('Overview', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 16),
                _buildMainChart(),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildPieChartSection()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMetricsSection()),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDetailedAnalysisSection(),
              ],
            ),
          ),
    );
  }
  
  Widget _buildHeaderControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<String>(
          value: _selectedDataType,
          underline: Container(),
          items: _dataTypes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedDataType = newValue!;
            });
          },
        ),
        DropdownButton<String>(
          value: _selectedTimeframe,
          underline: Container(),
          items: _timeframes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedTimeframe = newValue!;
              _loadAnalyticsData(); // Reload data when timeframe changes
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            _loadAnalyticsData();
          },
          tooltip: 'Refresh data',
        ),
      ],
    );
  }
  
  Widget _buildSummaryCards() {
    final ConversionMetrics metrics = _analyticsData.conversionMetrics;
    final lastMonthRevenue = _analyticsData.revenueData.last;
    final lastMonthUsers = _analyticsData.userData.last;
    
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        StatCard(
          title: 'Revenue',
          value: '\$${lastMonthRevenue.revenue.toStringAsFixed(0)}',
          change: '+${((lastMonthRevenue.revenue / _analyticsData.revenueData[_analyticsData.revenueData.length - 2].revenue - 1) * 100).toStringAsFixed(1)}%',
          isPositive: true,
          icon: Icons.attach_money,
          color: Colors.green,
        ),
        StatCard(
          title: 'Users',
          value: '${lastMonthUsers.activeUsers}',
          change: '+${((lastMonthUsers.activeUsers / _analyticsData.userData[_analyticsData.userData.length - 2].activeUsers - 1) * 100).toStringAsFixed(1)}%',
          isPositive: true,
          icon: Icons.people,
          color: Colors.blue,
        ),
        StatCard(
          title: 'Conversion Rate',
          value: '${metrics.conversionRate.toStringAsFixed(1)}%',
          change: '-0.5%',
          isPositive: false,
          icon: Icons.swap_vert,
          color: Colors.orange,
        ),
        StatCard(
          title: 'Avg Order Value',
          value: '\$${metrics.averageOrderValue.toStringAsFixed(0)}',
          change: '+2.3%',
          isPositive: true,
          icon: Icons.shopping_cart,
          color: Colors.purple,
        ),
      ],
    );
  }
  
  Widget _buildMainChart() {
    switch (_selectedDataType) {
      case 'Revenue':
        return _buildRevenueChart();
      case 'Users':
        return _buildUserChart();
      case 'Tasks':
        return _buildTasksChart();
      case 'Performance':
      default:
        return _buildPerformanceChart();
    }
  }
  
  Widget _buildRevenueChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Revenue, expenses and profit for the last 12 months',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: CustomLineChart(
                data: _analyticsData.revenueData.map((data) => FlSpot(
                  data.month.millisecondsSinceEpoch.toDouble(),
                  data.revenue / 1000, // Show in thousands
                )).toList(),
                secondaryData: _analyticsData.revenueData.map((data) => FlSpot(
                  data.month.millisecondsSinceEpoch.toDouble(),
                  data.expenses / 1000, // Show in thousands
                )).toList(),
                tertiaryData: _analyticsData.revenueData.map((data) => FlSpot(
                  data.month.millisecondsSinceEpoch.toDouble(),
                  data.profit / 1000, // Show in thousands
                )).toList(),
                lineColors: [Colors.green, Colors.red, Colors.blue],
                lineLabels: ['Revenue', 'Expenses', 'Profit'],
                showDots: false,
                yAxisName: 'Amount (K)',
                xAxisLabels: _analyticsData.revenueData.map((data) => 
                  '${data.month.month}/${data.month.year.toString().substring(2)}'
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildUserChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Growth',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'New and active users over the last 12 months',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: CustomBarChart(
                data: _analyticsData.userData.map((data) => 
                  BarChartGroupData(
                    x: data.date.month, 
                    barRods: [
                      BarChartRodData(
                        toY: data.newUsers.toDouble(),
                        color: Colors.blue,
                        width: 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                      BarChartRodData(
                        toY: data.activeUsers.toDouble(),
                        color: Colors.green,
                        width: 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  )
                ).toList(),
                barLabels: ['New Users', 'Active Users'],
                barColors: [Colors.blue, Colors.green],
                xAxisLabels: _analyticsData.userData.map((data) => 
                  '${data.date.month}/${data.date.year.toString().substring(2)}'
                ).toList(),
                showValues: false,
                maxY: _analyticsData.userData.map((d) => d.activeUsers).reduce(max).toDouble() * 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksChart() {
    // Get last 7 days of task data
    final recentTasks = _analyticsData.taskMetrics.skip(_analyticsData.taskMetrics.length - 7).toList();
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tasks created, completed and overdue for the last 7 days',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: CustomBarChart(
                data: recentTasks.asMap().entries.map((entry) => 
                  BarChartGroupData(
                    x: entry.key, 
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.created.toDouble(),
                        color: Colors.blue,
                        width: 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                      BarChartRodData(
                        toY: entry.value.completed.toDouble(),
                        color: Colors.green,
                        width: 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                      BarChartRodData(
                        toY: entry.value.overdue.toDouble(),
                        color: Colors.red,
                        width: 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  )
                ).toList(),
                barLabels: ['Created', 'Completed', 'Overdue'],
                barColors: [Colors.blue, Colors.green, Colors.red],
                xAxisLabels: recentTasks.map((data) => 
                  '${data.date.day}/${data.date.month}'
                ).toList(),
                showValues: false,
                maxY: recentTasks.map((d) => max(d.created, max(d.completed, d.overdue))).reduce(max).toDouble() * 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceChart() {
    // Create performance trend data
    final List<FlSpot> performanceData = List.generate(24, (i) {
      final hour = i;
      final random = Random();
      double loadTime = 1.0 + sin(hour / 24 * 3.14) * 0.5 + random.nextDouble() * 0.3;
      return FlSpot(hour.toDouble(), loadTime);
    });
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Metrics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'System performance over the last 24 hours',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: CustomLineChart(
                data: performanceData,
                lineColors: [Colors.purple],
                lineLabels: ['Load Time (s)'],
                showDots: false,
                yAxisName: 'Time (s)',
                xAxisLabels: List.generate(24, (i) => '$i:00'),
                showAllLabels: false,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPerformanceMetricItem(
                  'Avg Load Time', 
                  '${_analyticsData.performanceMetrics.loadTime.toStringAsFixed(2)}s',
                  Icons.speed,
                  Colors.purple,
                ),
                _buildPerformanceMetricItem(
                  'Error Rate', 
                  '${_analyticsData.performanceMetrics.errorRate.toStringAsFixed(2)}%',
                  Icons.error_outline,
                  Colors.orange,
                ),
                _buildPerformanceMetricItem(
                  'Uptime', 
                  '${_analyticsData.performanceMetrics.uptimePercentage.toStringAsFixed(2)}%',
                  Icons.timer,
                  Colors.green,
                ),
                _buildPerformanceMetricItem(
                  'API Calls', 
                  '${(_analyticsData.performanceMetrics.apiCalls / 1000).toStringAsFixed(0)}K',
                  Icons.api,
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPerformanceMetricItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
  
  Widget _buildPieChartSection() {
    final data = _analyticsData.trafficSources;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Traffic Sources',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: CustomPieChart(
                sections: data.map((source) => PieChartSectionData(
                  color: _getColorForSource(source.source),
                  value: source.percentage,
                  title: '${source.percentage.toStringAsFixed(1)}%',
                  radius: 100,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )).toList(),
                centerText: 'Traffic',
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: data.map((source) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _getColorForSource(source.source),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(source.source),
                    const Spacer(),
                    Text('${source.percentage.toStringAsFixed(1)}%'),
                  ],
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getColorForSource(String source) {
    switch (source) {
      case 'Direct':
        return Colors.blue;
      case 'Social Media':
        return Colors.red;
      case 'Referral':
        return Colors.amber;
      case 'Organic Search':
        return Colors.green;
      case 'Paid Ads':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
  
  Widget _buildMetricsSection() {
    final metrics = _analyticsData.conversionMetrics;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conversion Metrics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildMetricItem(
              'Total Visits',
              '${metrics.visitCount}',
              Icons.visibility,
              Colors.blue,
            ),
            const Divider(),
            _buildMetricItem(
              'Signups',
              '${metrics.signupCount}',
              Icons.person_add,
              Colors.green,
            ),
            const Divider(),
            _buildMetricItem(
              'Conversion Rate',
              '${metrics.conversionRate.toStringAsFixed(2)}%',
              Icons.trending_up,
              Colors.orange,
            ),
            const Divider(),
            _buildMetricItem(
              'Avg Order Value',
              '\$${metrics.averageOrderValue.toStringAsFixed(2)}',
              Icons.shopping_cart,
              Colors.purple,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Navigate to detailed conversion analytics
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
              ),
              child: const Text('View Detailed Report'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMetricItem(String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailedAnalysisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Detailed Analysis', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildUserActivityCard(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildRevenueBreakdownCard(),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildUserActivityCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Engagement',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Monthly user activity metrics',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 16),
            DataTable(
              columnSpacing: 16,
              columns: const [
                DataColumn(label: Text('Month')),
                DataColumn(label: Text('New'), numeric: true),
                DataColumn(label: Text('Active'), numeric: true),
                DataColumn(label: Text('Churn %'), numeric: true),
              ],
              rows: _analyticsData.userData.skip(_analyticsData.userData.length - 6).map((data) => 
                DataRow(cells: [
                  DataCell(Text('${data.date.month}/${data.date.year.toString().substring(2)}')),
                  DataCell(Text('${data.newUsers}')),
                  DataCell(Text('${data.activeUsers}')),
                  DataCell(Text('${data.churnRate.toStringAsFixed(1)}%')),
                ])
              ).toList(),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Navigate to user analytics
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
              ),
              child: const Text('View User Report'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRevenueBreakdownCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Breakdown',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Monthly financial performance',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 16),
            DataTable(
              columnSpacing: 16,
              columns: const [
                DataColumn(label: Text('Month')),
                DataColumn(label: Text('Revenue'), numeric: true),
                DataColumn(label: Text('Expenses'), numeric: true),
                DataColumn(label: Text('Profit'), numeric: true),
              ],
              rows: _analyticsData.revenueData.skip(_analyticsData.revenueData.length - 6).map((data) => 
                DataRow(cells: [
                  DataCell(Text('${data.month.month}/${data.month.year.toString().substring(2)}')),
                  DataCell(Text('\$${data.revenue.toStringAsFixed(0)}')),
                  DataCell(Text('\$${data.expenses.toStringAsFixed(0)}')),
                  DataCell(Text('\$${data.profit.toStringAsFixed(0)}')),
                ])
              ).toList(),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Navigate to financial analytics
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
              ),
              child: const Text('View Financial Report'),
            ),
          ],
        ),
      ),
    );
  }
}