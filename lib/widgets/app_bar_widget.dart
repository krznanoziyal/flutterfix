// lib/widgets/app_bar_widget.dart
import 'package:flutter/material.dart';
import 'package:csxi_app/models/user_model.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final User user;
  final Function() onMenuTap;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.user,
    required this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: false,
      leading: IconButton(icon: const Icon(Icons.menu), onPressed: onMenuTap),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Search functionality can be added here
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Notifications functionality can be added here
          },
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl)),
        ),
      ],
      elevation: 0,
    );
  }
}
