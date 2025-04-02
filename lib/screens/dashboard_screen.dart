// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:csxi_app/services/data_service.dart';
import 'package:csxi_app/widgets/app_bar_widget.dart';
import 'package:csxi_app/widgets/side_menu.dart';
import 'package:csxi_app/widgets/cards/info_card.dart';
import 'package:csxi_app/widgets/cards/stat_card.dart';
import 'package:csxi_app/widgets/cards/activity_card.dart';
import 'package:csxi_app/widgets/charts/bar_chart.dart';
import 'package:csxi_app/widgets/charts/pie_chart.dart';
import 'package:csxi_app/widgets/charts/line_chart.dart';
import 'package:csxi_app/config/routes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late String _currentRoute;

  @override
  void initState() {
    super.initState();
    _currentRoute = AppRoutes.dashboard;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = DataService.getUser();
    final menuItems = DataService.getMenuItems();
    final barChartData = DataService.getBarChartData();
    final pieChartData = DataService.getPieChartData();
    final lineChartData = DataService.getLineChartData();
    final taskData = DataService.getTaskData();
    final activities = DataService.getRecentActivities();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Dashboard',
        user: user,
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: SideMenu(
        menuItems: menuItems,
        currentRoute: _currentRoute,
        onRouteChanged: (route) {
          setState(() {
            _currentRoute = route;
          });
        },
        user: user,
      ),
      body: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Overview',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInfoCards(),
                const SizedBox(height: 24),
                const Text(
                  'Analytics',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                CustomLineChart(
                  data: [],
                  title: 'Performance Trends',
                  lineColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                _buildChartRow(
                  CustomBarChart(data: barChartData, title: 'Monthly Revenue'),
                  CustomPieChart(
                    data: pieChartData,
                    title: 'Sales Distribution', sections: [],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Current Projects',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildTaskCards(taskData),
                const SizedBox(height: 24),
                ActivityCard(activities: activities),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCards() {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 650 ? 4 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        InfoCard(
          title: 'Total Revenue',
          value: '\$24,500',
          icon: Icons.attach_money,
          color: Colors.green,
          trend: '12% increase',
          isPositive: true,
        ),
        InfoCard(
          title: 'Total Projects',
          value: '34',
          icon: Icons.folder,
          color: Colors.blue,
          trend: '5 new',
          isPositive: true,
        ),
        InfoCard(
          title: 'Tasks Pending',
          value: '12',
          icon: Icons.check_circle_outline,
          color: Colors.orange,
          trend: '3 overdue',
          isPositive: false,
        ),
        InfoCard(
          title: 'Team Members',
          value: '8',
          icon: Icons.people,
          color: Colors.purple,
          trend: '1 new',
          isPositive: true,
        ),
      ],
    );
  }

  Widget _buildChartRow(Widget left, Widget right) {
    if (MediaQuery.of(context).size.width > 800) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          const SizedBox(width: 16),
          Expanded(child: right),
        ],
      );
    } else {
      return Column(children: [left, const SizedBox(height: 16), right]);
    }
  }

  Widget _buildTaskCards(List<dynamic> tasks) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 650 ? 2 : 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3,
      ),
      itemCount: tasks.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return StatCard(
          title: task.title,
          completed: task.completed,
          total: task.total,
          percentage: task.percentage,
          color: task.color, value: '', change: '', isPositive: true, icon: task.icon,
          
        );
      },
    );
  }
}
