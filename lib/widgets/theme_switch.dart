// lib/widgets/theme_switch.dart
import 'package:flutter/material.dart';
import 'package:csxi_app/services/theme_service.dart';
import 'package:provider/provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Switch(
      value: themeService.isDarkMode,
      onChanged: (value) {
        themeService.toggleTheme();
      },
      activeColor: Theme.of(context).primaryColor,
    );
  }
}
