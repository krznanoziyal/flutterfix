// lib/screens/projects_screen.dart
import 'package:flutter/material.dart';
import 'package:csxi_app/services/data_service.dart';
import 'package:csxi_app/widgets/app_bar_widget.dart';
import 'package:csxi_app/widgets/side_menu.dart';
import 'package:csxi_app/config/routes.dart';
import 'package:csxi_app/widgets/charts/bar_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late String _currentRoute;
  String _selectedFilter = 'All Projects';
  final List<String> _filters = [
    'All Projects',
    'In Progress',
    'Completed',
    'On Hold',
  ];

  @override
  void initState() {
    super.initState();
    _currentRoute = AppRoutes.projects;
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
    // final projects = DataService.getProjects();
    // final projectsChartData = DataService.getProjectChartData();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Projects',
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildProjectSummary(projects),
                  const SizedBox(height: 24),
                  _buildFilterRow(),
                  const SizedBox(height: 16),
                  // Expanded(child: _buildProjectList(projects)),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewProject,
        tooltip: 'Create Project',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProjectSummary(List<dynamic> projects) {
    final totalProjects = projects.length;
    final completedProjects =
        projects.where((p) => p.status == 'Completed').length;
    final inProgressProjects =
        projects.where((p) => p.status == 'In Progress').length;
    final onHoldProjects = projects.where((p) => p.status == 'On Hold').length;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Project Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            MediaQuery.of(context).size.width > 650
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn(
                      totalProjects.toString(),
                      'Total Projects',
                      Colors.blue,
                    ),
                    _buildStatColumn(
                      inProgressProjects.toString(),
                      'In Progress',
                      Colors.orange,
                    ),
                    _buildStatColumn(
                      completedProjects.toString(),
                      'Completed',
                      Colors.green,
                    ),
                    _buildStatColumn(
                      onHoldProjects.toString(),
                      'On Hold',
                      Colors.red,
                    ),
                  ],
                )
                : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(
                          totalProjects.toString(),
                          'Total Projects',
                          Colors.blue,
                        ),
                        _buildStatColumn(
                          inProgressProjects.toString(),
                          'In Progress',
                          Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(
                          completedProjects.toString(),
                          'Completed',
                          Colors.green,
                        ),
                        _buildStatColumn(
                          onHoldProjects.toString(),
                          'On Hold',
                          Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomBarChart(
                data: [],
                title: 'Project Completion Rate',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Projects',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedFilter,
              icon: const Icon(Icons.keyboard_arrow_down),
              items:
                  _filters.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectList(List<dynamic> allProjects) {
    // Filter projects based on selected filter
    final filteredProjects =
        _selectedFilter == 'All Projects'
            ? allProjects
            : allProjects
                .where((project) => project.status == _selectedFilter)
                .toList();

    if (filteredProjects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No $_selectedFilter found',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredProjects.length,
      itemBuilder: (context, index) {
        final project = filteredProjects[index];
        Color statusColor;

        switch (project.status) {
          case 'Completed':
            statusColor = Colors.green;
            break;
          case 'In Progress':
            statusColor = Colors.blue;
            break;
          case 'On Hold':
            statusColor = Colors.red;
            break;
          default:
            statusColor = Colors.grey;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _viewProjectDetails(project),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          project.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          project.status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    project.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  LinearPercentIndicator(
                    lineHeight: 8.0,
                    percent: project.progress / 100,
                    progressColor: statusColor,
                    backgroundColor: Colors.grey[200],
                    barRadius: const Radius.circular(8),
                    trailing: Text(
                      '${project.progress}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Due: ${project.dueDate}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.person, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Text(
                            'Team: ${project.teamSize} members',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _viewProjectDetails(dynamic project) {
    // Show dialog with project details
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(project.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: ${project.status}'),
                const SizedBox(height: 8),
                Text('Progress: ${project.progress}%'),
                const SizedBox(height: 8),
                Text('Due Date: ${project.dueDate}'),
                const SizedBox(height: 8),
                Text('Team Size: ${project.teamSize}'),
                const SizedBox(height: 16),
                const Text('Description:'),
                const SizedBox(height: 4),
                Text(project.description),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _createNewProject() {
    // Show dialog to create a new project
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Create New Project'),
            content: const Text(
              'This feature would allow you to create a new project.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }
}
