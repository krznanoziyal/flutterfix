// lib/widgets/side_menu.dart
import 'package:flutter/material.dart';
import 'package:csxi_app/models/menu_item.dart';
import 'package:csxi_app/models/user_model.dart';
import 'package:csxi_app/services/theme_service.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  final List<MenuItem> menuItems;
  final String currentRoute;
  final Function(String) onRouteChanged;
  final User user;

  const SideMenu({
    super.key,
    required this.menuItems,
    required this.currentRoute,
    required this.onRouteChanged,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Drawer(
      elevation: 0,
      child: Container(
        color: Theme.of(context).cardColor,
        child: Column(
          children: [
            _buildUserHeader(context),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  final isSelected = item.route == currentRoute;

                  return ListTile(
                    leading: Icon(
                      item.icon,
                      color:
                          isSelected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).iconTheme.color,
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color:
                            isSelected
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: Theme.of(
                      context,
                    ).primaryColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () {
                      onRouteChanged(item.route);
                      Navigator.of(context).pushReplacementNamed(item.route);
                    },
                  );
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              title: Text(themeService.isDarkMode ? 'Light Mode' : 'Dark Mode'),
              onTap: () {
                themeService.toggleTheme();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(user.avatarUrl),
      ),
      accountName: Text(
        user.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      accountEmail: Text(
        user.role,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
