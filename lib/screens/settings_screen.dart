import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../widgets/app_bar_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotificationsEnabled = false;
  String _selectedLanguage = 'English';
  double _textSize = 1.0;
  bool _useSystemTheme = false;

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
    'Russian'
  ];

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: CustomAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Use system theme'),
                    subtitle: const Text('Automatically match your system theme'),
                    value: _useSystemTheme,
                    onChanged: (value) {
                      setState(() {
                        _useSystemTheme = value;
                        if (value) {
                          final brightness = MediaQuery.of(context).platformBrightness;
                          themeService.setThemeMode(
                            brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light
                          );
                        }
                      });
                    },
                  ),
                  Visibility(
                    visible: !_useSystemTheme,
                    child: SwitchListTile(
                      title: const Text('Dark mode'),
                      subtitle: const Text('Toggle between light and dark theme'),
                      value: themeService.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        themeService.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Text size'),
                    subtitle: Slider(
                      min: 0.8,
                      max: 1.2,
                      divisions: 4,
                      label: _textSize == 1.0 ? 'Normal' : _textSize < 1.0 ? 'Smaller' : 'Larger',
                      value: _textSize,
                      onChanged: (value) {
                        setState(() {
                          _textSize = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Notifications',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('App notifications'),
                    subtitle: const Text('Receive notifications about tasks and events'),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Email notifications'),
                    subtitle: const Text('Receive notifications via email'),
                    value: _emailNotificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _emailNotificationsEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Language',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  border: InputBorder.none,
                ),
                value: _selectedLanguage,
                isExpanded: true,
                items: _languages.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Advanced',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Clear cache'),
                    subtitle: const Text('Free up storage space'),
                    trailing: const Icon(Icons.delete_outline),
                    onTap: () {
                      _showClearCacheDialog();
                    },
                  ),
                  ListTile(
                    title: const Text('Export data'),
                    subtitle: const Text('Download your dashboard data'),
                    trailing: const Icon(Icons.download_outlined),
                    onTap: () {
                      _showExportDialog();
                    },
                  ),
                  ListTile(
                    title: const Text('Privacy policy'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to privacy policy
                    },
                  ),
                  ListTile(
                    title: const Text('Terms of service'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to terms of service
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Account',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Change password'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to change password
                    },
                  ),
                  ListTile(
                    title: const Text('Log out'),
                    trailing: const Icon(Icons.logout),
                    onTap: () {
                      _showLogoutDialog();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'App Version: 1.0.0',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cache'),
          content: const Text('This will clear all cached data. Do you want to continue?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                // Clear cache logic
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully')),
                );
              },
              child: const Text('CLEAR'),
            ),
          ],
        );
      },
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Export Data'),
          content: const Text('Your data will be exported as a JSON file. Do you want to continue?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                // Export data logic
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data exported successfully')),
                );
              },
              child: const Text('EXPORT'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                // Logout logic
                Navigator.of(context).pop();
                // Navigate to login page
              },
              child: const Text('LOG OUT'),
            ),
          ],
        );
      },
    );
  }
}