// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:csxi_app/services/data_service.dart';
import 'package:csxi_app/widgets/app_bar_widget.dart';
import 'package:csxi_app/widgets/side_menu.dart';
import 'package:csxi_app/config/routes.dart';
import 'package:csxi_app/widgets/charts/line_chart.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late String _currentRoute;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;
  late TextEditingController _departmentController;
  late TextEditingController _phoneController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _currentRoute = AppRoutes.profile;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    final user = DataService.getUser();
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _roleController = TextEditingController(text: user.role);
    _departmentController = TextEditingController(text: user.department);
    _phoneController = TextEditingController(text: user.phone);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _departmentController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = DataService.getUser();
    final menuItems = DataService.getMenuItems();
    final userStats = DataService.getUserStats();
    final userPerformance = DataService.getUserPerformanceData();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Profile',
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(user),
                  const SizedBox(height: 24),
                  _buildUserInfo(user),
                  const SizedBox(height: 24),
                  _buildUserStats(userStats),
                  const SizedBox(height: 24),
                  _buildPerformanceChart(userPerformance),
                  const SizedBox(height: 24),
                  _buildRecentActivity(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.avatar),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.role,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.business, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        user.department,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                _isEditing ? Icons.save : Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                  if (!_isEditing) {
                    // Save profile changes
                    _saveProfile();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(dynamic user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildFormField(
                label: 'Full Name',
                controller: _nameController,
                enabled: _isEditing,
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              _buildFormField(
                label: 'Email Address',
                controller: _emailController,
                enabled: _isEditing,
                icon: Icons.email,
              ),
              const SizedBox(height: 16),
              _buildFormField(
                label: 'Role',
                controller: _roleController,
                enabled: _isEditing,
                icon: Icons.work,
              ),
              const SizedBox(height: 16),
              _buildFormField(
                label: 'Department',
                controller: _departmentController,
                enabled: _isEditing,
                icon: Icons.business,
              ),
              const SizedBox(height: 16),
              _buildFormField(
                label: 'Phone Number',
                controller: _phoneController,
                enabled: _isEditing,
                icon: Icons.phone,
              ),
              if (_isEditing) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        filled: true,
        fillColor: enabled ? Colors.transparent : Colors.grey[100],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildUserStats(List<dynamic> stats) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: stats.length,
              itemBuilder: (context, index) {
                final stat = stats[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: stat.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stat.value,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: stat.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stat.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceChart(dynamic performanceData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Trends',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: CustomLineChart(
                data: performanceData,
                title: '',
                lineColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    final activities = DataService.getUserActivities();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: activity.color.withOpacity(0.2),
                    child: Icon(activity.icon, color: activity.color),
                  ),
                  title: Text(
                    activity.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(activity.description),
                  trailing: Text(
                    activity.time,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically send data to your backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }
}
